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

public func LCImageProcAffineTransformBiLinear( 
    _ img_src_: LCImageSmPtr, 
    _ img_dst_: LCImageSmPtr, 
    _ transform: LL2DAffine,
    _ resizing: Bool
) 
{
    switch LCImageGetType(img_src_) {
    case .grey8:
        let module = __LCImageProcAffineTransformBiLinear<LLUInt8, LLUInt8>(LCImageGrey8Matrix)
        module.convert(img_src_, img_dst_, transform, resizing)
    case .grey16:
        let module = __LCImageProcAffineTransformBiLinear<LLUInt16, LLUInt16>(LCImageGrey16Matrix)
        module.convert(img_src_, img_dst_, transform, resizing)
    case .greyf:
        let module = __LCImageProcAffineTransformBiLinear<LLFloat, LLFloat>(LCImageGreyfMatrix)
        module.convert(img_src_, img_dst_, transform, resizing)
    case .rgba8:
        let module = __LCImageProcAffineTransformBiLinearColor<LLUInt8, LLColor8>(LCImageRGBA8Matrix)
        module.convert(img_src_, img_dst_, transform, resizing)
    case .rgba16:
        let module = __LCImageProcAffineTransformBiLinearColor<LLUInt16, LLColor16>(LCImageRGBA16Matrix)
        module.convert(img_src_, img_dst_, transform, resizing)
    case .rgbaf:
        let module = __LCImageProcAffineTransformBiLinearColor<LLFloat, LLColor>(LCImageRGBAfMatrix)
        module.convert(img_src_, img_dst_, transform, resizing)
    case .hsvf:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcAffineTransformBiLinear(img_conv, img_dst_, transform, resizing)
        LCImageConvertType(img_dst_, .hsvf)
        break
    case .hsvi:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcAffineTransformBiLinear(img_conv, img_dst_, transform, resizing)
        LCImageConvertType(img_dst_, .hsvi)
        break
    default:
        LLLogForce("unsupported this image type.")
    }
}

public func LCImageProcAffineTransformBiLinear( 
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
    LCImageProcAffineTransformBiLinear( img_src_, img_dst_, tf, resizing )
}

class __LCImageProcAffineTransformBiLinear<TType, TColor> 
where TColor: LLFloatConvertable 
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
        
        // 出力画像の座標 (x, y) を元に、入力画像上の対応する座標を計算
        let srcX = inverseTransform.a * Double(x) + inverseTransform.b * Double(y) + inverseTransform.c
        let srcY = inverseTransform.d * Double(x) + inverseTransform.e * Double(y) + inverseTransform.f

        // 範囲外チェック
        if srcX < 0.0 || srcX >= Double(srcWidth - 1) || srcY < 0.0 || srcY >= Double(srcHeight - 1) {
            pdst[y][x] = .init(0.0) // 黒
            return
        }

        // 整数部分と小数部分を分離
        let x0 = Int(floor(srcX))
        let y0 = Int(floor(srcY))
        let x1 = x0 + 1
        let y1 = y0 + 1
        let dx = srcX - Double(x0)
        let dy = srcY - Double(y0)

        // 4隅のピクセル値を取得
        let p00 = psrc[y0][x0].d
        let p01 = psrc[y0][x1].d
        let p10 = psrc[y1][x0].d
        let p11 = psrc[y1][x1].d

        // BiLinear補間
        let d00 = (1 - dx) * (1 - dy)
        let d01 = dx * (1 - dy)
        let d10 = (1 - dx) * dy
        let d11 = dx * dy
        
        let v = d00 * p00 + d01 * p01 + d10 * p10 + d11 * p11
        
        pdst[y][x] = .init( v )
    }
}

class __LCImageProcAffineTransformBiLinearColor<TType, TColor> 
where TColor: LLColorType, TType: LLFloatConvertable 
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
        
        // 出力画像の座標 (x, y) を元に、入力画像上の対応する座標を計算
        let srcX = inverseTransform.a * Double(x) + inverseTransform.b * Double(y) + inverseTransform.c
        let srcY = inverseTransform.d * Double(x) + inverseTransform.e * Double(y) + inverseTransform.f

        // 範囲外チェック
        if srcX < 0.0 || srcX >= Double(srcWidth - 1) || srcY < 0.0 || srcY >= Double(srcHeight - 1) {
            // 透明
            pdst[y][x] = .init(
                R: TColor.Unit(0.0),
                G: TColor.Unit(0.0),
                B: TColor.Unit(0.0),
                A: TColor.Unit(0.0)
            ) 
            return
        }

        // 整数部分と小数部分を分離
        let x0 = Int(floor(srcX))
        let y0 = Int(floor(srcY))
        let x1 = x0 + 1
        let y1 = y0 + 1
        let dx = srcX - Double(x0)
        let dy = srcY - Double(y0)

        // 4隅のピクセル値を取得
        let p00 = psrc[y0][x0]
        let p01 = psrc[y0][x1]
        let p10 = psrc[y1][x0]
        let p11 = psrc[y1][x1]
        
        let d00 = (1 - dx) * (1 - dy)
        let d01 = dx * (1 - dy)
        let d10 = (1 - dx) * dy
        let d11 = dx * dy

        // BiLinear補間 (R, G, B, A 各成分ごとに計算)
        let interpolatedR = d00 * p00.R.d +
                            d01 * p01.R.d +
                            d10 * p10.R.d +
                            d11 * p11.R.d

        let interpolatedG = d00 * p00.G.d +
                            d01 * p01.G.d +
                            d10 * p10.G.d +
                            d11 * p11.G.d

        let interpolatedB = d00 * p00.B.d +
                            d01 * p01.B.d +
                            d10 * p10.B.d +
                            d11 * p11.B.d

        let interpolatedA = d00 * p00.A.d +
                            d01 * p01.A.d +
                            d10 * p10.A.d +
                            d11 * p11.A.d

        // 補間結果を出力ピクセルに設定
        pdst[y][x] = .init(
            R: TColor.Unit(interpolatedR),
            G: TColor.Unit(interpolatedG),
            B: TColor.Unit(interpolatedB),
            A: TColor.Unit(interpolatedA)
        )
    }
}
