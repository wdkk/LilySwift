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
    _ img_src_: LCImageSmPtr, 
    _ img_dst_: LCImageSmPtr, 
    _ transform: LL2DAffine,
    _ resizing: Bool
) 
async
{
    switch await LCImageGetType(img_src_) {
    case .grey8:
        let module = __LCImageProcAffineTransformNearest<LLUInt8, LLUInt8>(LCImageGrey8Matrix)
        await module.convert(img_src_, img_dst_, transform, resizing)
    case .grey16:
        let module = __LCImageProcAffineTransformNearest<LLUInt16, LLUInt16>(LCImageGrey16Matrix)
        await module.convert(img_src_, img_dst_, transform, resizing)
    case .greyf:
        let module = __LCImageProcAffineTransformNearest<LLFloat, LLFloat>(LCImageGreyfMatrix)
        await module.convert(img_src_, img_dst_, transform, resizing)
    case .rgba8:
        let module = __LCImageProcAffineTransformNearestColor<LLUInt8, LLColor8>(LCImageRGBA8Matrix)
        await module.convert(img_src_, img_dst_, transform, resizing)
    case .rgba16:
        let module = __LCImageProcAffineTransformNearestColor<LLUInt16, LLColor16>(LCImageRGBA16Matrix)
        await module.convert(img_src_, img_dst_, transform, resizing)
    case .rgbaf:
        let module = __LCImageProcAffineTransformNearestColor<LLFloat, LLColor>(LCImageRGBAfMatrix)
        await module.convert(img_src_, img_dst_, transform, resizing)
    case .hsvf:
        let img_conv = await LCImageClone(img_src_)
        await LCImageConvertType(img_conv, .rgbaf)
        await LCImageProcAffineTransformNearest(img_conv, img_dst_, transform, resizing)
        await LCImageConvertType(img_dst_, .hsvf)
        break
    case .hsvi:
        let img_conv = await LCImageClone(img_src_)
        await LCImageConvertType(img_conv, .rgbaf)
        await LCImageProcAffineTransformNearest(img_conv, img_dst_, transform, resizing)
        await LCImageConvertType(img_dst_, .hsvi)
        break
    default:
        LLLogForce("unsupported this image type.")
    }
}

public func LCImageProcAffineTransformNearest( 
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr, 
    _ width:Int, 
    _ height:Int, 
    _ degree:Float,
    _ resizing:Bool
) 
async
{    
    // 入力画像の幅と高さを取得
    let src_wid = await LCImageWidth(img_src_)
    let src_hgt = await LCImageHeight(img_src_)
    
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
    await LCImageProcAffineTransformNearest( img_src_, img_dst_, tf, resizing )
}

func __calculateBoundingBoxForAffine(
    _ srcWidth: Int,
    _ srcHeight: Int,
    _ transform: LL2DAffine
) 
-> (Int, Int)
{
    // 画像4頂点
    let corners = [ (x: 0.0, y: 0.0), (x: srcWidth.d, y: 0.0), (x: srcWidth.d, y: srcHeight.d), (x: 0.0, y: srcHeight.d) ]
    // 4頂点をアフィン変換
    let transformedCorners = corners.map { corner in
        let tx = transform.a * corner.x + transform.b * corner.y + transform.c
        let ty = transform.d * corner.x + transform.e * corner.y + transform.f
        return (x: tx, y: ty)
    }
    
    // 外接矩形の幅と高さを計算
    let minX = transformedCorners.map { $0.x }.min()!
    let maxX = transformedCorners.map { $0.x }.max()!
    let minY = transformedCorners.map { $0.y }.min()!
    let maxY = transformedCorners.map { $0.y }.max()!
    
    return ( Int(ceil(maxX - minX)), Int(ceil(maxY - minY)) )
}

class __LCImageProcAffineTransformNearest<TType, TColor> 
where TColor: LLFloatConvertable 
{
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    
    var matrix_getter: (LCImageSmPtr) async -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) async -> TMatrix?) {
        matrix_getter = mgetter
    }
    
    func convert(
        _ img_src_: LCImageSmPtr,
        _ img_dst_: LCImageSmPtr,
        _ transform: LL2DAffine,
        _ resizing: Bool
    )
    async
    {
        let srcWidth = await LCImageWidth(img_src_)
        let srcHeight = await LCImageHeight(img_src_)
        
        var dstWidth = srcWidth
        var dstHeight = srcHeight
        
        // アフィン変換後の外接矩形を計算してリサイズ
        if resizing {
            let boundingBox = __calculateBoundingBoxForAffine(srcWidth, srcHeight, transform)
            dstWidth = boundingBox.0
            dstHeight = boundingBox.1
        }
        
        // 出力画像のリサイズ
        let type = await LCImageGetType(img_src_)
        await LCImageResizeWithType(img_dst_, dstWidth, dstHeight, type)

        let mat_src = await matrix_getter(img_src_)!
        let mat_dst = await matrix_getter(img_dst_)!

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
                            dstWidth: dstWidth,
                            dstHeight: dstHeight,
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
        dstWidth: Int,
        dstHeight: Int,
        transform: LL2DAffine
    ) {
        // 逆アフィン変換を計算
        let inverseTransform = LL2DAffineInverse(transform)
        
        // 出力画像の座標 (x, y) を元に、入力画像上の対応する座標を計算
        let srcX = inverseTransform.a * Double(x) + inverseTransform.b * Double(y) + inverseTransform.c
        let srcY = inverseTransform.d * Double(x) + inverseTransform.e * Double(y) + inverseTransform.f

        // 最近傍補間のために整数座標に丸める
        let srcXInt = Int(round(srcX))
        let srcYInt = Int(round(srcY))

        // 範囲外チェック
        if srcXInt >= 0 && srcXInt < srcWidth && srcYInt >= 0 && srcYInt < srcHeight {
            // 元画像から対応するピクセルを取得
            pdst[y][x] = psrc[srcYInt][srcXInt]
        } 
        else {
            // 範囲外の場合はデフォルト値を設定
            pdst[y][x] = .init(0.0) // 黒
        }
    }
}

class __LCImageProcAffineTransformNearestColor<TType, TColor> 
where TColor: LLColorType, TType: LLFloatConvertable 
{
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    
    var matrix_getter: (LCImageSmPtr) async -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) async -> TMatrix?) {
        matrix_getter = mgetter
    }
    
    func convert(
        _ img_src_: LCImageSmPtr,
        _ img_dst_: LCImageSmPtr,
        _ transform: LL2DAffine,
        _ resizing: Bool
    )
    async
    {
        let srcWidth = await LCImageWidth(img_src_)
        let srcHeight = await LCImageHeight(img_src_)
        
        var dstWidth = srcWidth
        var dstHeight = srcHeight
        
        // アフィン変換後の外接矩形を計算してリサイズ
        if resizing {
            let boundingBox = __calculateBoundingBoxForAffine(srcWidth, srcHeight, transform)
            dstWidth = boundingBox.0
            dstHeight = boundingBox.1
        }
        
        // 出力画像のリサイズ
        let type = await LCImageGetType(img_src_)
        await LCImageResizeWithType(img_dst_, dstWidth, dstHeight, type)

        let mat_src = await matrix_getter(img_src_)!
        let mat_dst = await matrix_getter(img_dst_)!

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
                            dstWidth: dstWidth,
                            dstHeight: dstHeight,
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
        dstWidth: Int,
        dstHeight: Int,
        transform: LL2DAffine
    )
    {
        // 逆アフィン変換を計算
        let inverseTransform = LL2DAffineInverse(transform)
        
        // 出力画像の座標 (x, y) を元に、入力画像上の対応する座標を計算
        let srcX = inverseTransform.a * Double(x) + inverseTransform.b * Double(y) + inverseTransform.c
        let srcY = inverseTransform.d * Double(x) + inverseTransform.e * Double(y) + inverseTransform.f

        // 最近傍補間のために整数座標に丸める
        let srcXInt = Int(round(srcX))
        let srcYInt = Int(round(srcY))

        // 範囲外チェック
        if srcXInt >= 0 && srcXInt < srcWidth && srcYInt >= 0 && srcYInt < srcHeight {
            // 元画像から対応するピクセルを取得
            pdst[y][x] = psrc[srcYInt][srcXInt]
        } 
        else {
            // 範囲外の場合は透明
            pdst[y][x] = .init(
                R: TColor.Unit(0.0),
                G: TColor.Unit(0.0),
                B: TColor.Unit(0.0),
                A: TColor.Unit(0.0)
            )
        }
    }
}
