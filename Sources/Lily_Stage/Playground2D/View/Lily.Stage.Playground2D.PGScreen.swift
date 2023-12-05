//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

extension Lily.Stage.Playground2D
{ 
    open class PGScreen
    {
        public static var current:PGViewController!
        
        // MARK: - 読み書きプロパティ
        public static var clearColor:LLColor {
            get { current.clearColor }
            set { current.clearColor = newValue }
        }
        
        // MARK: - 読み込み専用プロパティ
        public static var randomPoint:LLPoint { current.randomPoint }
        public static var minX:LLDouble { current.coordMinX }
        public static var minY:LLDouble { current.coordMinY }
        public static var maxX:LLDouble { current.coordMaxX }
        public static var maxY:LLDouble { current.coordMaxY }
        
        public static var screenSize:LLSizeFloat { current.screenSize }
        public static var width:LLDouble { current.width }
        public static var height:LLDouble { current.height }
        
        public static var touches:[PGTouch] { current.touches }
        public static var releases:[PGTouch] { current.releases }
        
        public static var shapes:Set<PGActor> { current.shapes }
        
        public static var elapsedTime:Double { current.elapsedTime }
        
        public static var latestTouch:PGTouch { current.latestTouch }
        
        // MARK: - ユーティリティ
        // 全ての形状を削除する
        public static func removeAllShapes() { current.removeAllShapes() }
    }
}
