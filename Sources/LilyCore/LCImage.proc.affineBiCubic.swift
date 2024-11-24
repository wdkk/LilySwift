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

public func LCImageProcAffineTransformBiCubic( 
    _ img_src_: LCImageSmPtr, 
    _ img_dst_: LCImageSmPtr, 
    _ transform: LL2DAffine,
    _ resizing: Bool
) 
{
    switch LCImageGetType(img_src_) {
    case .grey8:
        let module = __LCImageProcAffineTransformBiCubic<LLUInt8, LLUInt8>(LCImageGrey8Matrix)
        module.convert(img_src_, img_dst_, transform, resizing)
    case .grey16:
        let module = __LCImageProcAffineTransformBiCubic<LLUInt16, LLUInt16>(LCImageGrey16Matrix)
        module.convert(img_src_, img_dst_, transform, resizing)
    case .greyf:
        let module = __LCImageProcAffineTransformBiCubic<LLFloat, LLFloat>(LCImageGreyfMatrix)
        module.convert(img_src_, img_dst_, transform, resizing)
    case .rgba8:
        let module = __LCImageProcAffineTransformBiCubicColor<LLUInt8, LLColor8>(LCImageRGBA8Matrix)
        module.convert(img_src_, img_dst_, transform, resizing)
    case .rgba16:
        let module = __LCImageProcAffineTransformBiCubicColor<LLUInt16, LLColor16>(LCImageRGBA16Matrix)
        module.convert(img_src_, img_dst_, transform, resizing)
    case .rgbaf:
        let module = __LCImageProcAffineTransformBiCubicColor<LLFloat, LLColor>(LCImageRGBAfMatrix)
        module.convert(img_src_, img_dst_, transform, resizing)
    case .hsvf:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcAffineTransformBiCubic(img_conv, img_dst_, transform, resizing)
        LCImageConvertType(img_dst_, .hsvf)
        break
    case .hsvi:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcAffineTransformBiCubic(img_conv, img_dst_, transform, resizing)
        LCImageConvertType(img_dst_, .hsvi)
        break
    default:
        LLLogForce("unsupported this image type.")
    }
}

public func LCImageProcAffineTransformBiCubic( 
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr, 
    _ width:Int, 
    _ height:Int, 
    _ degree:Float,
    _ resizing:Bool
) 
{    
    // 入力画像の幅と高さを取得
    let src_wid = LCImageWidth(img_src_)
    let src_hgt = LCImageHeight(img_src_)
    
    let scale_x = Double(width) / Double(src_wid)
    let scale_y = Double(height) / Double(src_hgt)
    
    // 元画像の中心座標
    let center_x = src_wid.d / 2.0
    let center_y = src_hgt.d / 2.0
    
    // 外接矩形を計算してサイズを取得
    var dst_wid = width
    var dst_hgt = height
    if resizing {
        let scaling_tf = LL2DAffineScale(scale_x, scale_y)
        let rotation_tf = LL2DAffineRotate( degree.d )
        // 合成アフィン変換(拡大 > 回転)
        let tf = LL2DAffineMultiply(scaling_tf, rotation_tf )
    
        let boundingBox = __calculateBoundingBoxForAffine( src_wid, src_hgt, tf )
        dst_wid = boundingBox.0
        dst_hgt = boundingBox.1
    }
    
    // 新しい中心座標
    let new_center_x = dst_wid.d / 2.0
    let new_center_y = dst_hgt.d / 2.0

    let new_scale_tf = LL2DAffineMultiply(
        LL2DAffineScale( scale_x, scale_y ), 
        LL2DAffineTranslate( 
            new_center_x - (scale_x * center_x),
            new_center_y - (scale_y * center_y)
        )
    )
    
    let ro_tf = LL2DAffineRotate( degree.d )
    let new_rotate_tf = LL2DAffineMultiply(
        ro_tf, 
        LL2DAffineTranslate(
            new_center_x - (new_center_x * ro_tf.a) -  (new_center_y * ro_tf.b),
            new_center_y - (new_center_x * ro_tf.d) -  (new_center_y * ro_tf.e)
        )
    )
    
    // 合成アフィン変換(移動調整込み拡大 > 移動調整込み回転)
    let tf = LL2DAffineMultiply( new_scale_tf, new_rotate_tf )

    // アフィン変換を適用して画像を変形
    LCImageProcAffineTransformBiCubic( img_src_, img_dst_, tf, resizing )
}

class __LCImageProcAffineTransformBiCubic<TType, TColor> 
where TColor: LLFloatConvertable & Comparable 
{
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    
    var matrix_getter: (LCImageSmPtr) -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) -> TMatrix?) {
        matrix_getter = mgetter
    }
    
    func convert(
        _ img_src_: LCImageSmPtr,
        _ img_dst_: LCImageSmPtr,
        _ transform: LL2DAffine,
        _ resizing: Bool
    ) {
        let srcWidth = LCImageWidth(img_src_)
        let srcHeight = LCImageHeight(img_src_)
        
        var dstWidth = srcWidth
        var dstHeight = srcHeight
        
        // アフィン変換後の外接矩形を計算してリサイズ
        if resizing {
            let boundingBox = __calculateBoundingBoxForAffine(srcWidth, srcHeight, transform)
            dstWidth = boundingBox.0
            dstHeight = boundingBox.1
        }
        
        // 出力画像のリサイズ
        let type = LCImageGetType(img_src_)
        LCImageResizeWithType(img_dst_, dstWidth, dstHeight, type)

        let mat_src = matrix_getter(img_src_)!
        let mat_dst = matrix_getter(img_dst_)!

        mat_src.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { psrc in
            mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { pdst in
                for y in 0..<dstHeight {
                    for x in 0..<dstWidth {
                        processPixel(
                            psrc: psrc,
                            pdst: pdst,
                            x: x,
                            y: y,
                            srcWidth: srcWidth,
                            srcHeight: srcHeight,
                            transform: transform
                        )
                    }
                }
            }
        }
    }
    
    func processPixel(
        psrc: TMatrix,
        pdst: TMatrix,
        x: Int,
        y: Int,
        srcWidth: Int,
        srcHeight: Int,
        transform: LL2DAffine
    ) {
        // 逆アフィン変換を計算
        let inverseTransform = LL2DAffineInverse(transform)
        
        // 出力画像の座標 (x, y) を元に、入力画像上の対応する座標を計算
        let srcX = inverseTransform.a * Double(x) + inverseTransform.b * Double(y) + inverseTransform.c
        let srcY = inverseTransform.d * Double(x) + inverseTransform.e * Double(y) + inverseTransform.f

        // 範囲外チェック
        if srcX < 1.0 || srcX >= Double(srcWidth - 2) || srcY < 1.0 || srcY >= Double(srcHeight - 2) {
            pdst[y][x] = .init(0.0) // 黒
            return
        }

        // 整数部分と小数部分を分離
        let x0 = Int(floor(srcX))
        let y0 = Int(floor(srcY))
        let dx = srcX - Double(x0)
        let dy = srcY - Double(y0)

        // BiCubic補間の計算
        var result: Double = 0.0
        for j in -1...2 {
            for i in -1...2 {
                let weightX = cubicWeight(dx - Double(i))
                let weightY = cubicWeight(dy - Double(j))
                let pixelValue = psrc[y0 + j][x0 + i].d
                result += pixelValue * weightX * weightY
            }
        }

        // 出力ピクセルに設定
        pdst[y][x] = LLWithin(min: TColor.colorRangeMinValue, .init( result ), max:TColor.colorRangeMaxValue ) 
    }
    
    func cubicWeight(_ t: Double) -> Double {
        let absT = abs(t)
        if absT <= 1 {
            return 1.5 * absT * absT * absT - 2.5 * absT * absT + 1
        } 
        else if absT <= 2 {
            return -0.5 * absT * absT * absT + 2.5 * absT * absT - 4 * absT + 2
        } 
        else {
            return 0.0
        }
    }
}

class __LCImageProcAffineTransformBiCubicColor<TType, TColor> 
where TColor: LLColorType, TType: LLFloatConvertable 
{
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    
    var matrix_getter: (LCImageSmPtr) -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) -> TMatrix?) { matrix_getter = mgetter }
    
    func convert(
        _ img_src_: LCImageSmPtr,
        _ img_dst_: LCImageSmPtr,
        _ transform: LL2DAffine,
        _ resizing: Bool
    )
    {
        let srcWidth = LCImageWidth(img_src_)
        let srcHeight = LCImageHeight(img_src_)
        
        var dstWidth = srcWidth
        var dstHeight = srcHeight
        
        // アフィン変換後の外接矩形を計算してリサイズ
        if resizing {
            let boundingBox = __calculateBoundingBoxForAffine(srcWidth, srcHeight, transform)
            dstWidth = boundingBox.0
            dstHeight = boundingBox.1
        }
        
        // 出力画像のリサイズ
        let type = LCImageGetType(img_src_)
        LCImageResizeWithType(img_dst_, dstWidth, dstHeight, type)
        
        let mat_src = matrix_getter(img_src_)!
        let mat_dst = matrix_getter(img_dst_)!
        
        mat_src.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { psrc in
            mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { pdst in
                for y in 0..<dstHeight {
                    for x in 0..<dstWidth {
                        processPixel(
                            psrc: psrc,
                            pdst: pdst,
                            x: x,
                            y: y,
                            srcWidth: srcWidth,
                            srcHeight: srcHeight,
                            transform: transform
                        )
                    }
                }
            }
        }
    }
    
    func processPixel(
        psrc: TMatrix,
        pdst: TMatrix,
        x: Int,
        y: Int,
        srcWidth: Int,
        srcHeight: Int,
        transform: LL2DAffine
    ) 
    {
        // 逆アフィン変換を計算
        let inverseTransform = LL2DAffineInverse(transform)
        
        let srcX = inverseTransform.a * Double(x) + inverseTransform.b * Double(y) + inverseTransform.c
        let srcY = inverseTransform.d * Double(x) + inverseTransform.e * Double(y) + inverseTransform.f

        if srcX < 1.0 || srcX >= Double(srcWidth - 2) || srcY < 1.0 || srcY >= Double(srcHeight - 2) {
            pdst[y][x] = .init(
                R: TColor.Unit(0.0),
                G: TColor.Unit(0.0),
                B: TColor.Unit(0.0),
                A: TColor.Unit(0.0)
            )
            return
        }

        let x0 = Int(floor(srcX))
        let y0 = Int(floor(srcY))
        let dx = srcX - Double(x0)
        let dy = srcY - Double(y0)

        var interpolatedR: Double = 0.0
        var interpolatedG: Double = 0.0
        var interpolatedB: Double = 0.0
        var interpolatedA: Double = 0.0

        for j in -1...2 {
            for i in -1...2 {
                let weightX = cubicWeight(dx - Double(i))
                let weightY = cubicWeight(dy - Double(j))
                let weight = weightX * weightY

                let p = psrc[y0 + j][x0 + i]
                interpolatedR += p.R.d * weight
                interpolatedG += p.G.d * weight
                interpolatedB += p.B.d * weight
                interpolatedA += p.A.d * weight
            }
        }

        pdst[y][x] = .init(
            R: LLWithin( min:TColor.min, TColor.Unit( interpolatedR ), max:TColor.max ),
            G: LLWithin( min:TColor.min, TColor.Unit( interpolatedG ), max:TColor.max ),
            B: LLWithin( min:TColor.min, TColor.Unit( interpolatedB ), max:TColor.max ),
            A: LLWithin( min:TColor.min, TColor.Unit( interpolatedA ), max:TColor.max )
        )
    }
    
    func cubicWeight(_ t: Double) -> Double {
        let absT = abs(t)
        if absT <= 1 {
            return 1.5 * absT * absT * absT - 2.5 * absT * absT + 1
        } 
        else if absT <= 2 {
            return -0.5 * absT * absT * absT + 2.5 * absT * absT - 4 * absT + 2
        } 
        else {
            return 0.0
        }
    }
}
