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

#if os(macOS)

import AppKit

public extension NSImage 
{
    var cgImage:CGImage? {
        var imageRect = NSRect( x: 0, y: 0, width: size.width, height: size.height )
        guard let image = cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
            return nil
        }
        return image
    }
    
    var llImage:LLImage? {
        let lcimg = NSImage2LCImage( self )
        if LCImageWidth( lcimg ) == 0 { return nil }
        return LLImage( lcimg )
        /*
        guard let cgimg = self.cgImage else { return nil }
        let lcimg = CGImage2LCImage( cgimg )
        return LLImage( lcimg )
        */
    }
}

#endif
