//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

#if os(macOS)
import AppKit
#else
import UIKit
#endif

open class LLImageProc
{
    public static func scaleNearest( imgSrc:LLImage, width:Int, height:Int ) async 
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcScaleNearest( imgSrc.lcImage(), img_dst.lcImage(), width, height )
        return img_dst
    }
    
    public static func scaleBiLinear( imgSrc:LLImage, width:Int, height:Int )
    async 
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcScaleBiLinear( imgSrc.lcImage(), img_dst.lcImage(), width, height )
        return img_dst
    }
    
    public static func scaleBiCubic( imgSrc:LLImage, width:Int, height:Int ) 
    async
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcScaleBiCubic( imgSrc.lcImage(), img_dst.lcImage(), width, height )
        return img_dst
    }
    
    public static func scaleAreaAverage( imgSrc:LLImage, width:Int, height:Int ) 
    async 
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcScaleAreaAverage( imgSrc.lcImage(), img_dst.lcImage(), width, height )
        return img_dst
    }
    
    public static func scaleSmooth( imgSrc:LLImage, width:Int, height:Int ) 
    async
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcScaleSmooth( imgSrc.lcImage(), img_dst.lcImage(), width, height )
        return img_dst
    }
    
    public static func rotateNearest( imgSrc:LLImage, degree:LLFloat, resizing:Bool )
    async
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcRotateNearest( imgSrc.lcImage(), img_dst.lcImage(), degree, resizing )
        return img_dst
    }
    
    public static func rotateBiLinear( imgSrc:LLImage, degree:LLFloat, resizing:Bool )
    async
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcRotateBiLinear( imgSrc.lcImage(), img_dst.lcImage(), degree, resizing )
        return img_dst
    }
    
    public static func rotateBiCubic( imgSrc:LLImage, degree:LLFloat, resizing:Bool )
    async
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcRotateBiCubic( imgSrc.lcImage(), img_dst.lcImage(), degree, resizing )
        return img_dst
    }

    public static func affineTransformNearest( imgSrc:LLImage, transform:LL2DAffine, resizing:Bool = false ) 
    async
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcAffineTransformNearest( imgSrc.lcImage(), img_dst.lcImage(), transform, resizing )
        return img_dst
    }
    
    public static func affineTransformNearest( imgSrc:LLImage, width:Int, height:Int, degree:Float, resizing:Bool = false ) 
    async
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcAffineTransformNearest( imgSrc.lcImage(), img_dst.lcImage(), width, height, degree, resizing )
        return img_dst
    }
    
    public static func affineTransformBiLinear( imgSrc:LLImage, transform:LL2DAffine, resizing:Bool = false ) 
    async
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcAffineTransformBiLinear( imgSrc.lcImage(), img_dst.lcImage(), transform, resizing )
        return img_dst
    }
    
    public static func affineTransformBiLinear( imgSrc:LLImage, width:Int, height:Int, degree:Float, resizing:Bool = false ) 
    async
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcAffineTransformBiLinear( imgSrc.lcImage(), img_dst.lcImage(), width, height, degree, resizing )
        return img_dst
    }
    
    public static func affineTransformBiCubic( imgSrc:LLImage, transform:LL2DAffine, resizing:Bool = false ) 
    async
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcAffineTransformBiCubic( imgSrc.lcImage(), img_dst.lcImage(), transform, resizing )
        return img_dst
    }
    
    public static func affineTransformBiCubic( imgSrc:LLImage, width:Int, height:Int, degree:Float, resizing:Bool = false ) 
    async
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcAffineTransformBiCubic( imgSrc.lcImage(), img_dst.lcImage(), width, height, degree, resizing )
        return img_dst
    }
    
    public static func bilateral( imgSrc:LLImage, kernel:Int, dist:Double, lumi:Double )
    async
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcBilateralFilter( imgSrc.lcImage(), img_dst.lcImage(), kernel, dist, lumi )
        return img_dst
    }
    
    public static func whiteBalanceAutomatically( imgSrc:LLImage )
    async
    -> LLImage
    {
        let img_dst = await imgSrc.clone()
        await LCImageProcWhiteBalanceAutomatically( imgSrc.lcImage(), img_dst.lcImage() )
        return img_dst
    }
}
