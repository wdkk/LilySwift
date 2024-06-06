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

#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)

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
        var img = self.llImage
        img.convertType( to:.rgbaf )
        
        let width = img.width
        let height = img.height
        guard let mat = img.rgbafMatrix else { return self }
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                LLSwap(&mat[y][x].R, &mat[y][x].B)
            }
        }
        
        return img.uiImage ?? self
    }
    #endif
    
    func fixedOrientation() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        guard let colorSpace = cgImage.colorSpace else { return nil }
        
        if self.imageOrientation == .up { return self }

        var transform = CGAffineTransform.identity

        // 回転の修正
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }

        // 反転の修正
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        guard let context = CGContext(
            data: nil,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: cgImage.bitmapInfo.rawValue
        ) else {
            return nil
        }

        context.concatenate(transform)

        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }

        guard let newCgImage = context.makeImage() else { return nil }

        return UIImage(cgImage: newCgImage)
    }
}

#endif
