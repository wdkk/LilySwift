//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

#if os(iOS) || os(watchOS) || os(visionOS)

import UIKit
#if canImport(Metal)
import Metal
import MetalKit
#endif

public extension UIImage
{    
    var llImage:LLImage {
        let lcimg = UIImage2LCImage( self )
        return LLImage( lcimg )
    }
    
    #if !os(watchOS)
    func BGRtoRGB() -> UIImage {
        let code = """
        #include <metal_stdlib>
        using namespace metal;

        kernel void bgraToRgba(
            texture2d<half, access::sample> inputTexture [[ texture(0) ]],
            texture2d<half, access::write> outputTexture [[ texture(1) ]],
            uint2 gid [[thread_position_in_grid]]
        )
        {
            half4 color = inputTexture.read( gid );
            outputTexture.write( color.rgba, gid );
        }
        """
                
        guard let device = MTLCreateSystemDefaultDevice(), let commandQueue = device.makeCommandQueue() else { return self }
        
        guard let cgImage = self.cgImage else { return self }
        
        let textureLoader = MTKTextureLoader(device: device)
        guard let inputTexture = try? textureLoader.newTexture(
            cgImage:cgImage, 
            options:[
                .origin:MTKTextureLoader.Origin.bottomLeft  // TODO:上下反転がこれでうまくいくが万能か不明
            ]   
        )
        else { return self }
        
        // Create Metal texture for output image
        let outputTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor( 
            pixelFormat:.rgba8Unorm,
            width: inputTexture.width, 
            height: inputTexture.height,
            mipmapped:false
        )
        outputTextureDescriptor.usage = [ .shaderRead, .shaderWrite ]
        
        guard let outputTexture = device.makeTexture(descriptor: outputTextureDescriptor) else { return self }
        
        // Create Metal compute pipeline
        //let defaultLibrary = device.makeDefaultLibrary()
        let kernelFunction = Lily.Metal.Shader( device:device, code:code, shaderName:"bgraToRgba" )
        
        do {
            let pipelineState = try device.makeComputePipelineState(function: kernelFunction.function! )
            
            // Create Metal command buffer and encoder
            guard let commandBuffer = commandQueue.makeCommandBuffer(),
                  let commandEncoder = commandBuffer.makeComputeCommandEncoder() 
            else {
                return self
            }
            
            // Set up thread groups
            let threadGroupCount = MTLSizeMake(16, 16, 1)
            let threadGroups = MTLSizeMake(outputTexture.width / threadGroupCount.width, outputTexture.height / threadGroupCount.height, 1)
            
            // Encode kernel function
            commandEncoder.setComputePipelineState(pipelineState)
            commandEncoder.setTexture(inputTexture, index: 0)
            commandEncoder.setTexture(outputTexture, index: 1)
            commandEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
            commandEncoder.endEncoding()
            
            // Commit command buffer and wait for completion
            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
            
            // Convert output texture to UIImage
            let ciContext = CIContext(mtlDevice: device)
            let ciImage = CIImage(mtlTexture: outputTexture, options: nil)
            guard let cgImage = ciContext.createCGImage( 
                ciImage!, 
                from: CGRect(x: 0, y: 0, width: outputTexture.width, height: outputTexture.height)
            )
            else {
                return self
            }
            
            let outputImage = UIImage(cgImage: cgImage)
            return outputImage
        }
        catch {
            print("Error creating compute pipeline state: \(error.localizedDescription)")
            return self
        }
    }
    #else
    // watchOS版. 変換に失敗した場合は変換せずに返す
    func BGRtoRGB() -> UIImage {
        var llimg = self.llImage
        let type = llimg.type
        llimg.convertType(to:.rgbaf )
        
        let width = llimg.width
        let height = llimg.height
        guard let mat = llimg.rgbafMatrix else { return self }
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                let swap = mat[y][x].R
                mat[y][x].R = mat[y][x].B
                mat[y][x].B = swap
            }
        }
        
        return llimg.uiImage ?? self
    }
    #endif
}

#endif
