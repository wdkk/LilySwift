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

/// LLRegion構造体拡張
public extension LLRegion
{
    /// x=0, y=0, width=0, height=0の矩形を返す
    static var zero:LLRegion = { return LLRegionZero() }()
    
    /// 整数型を用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    ///   - w: 横幅
    ///   - h: 高さ
    init<Ti:BinaryInteger>( _ left:Ti, _ top:Ti, _ right:Ti, _ bottom:Ti ) {
        self.init( left:Double(left), top:Double(top), right:Double(right), bottom:Double(bottom) )
    }
    
    /// 浮動小数点型を用いた実体化
    /// - Parameters:
    ///   - x: x座標
    ///   - y: y座標
    ///   - w: 横幅
    ///   - h: 高さ
    init<Tf:BinaryFloatingPoint>( _ left:Tf, _ top:Tf, _ right:Tf, _ bottom:Tf ) {
        self.init( left:Double(left), top:Double(top), right:Double(right), bottom:Double(bottom) )
    }
        
    /// 矩形情報の小数値を四捨五入した整数値の矩形情報を取得
    var normal:LLRegion {
        return LLRegion( left: round( self.left ),
                         top: round( self.top ), 
                         right: round( self.right ),
                         bottom: round( self.bottom )
        )
    }

    /// 領域を膨張/収縮する
    /// - Parameter val: 補正値
    func expand( _ val:Double ) -> LLRegion {
        return LLRegionExpand( self, val )
    }
    
    /// 論理和領域を返す
    /// - Parameter val: 補正値
    func or( _ reg:LLRegion ) -> LLRegion {
        return LLRegionOr( self, reg )
    }
    
    /// 論理積領域を返す
    /// - Parameter val: 補正値
    func and( _ reg:LLRegion ) -> LLRegion {
        return LLRegionAnd( self, reg )
    }
}
