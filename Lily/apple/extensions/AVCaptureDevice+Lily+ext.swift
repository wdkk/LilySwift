//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY_FULL

import Foundation
import AVFoundation

public extension AVCaptureDevice 
{
    private func availableFormatsFor( preferredFps: Double ) 
    -> [AVCaptureDevice.Format]
    {
        var result_formats:[AVCaptureDevice.Format] = [AVCaptureDevice.Format]()
        
        for format in self.formats {
            let ranges = format.videoSupportedFrameRateRanges
            for range in ranges where range.minFrameRate <= preferredFps && preferredFps <= range.maxFrameRate {
                result_formats.append( format )
            }
        }
        
        return result_formats
    }
    
    private func selectFormat( preferredSize:CGSize, availableFormats:[AVCaptureDevice.Format] )
    -> AVCaptureDevice.Format? 
    {
        for format in availableFormats {
            let dimensions = CMVideoFormatDescriptionGetDimensions( format.formatDescription )
            
            if dimensions.width >= preferredSize.width.i32! && 
               dimensions.height >= preferredSize.height.i32! {
                return format
            }
        }
        return nil
    }
    
    func setupSetting( preferredSize:CGSize, fps:Int ) {
        let available_formats: [AVCaptureDevice.Format]
        available_formats = availableFormatsFor( preferredFps: fps.d )

        let format = selectFormat( preferredSize:preferredSize, availableFormats: available_formats )
        
        if let fps_i32 = fps.i32, let nonnull_format = format {
            do {
                try self.lockForConfiguration()
             
                self.activeFormat = nonnull_format
                self.activeVideoMinFrameDuration = CMTimeMake( value:1, timescale:fps_i32 )
                self.activeVideoMaxFrameDuration = CMTimeMake( value:1, timescale:fps_i32 )
        
                self.unlockForConfiguration()   
            }
            catch {
            
            }
        }
    }
}

#endif
