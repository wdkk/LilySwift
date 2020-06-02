//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public protocol LBActorAdapter
{
    var p1:LLPointFloat { get set }
    var p2:LLPointFloat { get set }
    var p3:LLPointFloat { get set }
    var p4:LLPointFloat { get set }
    
    var uv1:LLPointFloat { get set }
    var uv2:LLPointFloat { get set }
    var uv3:LLPointFloat { get set }
    var uv4:LLPointFloat { get set }

    var position:LLPointFloat { get set }
    var cx:LLFloat { get set }
    var cy:LLFloat { get set }
    
    var scale:LLSizeFloat { get set }
    var width:Float { get set }
    var height:Float { get set }
    
    var angle:LLAngle { get set }
    var zIndex:LLFloat { get set }
    var enabled:Bool { get set }
    var life:Float { get set }
    var color:LLColor { get set }
    var alpha:Float { get set }
    
    var matrix:LLMatrix4x4 { get set }
    
    var deltaPosition:LLPointFloat { get set }
    var deltaScale:LLSizeFloat { get set }
    var deltaColor:LLColor { get set }
    var deltaAlpha:Float { get set }
    var deltaAngle:LLAngle { get set }
    var deltaLife:Float { get set }
}
