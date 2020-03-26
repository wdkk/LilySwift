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

/// CGSize構造体拡張
public extension CGSize
{
    /// CGFloatを用いた実体化
    /// - Parameters:
    ///   - w: 横幅
    ///   - h: 高さ
    init( _ w:CGFloat, _ h:CGFloat ) {
        self.init( width:w, height:h )
    }
    
    /// Doubleを用いた実体化
    /// - Parameters:
    ///   - w: 横幅
    ///   - h: 高さ
    init( _ w:Double, _ h:Double ) {
        self.init( width:w.cgf, height:h.cgf )
    }
    
    /// Floatを用いた実体化
    /// - Parameters:
    ///   - w: 横幅
    ///   - h: 高さ
    init( _ w:Float, _ h:Float ) {
        self.init( width:w.cgf, height:h.cgf )
    }
    
    /// Intを用いた実体化
    /// - Parameters:
    ///   - w: 横幅
    ///   - h: 高さ
    init( _ w:Int, _ h:Int ) {
        self.init( width:w, height:h )
    }
    
    /// LLSizeを用いた実体化
    /// - Parameter llsize: 大きさ
    init( _ llsize:LLSize ) {
        self.init( width:llsize.width.cgf, height:llsize.height.cgf )
    }
    
    /// LLSizeFloatを用いた実体化
    /// - Parameter llsize: 大きさ
    init( _ llsizef:LLSizeFloat ) {
        self.init( width:llsizef.width.cgf, height:llsizef.height.cgf )
    }

    /// LLSizeへの変換
    var llSize:LLSize { return LLSize( self ) }
    
    /// LLSizeへの変換
    var llSizeFloat:LLSizeFloat { return LLSizeFloat( self ) }
}
