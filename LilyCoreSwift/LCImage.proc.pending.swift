//
//  LCImage.proc.pending.swift
//  LilySwift
//
//  Created by Kengo Watanabe on 2021/07/27.
//  Copyright © 2021 Watanabe-DENKI.Inc. All rights reserved.
//

import Foundation

static public func LCImageProcScaleNearest(
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr,
    width:Int,
    height:Int 
) 
{
    // TODO: 未実装
}

static public func LCImageProcScaleBiLinear(
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr,
    width:Int, 
    height:Int ) 
{
    // TODO: 未実装
}

static public func LCImageProcScaleSmooth(
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr,
    width:Int, 
    height:Int 
) 
{
    // TODO: 未実装
}

static public func LCImageProcRotateNearest(     
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr, 
    degree:LLFloat, 
    resizing:Bool 
) 
{
    // TODO: 未実装
}

static public func LCImageProcRotateBiLinear( 
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr, 
    degree:LLFloat, 
    resizing:Bool
)
{
    // TODO: 未実装
}

static public func LCImageProcAffineTransformNearest( 
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr, 
    width:Int, 
    height:Int, 
    degree:Float,
    isResize:Bool ) 
{
    // TODO: 未実装
}

static public func LCImageProcAffineTransformBiLinear( 
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr,
    width:Int,
    height:Int,
    degree:Float,
    isResize:Bool ) 
{
    // TODO: 未実装
}

