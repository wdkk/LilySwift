//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public class PGScreen
{
    public static var current:PGViewController!
    
    // MARK: - 読み書きプロパティ
    public static var clearColor:LLColor {
        get { current.clearColor }
        set { current.clearColor = newValue }
    }
    
    // MARK: - 読み込み専用プロパティ
    public static var randomPoint:LLPoint { current.coordRegion.randomPoint }
    public static var minX:LLDouble { current.coordMinX }
    public static var minY:LLDouble { current.coordMinY }
    public static var maxX:LLDouble { current.coordMaxX }
    public static var maxY:LLDouble { current.coordMaxY }

    public static var size:LLSizeFloat { current.screenSize }
    public static var width:LLDouble { current.width }
    public static var height:LLDouble { current.height }

    public static var touches:[LBTouch] { current.touches }
    public static var releases:[LBTouch] { current.releases }

    public static var shapes:Set<LBActor> { current.shapes }

    public static var elapsedTime:Double { current.elapsedTime }
    
    // MARK: - タッチ情報ヘルパ
    private static var latest_touch:LBTouch = 
        LBTouch( xy:.zero, uv: .zero, state:.touch )
    
    public static var latestTouch:LBTouch {
        if let touch = PGScreen.touches.first {
            latest_touch = touch
        }
        return latest_touch
    }
    
    // MARK: - ユーティリティ
    
    // 全ての形状を削除する
    public static func clearAllShapes() {
        PGMemoryPool.shared.panels.removeAll()
        PGMemoryPool.shared.triangles.removeAll()        
    }
}
