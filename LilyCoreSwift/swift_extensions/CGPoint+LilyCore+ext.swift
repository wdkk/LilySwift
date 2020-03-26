//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import CoreGraphics

/// CGPoint構造体拡張
public extension CGPoint
{   
    /// CGFloatを用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    init( _ x:CGFloat, _ y:CGFloat ) {
        self.init( x:x, y:y )
    }

    /// Doubleを用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    init( _ x:Double, _ y:Double ) {
        self.init( x:x.cgf, y:y.cgf )
    }
    
    /// Floatを用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    init( _ x:Float, _ y:Float ) {
        self.init( x:x.cgf, y:y.cgf )
    }
    
    /// Intを用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    init( _ x:Int, _ y:Int ) {
        self.init( x:x.cgf, y:y.cgf )
    }
    
    /// LLPointを用いた実体化
    /// - Parameter llpt: 座標値
    init( _ llpt:LLPoint ) {
        self.init( x:llpt.x.cgf, y:llpt.y.cgf )
    }
    
    /// LLPointIntを用いた実体化
    /// - Parameter llpti: 整数座標値
    init( _ llpti:LLPointInt ) {
        self.init( x:llpti.x.cgf, y:llpti.y.cgf )
    }
    
    /// LLPointFloatを用いた実体化
    /// - Parameter llpt: 座標値
    init( _ llptf:LLPointFloat ) {
        self.init( x:llptf.x.cgf, y:llptf.y.cgf )
    }
    
    /// LLPointへの変換
    var llPoint:LLPoint { 
        return LLPoint( self )
    }
    
    /// LLPointIntへの変換
    var llPointInt:LLPointInt { 
        return LLPointInt( self )
    }
    
    /// LLPointFloatへの変換
    var llPointFloat:LLPointFloat { 
        return LLPointFloat( self )
    }
    
    /// p点との2乗距離を返す
    /// - Parameter p: 対象座標
    /// - Returns: 自身の座標とp点の2乗距離
    func dist2( _ p:CGPoint ) -> CGFloat { 
        return (self.x - p.x) * (self.x - p.x) + (self.y - p.y) * (self.y - p.y)
    }
    
    /// p点との距離を返す
    /// - Parameter p: 対象座標
    /// - Returns: 自身の座標とp点の距離
    func dist( _ p:CGPoint ) -> CGFloat { 
        return sqrt( dist2( p ) ) 
    }
}
