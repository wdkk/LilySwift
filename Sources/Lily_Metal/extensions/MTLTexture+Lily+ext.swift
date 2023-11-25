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

import Metal
import MetalKit
import QuartzCore

extension MTLTexture 
{
    private func getUnsafeMemory( mipmapLevel:Int = 0 ) -> UnsafeMutableRawPointer {
        let width    = self.width
        let height   = self.height
        let rowBytes = self.width * 4
        let buf = UnsafeMutableRawPointer.allocate( byteCount:width * height * 4, alignment: 4 )
        
        self.getBytes( 
            buf, 
            bytesPerRow: rowBytes, 
            from: MTLRegionMake2D(0, 0, width, height),
            mipmapLevel:mipmapLevel
        )
        
        return buf
    }

    public var cgImage:CGImage? {
        let p = getUnsafeMemory()
        
        let pColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let rawBitmapInfo = CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        let bitmapInfo = CGBitmapInfo(rawValue: rawBitmapInfo)
        
        let byteSize = self.width * self.height * 4
        let rowBytes = self.width * 4
        guard let provider = CGDataProvider(
                dataInfo: nil,
                data: p, 
                size: byteSize, 
                releaseData: { _,_,_ in }
        )
        else {
            p.deallocate()
            return nil
        }
        
        let cgimg = CGImage(
            width: self.width, 
            height: self.height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: rowBytes,
            space: pColorSpace, 
            bitmapInfo: bitmapInfo,
            provider: provider,
            decode: nil,
            shouldInterpolate: true, 
            intent: CGColorRenderingIntent.defaultIntent
        )
        
        p.deallocate()
        
        return cgimg
    }
}
