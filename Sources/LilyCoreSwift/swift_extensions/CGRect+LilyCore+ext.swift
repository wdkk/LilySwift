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

/// CGRect構造体拡張
public extension CGRect
{
    /// x値の取得/設定
    var x:CGFloat {
        get { return self.origin.x }
        set { self.origin.x = newValue }
    }
    
    /// y値の取得/設定
    var y:CGFloat {
        get { return self.origin.y }
        set { self.origin.y = newValue }
    }
    
    /// LLRectを用いた実体化
    /// - Parameter llrc: 矩形情報
    init( _ llrc:LLRect ) {
        self.init( x: llrc.x.cgf, y: llrc.y.cgf, width: llrc.width.cgf, height: llrc.height.cgf )
    }
    
    /// CGFloatを用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    ///   - w: 横幅
    ///   - h: 高さ
    init( _ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat ) {
        self.init( x:x, y:y, width:w, height:h )
    }
    
    /// Doubleを用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    ///   - w: 横幅
    ///   - h: 高さ
    init( _ x:Double, _ y:Double, _ w:Double, _ h:Double ) {
        self.init( x:x.cgf, y:y.cgf, width:w.cgf, height:h.cgf )
    }
    
    /// Floatを用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    ///   - w: 横幅
    ///   - h: 高さ
    init( _ x:Float, _ y:Float, _ w:Float, _ h:Float ) {
        self.init( x:x.cgf, y:y.cgf, width:w.cgf, height:h.cgf )
    }
    
    /// Intを用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    ///   - w: 横幅
    ///   - h: 高さ
    init( _ x:Int, _ y:Int, _ w:Int, _ h:Int ) {
        self.init( x:x.cgf, y:y.cgf, width:w.cgf, height:h.cgf )
    }
    
    /// LLRectへ変換
    var llRect:LLRect { return LLRect( self ) }
}
