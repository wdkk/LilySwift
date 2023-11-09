//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import MetalKit
import simd

extension Lily.Stage
{
    open class Texture
    {
        static func create(
            device:MTLDevice,
            filePath: String,
            sRGB: Bool = false,
            generateMips: Bool = false,
            storageMode:MTLResourceOptions = .storageModePrivate
        )
        throws 
        -> MTLTexture 
        {
            let loader = MTKTextureLoader( device:device )
            
            let options:[MTKTextureLoader.Option:Any] = [
                .SRGB:NSNumber( booleanLiteral:sRGB ),
                .generateMipmaps:NSNumber( booleanLiteral:generateMips ), 
                .textureUsage:NSNumber( value:MTLTextureUsage.pixelFormatView.rawValue | MTLTextureUsage.shaderRead.rawValue ),
                .textureStorageMode: NSNumber( value:storageMode.rawValue )
            ]
            
            let url = LLPath.bundle( filePath ).fileUrl
            
            do {
                return try loader.newTexture( URL:url, options:options )
            }
            catch {
                let reason = "Error loading texture (\(filePath)): \(error.localizedDescription)"
                throw NSError( 
                    domain:"Texture loading exception", 
                    code: 0,
                    userInfo: [NSLocalizedFailureReasonErrorKey: reason] 
                )
            }
        }
        
        static func create(
            device:MTLDevice,
            assetName: String,
            scaleFactor:CGFloat = 1.0,
            sRGB: Bool = false,
            generateMips: Bool = false,
            storageMode:MTLResourceOptions = .storageModePrivate
        )
        throws 
        -> MTLTexture 
        {
            let loader = MTKTextureLoader( device:device )
            
            let options:[MTKTextureLoader.Option:Any] = [
                .SRGB:NSNumber( booleanLiteral:sRGB ),
                .generateMipmaps:NSNumber( booleanLiteral:generateMips ), 
                .textureUsage:NSNumber( value:MTLTextureUsage.pixelFormatView.rawValue | MTLTextureUsage.shaderRead.rawValue ),
                .textureStorageMode: NSNumber( value:storageMode.rawValue )
            ]
            
            do {
                return try loader.newTexture( 
                    name:assetName,
                    scaleFactor:scaleFactor,
                    bundle: Bundle.main,
                    options:options
                )
            }
            catch {
                let reason = "Error loading texture (\(assetName)): \(error.localizedDescription)"
                throw NSError( 
                    domain:"Texture loading exception", 
                    code: 0,
                    userInfo: [NSLocalizedFailureReasonErrorKey: reason] 
                )
            }
        }
    }
}