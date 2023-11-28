//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal
import MetalKit
import QuartzCore

extension Lily.Metal
{
    open class Texture
    {
        public static func create(
            device:MTLDevice,
            bundlePath: String,
            sRGB: Bool = false,
            generateMips: Bool = false,
            storageMode:MTLResourceOptions = .storageModePrivate
        )
        throws
        -> MTLTexture?
        {
            let loader = MTKTextureLoader( device:device )
            
            let options:[MTKTextureLoader.Option:Any] = [
                .SRGB:NSNumber( booleanLiteral:sRGB ),
                .generateMipmaps:NSNumber( booleanLiteral:generateMips ), 
                .textureUsage:NSNumber( value:MTLTextureUsage.pixelFormatView.rawValue | MTLTextureUsage.shaderRead.rawValue ),
                .textureStorageMode: NSNumber( value:storageMode.rawValue )
            ]
            
            let url = LLPath.bundle( bundlePath ).fileUrl
            
            do {
                return try loader.newTexture( URL:url, options:options )
            }
            catch {
                let reason = "Error loading texture [bundleName](\(bundlePath)) : \(error.localizedDescription)"
                throw NSError( 
                    domain:"Texture loading exception", 
                    code: 0,
                    userInfo: [NSLocalizedFailureReasonErrorKey: reason] 
                )
            }
        }
        
        public static func create(
            device:MTLDevice,
            assetName: String,
            sRGB: Bool = false,
            generateMips: Bool = false,
            storageMode:MTLResourceOptions = .storageModePrivate
        )
        throws 
        -> MTLTexture?
        {
            let loader = MTKTextureLoader( device:device )
            
            let options:[MTKTextureLoader.Option:Any] = [
                .SRGB:NSNumber( booleanLiteral:sRGB ),
                .generateMipmaps:NSNumber( booleanLiteral:generateMips ), 
                .textureUsage:NSNumber( value:MTLTextureUsage.pixelFormatView.rawValue | MTLTextureUsage.shaderRead.rawValue ),
                .textureStorageMode: NSNumber( value:storageMode.rawValue )
            ]
            
            do {
                guard let asset = NSDataAsset( name:assetName ) else { return nil }
                return try loader.newTexture( data:asset.data, options:options )
            }
            catch {
                let reason = "Error loading texture [assetName](\(assetName)): \(error.localizedDescription)"
                throw NSError( 
                    domain:"Texture loading exception", 
                    code: 0,
                    userInfo: [NSLocalizedFailureReasonErrorKey: reason] 
                )
            }
        }
        
        // Lily画像オブジェクトからの作成
        public static func create( 
            device:MTLDevice, 
            llImage img:LLImage
        ) 
        throws
        -> MTLTexture?
        {
            let reg = MTLRegionMake2D( 0, 0, img.width, img.height )
            guard let memory = img.memory, 
                let pointer = UnsafeRawPointer( memory ) 
            else { 
                let reason = "メモリが取得できませんでした"
                LLLogWarning( reason )
                throw NSError( 
                    domain:"Texture loading exception", 
                    code: 0,
                    userInfo: [NSLocalizedFailureReasonErrorKey: reason] 
                )
            }
            
            switch img.type {
                case .rgba8:
                    let tex = allocate( device:device, width:img.width, height:img.height )
                    tex?.replace( region: reg, mipmapLevel:0, withBytes: pointer, bytesPerRow: img.rowBytes )
                    return tex
                case .rgba16:
                    let tex = allocate( device:device, width:img.width, height:img.height, pixelFormat:.rgba16Unorm )
                    tex?.replace( region: reg, mipmapLevel:0, withBytes: pointer, bytesPerRow: img.rowBytes )
                    return tex
                case .rgbaf:
                    let tex = allocate( device:device, width:img.width, height:img.height, pixelFormat:.rgba32Float )
                    tex?.replace( region: reg, mipmapLevel:0, withBytes: pointer, bytesPerRow: img.rowBytes )
                    return tex
                default:
                    let reason = "未対応のLLImageの形式です." 
                    LLLogWarning( reason )
                    throw NSError( 
                        domain:"Texture loading exception", 
                        code: 0,
                        userInfo: [NSLocalizedFailureReasonErrorKey: reason] 
                    )
            }
        }
        
        private static func allocate(
            device:MTLDevice,
            width:Int,
            height:Int,
            pixelFormat:MTLPixelFormat = .rgba8Unorm,
            usage:MTLTextureUsage = [.shaderRead, .shaderWrite] 
        )
        -> MTLTexture?
        {
            let tex_desc = MTLTextureDescriptor.texture2DDescriptor(
                pixelFormat: pixelFormat,
                width: width,
                height: height,
                mipmapped: false 
            )

            tex_desc.usage = usage
            
            return device.makeTexture( descriptor:tex_desc )
        }
    }
}
