//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import CoreGraphics

/// 整数座標構造体拡張
public extension LLPointInt
{
    /// 位置(0,0)の実体を返す
    static var zero:LLPointInt = { return LLPointInt( 0, 0 ) }()

    /// CGFloatを用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    init( _ x:CGFloat, _ y:CGFloat ) {
        if let xx = x.i, let yy = y.i {
            self.init( x:xx, y:yy )
        }
        else {
            LLLogWarning( "キャスト失敗" )
            self.init( x:0, y:0 )
        }
    }
    
    /// Floatを用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    init( _ x:Float, _ y:Float ) {
        if let xx = x.i, let yy = y.i {
            self.init( x:xx, y:yy )
        }
        else {
            LLLogWarning( "キャスト失敗" )
            self.init( x:0, y:0 )
        }
    }
    
    /// Doubleを用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    init( _ x:Double, _ y:Double ) {
        if let xx = x.i, let yy = y.i {
            self.init( x:xx, y:yy )
        }
        else {
            LLLogWarning( "キャスト失敗" )
            self.init( x:0, y:0 )
        }
    }
    
    /// Intを用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    init( _ x:Int, _ y:Int ) {
        self.init( x:x, y:y )
    }
    
    /// CGPointを用いた実体化
    /// - Parameter cgpt: 座標値
    init( _ cgpt:CGPoint ) {
        if let xx = cgpt.x.i, let yy = cgpt.y.i {
            self.init( x:xx, y:yy )
        }
        else {
            LLLogWarning( "キャスト失敗" )
            self.init( x:0, y:0 )
        }
    }
    
    /// CGPointへの変換
    var cgPoint:CGPoint { 
        return CGPoint( self ) 
    }
    
    /// LLPointへの変換
    var llPoint:LLPoint {
        return LLPoint( self.x, self.y )
    }
    
    /// LLPointFloatへの変換
    var llPointFloat:LLPointFloat {
        return LLPointFloat( self.x, self.y )
    }
    
    /// p点との2乗距離を返す
    /// - Parameter p: 対象座標
    /// - Returns: 自身の座標とp点の2乗距離
    func dist2( _ p:LLPointInt ) -> CGFloat {
        return ((self.x - p.x) * (self.x - p.x) + (self.y - p.y) * (self.y - p.y)).cgf
    }
    
    /// p点との距離を返す
    /// - Parameter p: 対象座標
    /// - Returns: 自身の座標とp点の距離
    func dist( _ p:LLPointInt ) -> CGFloat {
        return sqrt( dist2( p ) )
    }
    
    /// 0~指定した値のランダムサイズ値
    var randomize:LLPointInt { 
        return LLPointInt( LLRandomi( self.x ).i, LLRandomi( self.y ).i )  
    }
}
