//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import CoreGraphics

/// LLRect構造体拡張
public extension LLRect
{
    /// x=0, y=0, width=0, height=0の矩形を返す
    static var zero:LLRect = { return LLRect( x:0, y:0, width:0, height:0 ) }()
    
    /// CGRectを用いた実体化
    /// - Parameter rec: 矩形情報
    init( _ rec:CGRect ) {
        self.init( x: rec.x.d, y: rec.y.d, width: rec.width.d, height: rec.height.d )
    }
    
    /// 整数型を用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    ///   - w: 横幅
    ///   - h: 高さ
    init<Ti:BinaryInteger>( _ x:Ti, _ y:Ti, _ w:Ti, _ h:Ti ) {
        self.init( x:Double(x), y:Double(y), width:Double(w), height:Double(h) )
    }
    
    /// 浮動小数点型を用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    ///   - w: 横幅
    ///   - h: 高さ
    init<Tf:BinaryFloatingPoint>( _ x:Tf, _ y:Tf, _ w:Tf, _ h:Tf ) {
        self.init( x:Double(x), y:Double(y), width:Double(w), height:Double(h) )
    }
    
    /// CGRectへ変換
    var cgRect:CGRect {
        return CGRect( self )
    }
    
    /// 矩形情報の小数値を四捨五入した整数値の矩形情報を取得
    var normal:LLRect {
        return LLRect( x: round( self.x ),
                       y: round( self.y ), 
                       width: round( self.width ),
                       height: round( self.height )
        )
    }
    
    /// width,heightの値を持つサイズ値を取得
    var size: LLSize { return LLSize( width: self.width, height:self.height ) }
    
    /// CGSizeを取得
    var cgSize: CGSize { return CGSize( self.width.cgf, self.height.cgf ) }
    
    /// 矩形を膨張/収縮する
    /// - Parameter val: 補正値
    func inset( _ val:Double ) -> LLRect {
        return LLRectInset( self, val )
    }
    
    /// 矩形を膨張/収縮する
    /// - Parameter region: 補正値
    func inset( _ region:LLRegion ) -> LLRect {
        return LLRectInsetRegion( self, region )
    }
}
