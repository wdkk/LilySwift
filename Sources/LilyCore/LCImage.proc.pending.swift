//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public func LCImageProcAffineTransformNearest( 
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr, 
    _ width:Int, 
    _ height:Int, 
    _ degree:Float,
    _ isResize:Bool
) 
{
    // TODO: 未実装
}

public func LCImageProcAffineTransformBiLinear( 
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr,
    _ width:Int,
    _ height:Int,
    _ degree:Float,
    _ isResize:Bool
) 
{
    // TODO: 未実装
}

public func LCImageProcBilateralFilter(
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr,
    _ kernel:Int,
    _ dist:Double,
    _ lumi:Double
) 
{
    // TODO: 未実装
}

