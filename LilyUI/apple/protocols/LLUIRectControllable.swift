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

public protocol LLUIRectControllable : AnyObject
{
    var ourCenter:CGPoint { get set }
    
    var ourBounds:CGRect { get set }
    
    var rect:LLRect { get set }
    
    var x:LLDouble { get set }
    
    var y:LLDouble { get set }
    
    var width:LLDouble { get set }

    var height:LLDouble { get set }
}

public extension LLUIRectControllable
{
    var rect:LLRect {
        get {
            let x = ( ourCenter.x - ourBounds.size.width  / 2.0 )
            let y = ( ourCenter.y - ourBounds.size.height / 2.0 )
            let w = ( ourBounds.size.width )
            let h = ( ourBounds.size.height )
            return LLRect( x, y, w, h )
        }
        set {
            let w = newValue.width
            let h = newValue.height
            let x = newValue.x + w / 2.0
            let y = newValue.y + h / 2.0
            
            ourBounds = CGRect( 0, 0, w.cgf, h.cgf )
            ourCenter = CGPoint( x.cgf, y.cgf )
        }
    }  
    
    var x:LLDouble {
        get { return rect.x }
        set { rect.x = newValue }
    }
    var y:LLDouble {
        get { return rect.y }
        set { rect.y = newValue }
    }
    var width:LLDouble {
        get { return rect.width }
        set { rect.width = newValue }
    }
    var height:LLDouble {
        get { return rect.height }
        set { rect.height = newValue }
    }
}
