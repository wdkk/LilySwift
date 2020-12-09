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
    
    public static var clearColor:LLColor {
        get { current.clearColor }
        set { current.clearColor = newValue }
    }

    public static var randomPoint:LLPoint { current.coordRegion.randomPoint }
    public static var minX:LLDouble { current.coordMinX }
    public static var minY:LLDouble { current.coordMinY }
    public static var maxX:LLDouble { current.coordMaxX }
    public static var maxY:LLDouble { current.coordMaxY }

    public static var size:LLSizeFloat { current.screenSize }
    public static var width:LLDouble { current.width }
    public static var height:LLDouble { current.height }

    public static var touches:[LBTouch] { return current.touches }
    public static var releases:[LBTouch] { return current.releases }

    public static var shapes:Set<LBActor> { current.shapes }

    public static var elapsedTime:Double { current.elapsedTime }
}
