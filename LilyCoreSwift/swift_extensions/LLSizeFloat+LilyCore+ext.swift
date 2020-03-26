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

/// サイズ構造体拡張
public extension LLSizeFloat
{
    /// サイズゼロのサイズ構造体を返す
    static var zero:LLSizeFloat = { return LLSizeFloat( 0, 0 ) }()
    
    /// CGFloatを用いた実体化
    /// - Parameters:
    ///   - w: 横幅
    ///   - h: 高さ
    init( _ w:CGFloat, _ h:CGFloat ) {
        self.init( width:w.f, height:h.f )
    }
    
    /// Doubleを用いた実体化
    /// - Parameters:
    ///   - w: 横幅
    ///   - h: 高さ
    init( _ w:Double, _ h:Double ) {
        self.init( width:w.f, height:h.f )
    }
    
    /// Floatを用いた実体化
    /// - Parameters:
    ///   - w: 横幅
    ///   - h: 高さ
    init( _ w:Float, _ h:Float ) {
        self.init( width:w, height:h )
    }
    
    /// Intを用いた実体化
    /// - Parameters:
    ///   - w: 横幅
    ///   - h: 高さ
    init( _ w:Int, _ h:Int ) {
        self.init( width:w.f, height:h.f )
    }
    
    /// CGSizeからの実体化
    /// - Parameters:
    ///   - cgSize: 大きさ
    init( _ cgSize:CGSize ) {
        self.init( width:cgSize.width.f, height:cgSize.height.f )
    }
    
    /// CGSizeへの変換
    var cgSize:CGSize { 
        return CGSize( self )
    }
}
