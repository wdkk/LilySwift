//
//  LCImage.proc.pending.swift
//  LilySwift
//
//  Created by Kengo Watanabe on 2021/07/27.
//  Copyright © 2021 Watanabe-DENKI, Inc.. All rights reserved.
//

import Foundation

public func LCImageProcRotateNearest(     
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr, 
    _ degree:LLFloat, 
    _ resizing:Bool 
) 
{
    // TODO: 未実装
}

public func LCImageProcRotateBiLinear( 
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr, 
    _ degree:LLFloat, 
    _ resizing:Bool
)
{
    // TODO: 未実装
}

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

