//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import CoreGraphics

public protocol LLUIPixelControllable : AnyObject
{
    var ourBounds:CGRect { get set }
    
    var ourFrame:CGRect { get set }
    
    var pixelX:CGFloat { get set }
       
    var pixelY:CGFloat { get set }
    
    var pixelWidth:CGFloat { get set }
    
    var pixelHeight:CGFloat { get set }
    
    var pixelFrame:CGRect { get set }

    var pixelBounds:CGRect { get set }
}

public extension LLUIPixelControllable
{
    var pixelX:CGFloat {
        get { return ourFrame.origin.x * LLSystem.retinaScale.cgf }
        set { ourFrame.origin.x = newValue / LLSystem.retinaScale.cgf }
    }
    
    var pixelY:CGFloat {
        get { return ourFrame.origin.y * LLSystem.retinaScale.cgf }
        set { ourFrame.origin.y = newValue / LLSystem.retinaScale.cgf }
    }
    
    var pixelWidth:CGFloat {
        get { return ourFrame.size.width * LLSystem.retinaScale.cgf }
        set { ourFrame.size.width = newValue / LLSystem.retinaScale.cgf }
    }
    
    var pixelHeight:CGFloat {
        get { return ourFrame.size.height * LLSystem.retinaScale.cgf }
        set { ourFrame.size.height = newValue / LLSystem.retinaScale.cgf }
    }
    
    var pixelFrame:CGRect {
        get { return CGRect(x: pixelX, y: pixelY, width: pixelWidth, height: pixelHeight) }
        set {
            ourFrame = CGRect( x: newValue.origin.x / LLSystem.retinaScale.cgf,
                               y: newValue.origin.y / LLSystem.retinaScale.cgf,
                               width: newValue.size.width / LLSystem.retinaScale.cgf,
                               height: newValue.size.height / LLSystem.retinaScale.cgf )
        }
    }
    
    var pixelBounds:CGRect {
        get { return CGRect(x: ourBounds.origin.x * LLSystem.retinaScale.cgf,
                            y: ourBounds.origin.y * LLSystem.retinaScale.cgf,
                            width: ourBounds.size.width * LLSystem.retinaScale.cgf,
                            height: ourBounds.size.height * LLSystem.retinaScale.cgf )
        }
        set {
            ourBounds = CGRect( x: newValue.origin.x / LLSystem.retinaScale.cgf,
                                y: newValue.origin.y / LLSystem.retinaScale.cgf,
                                width: newValue.size.width / LLSystem.retinaScale.cgf,
                                height: newValue.size.height / LLSystem.retinaScale.cgf )
        }
    }
}

