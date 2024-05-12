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
    static public func scaleNearest( imgSrc:LLImage, width:Int, height:Int ) 
    -> LLImage
    {
        let img_dst = imgSrc.clone()
        LCImageProcScaleNearest( imgSrc.lcImage, img_dst.lcImage, width, height )
        return img_dst
    }
    
    static public func scaleBiLinear( imgSrc:LLImage, width:Int, height:Int ) 
    -> LLImage
    {
        let img_dst = imgSrc.clone()
        LCImageProcScaleBiLinear( imgSrc.lcImage, img_dst.lcImage, width, height )
        return img_dst
    }
    
    static public func scaleSmooth( imgSrc:LLImage, width:Int, height:Int ) 
    -> LLImage
    {
        let img_dst = imgSrc.clone()
        LCImageProcScaleSmooth( imgSrc.lcImage, img_dst.lcImage, width, height )
        return img_dst
    }
    
    static public func rotateNearest( imgSrc:LLImage, degree:LLFloat, resizing:Bool ) 
    -> LLImage
    {
        let img_dst = imgSrc.clone()
        LCImageProcRotateNearest( imgSrc.lcImage, img_dst.lcImage, degree, resizing )
        return img_dst
    }
    
    static public func rotateBiLinear( imgSrc:LLImage, degree:LLFloat, resizing:Bool )
    -> LLImage
    {
        let img_dst = imgSrc.clone()
        LCImageProcRotateBiLinear( imgSrc.lcImage, img_dst.lcImage, degree, resizing )
        return img_dst
    }
    
    static public func affineTransformNearest( imgSrc:LLImage, width:Int, height:Int, degree:Float, isResize:Bool = false ) 
    -> LLImage
    {
        let img_dst = imgSrc.clone()
        LCImageProcAffineTransformNearest( imgSrc.lcImage, img_dst.lcImage, width, height, degree, isResize )
        return img_dst
    }
    
    static public func affineTransformBiLinear( imgSrc:LLImage, width:Int, height:Int, degree:Float, isResize:Bool = false ) 
    -> LLImage
    {
        let img_dst = imgSrc.clone()
        LCImageProcAffineTransformBiLinear( imgSrc.lcImage, img_dst.lcImage, width, height, degree, isResize )
        return img_dst
    }
    
    static public func bilateral( imgSrc:LLImage, kernel:Int, dist:Double, lumi:Double )
    -> LLImage
    {
        let img_dst = imgSrc.clone()
        LCImageProcBilateralFilter( imgSrc.lcImage, img_dst.lcImage, kernel, dist, lumi )
        return img_dst
    }
    
    static public func whiteBalanceAutomatically( imgSrc:LLImage )
    -> LLImage
    {
        let img_dst = imgSrc.clone()
        LCImageProcWhiteBalanceAutomatically( imgSrc.lcImage, img_dst.lcImage )
        return img_dst
    }
}
