//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import CoreGraphics

@MainActor
public protocol LLUIRectControllable
: AnyObject
{
    var center:CGPoint { get set }

    var ownFrame:CGRect { get set }

    var rect:LLRect { get set }
    
    var x:LLDouble { get set }
    
    var y:LLDouble { get set }
    
    var width:LLDouble { get set }

    var height:LLDouble { get set }
    
    var scaledX:CGFloat { get }
    
    var scaledY:CGFloat { get }
    
    var scaledWidth:CGFloat { get }
    
    var scaledHeight:CGFloat { get }
    
    var scaledFrame:CGRect { get }
    
    var scaledBounds:CGRect { get }
}

public extension LLUIRectControllable
{
    var rect:LLRect {
        get {
            let x = ( center.x - ownFrame.size.width  / 2.0 )
            let y = ( center.y - ownFrame.size.height / 2.0 )
            let w = ( ownFrame.size.width )
            let h = ( ownFrame.size.height )
            return LLRect( x, y, w, h )
        }
        set {
            let w = newValue.width
            let h = newValue.height
            let x = newValue.x + w / 2.0
            let y = newValue.y + h / 2.0
            
            ownFrame = CGRect( 0, 0, w.cgf, h.cgf )
            center = CGPoint( x.cgf, y.cgf )
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
    
    var scaledX:CGFloat {
        get { return x * LLSystem.retinaScale.cgf }
    }
    
    var scaledY:CGFloat {
        get { return y * LLSystem.retinaScale.cgf }
    }
    
    var scaledWidth:CGFloat {
        get { return width * LLSystem.retinaScale.cgf }
    }
    
    var scaledHeight:CGFloat {
        get { return height * LLSystem.retinaScale.cgf }
    }
    
    var scaledFrame:CGRect {
        get { return CGRect(x: scaledX, y: scaledY, width: scaledWidth, height: scaledHeight) }
    }
    
    var scaledBounds:CGRect {
        get { return CGRect(x: 0,y: 0, width: scaledWidth, height: scaledHeight ) }
    }
}
