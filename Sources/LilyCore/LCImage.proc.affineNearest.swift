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
    _ isResize: Bool
) 
{
    switch LCImageGetType(img_src_) {
    case .grey8:
        let module = __LCImageProcAffineTransformNearest<LLUInt8, LLUInt8>(LCImageGrey8Matrix)
        module.convert(img_src_, img_dst_, transform, isResize)
    case .grey16:
        let module = __LCImageProcAffineTransformNearest<LLUInt16, LLUInt16>(LCImageGrey16Matrix)
        module.convert(img_src_, img_dst_, transform, isResize)
    case .greyf:
        let module = __LCImageProcAffineTransformNearest<LLFloat, LLFloat>(LCImageGreyfMatrix)
        module.convert(img_src_, img_dst_, transform, isResize)
    case .rgba8:
        let module = __LCImageProcAffineTransformNearestColor<LLUInt8, LLColor8>(LCImageRGBA8Matrix)
        module.convert(img_src_, img_dst_, transform, isResize)
    case .rgba16:
        let module = __LCImageProcAffineTransformNearestColor<LLUInt16, LLColor16>(LCImageRGBA16Matrix)
        module.convert(img_src_, img_dst_, transform, isResize)
    case .rgbaf:
        let module = __LCImageProcAffineTransformNearestColor<LLFloat, LLColor>(LCImageRGBAfMatrix)
        module.convert(img_src_, img_dst_, transform, isResize)
    case .hsvf:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcAffineTransformNearest(img_conv, img_dst_, transform, isResize)
        LCImageConvertType(img_dst_, .hsvf)
        break
    case .hsvi:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcAffineTransformNearest(img_conv, img_dst_, transform, isResize)
        LCImageConvertType(img_dst_, .hsvi)
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
    _ isResize:Bool
) 
{
    // 入力画像の幅と高さを取得
    let srcWidth = LCImageWidth(img_src_)
    let srcHeight = LCImageHeight(img_src_)
    
    // 拡大縮小係数を計算
    let scaleX = Double(width) / Double(srcWidth)
    let scaleY = Double(height) / Double(srcHeight)
    let scalingTransform = LL2DAffineScale(scaleX, scaleY)
    
    // 回転変換を計算
    let rotationTransform = LL2DAffineRotate(Double(degree))
    
    // アフィン変換を合成
    let combinedTransform = LL2DAffineMultiply(scalingTransform, rotationTransform)
    
    // アフィン変換を適用して画像を変形
    LCImageProcAffineTransformNearest(img_src_, img_dst_, combinedTransform, isResize)
}

class __LCImageProcAffineTransformNearest<TType, TColor> 
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
        _ isResize: Bool
    ) {
        let srcWidth = LCImageWidth(img_src_)
        let srcHeight = LCImageHeight(img_src_)
        
        var dstWidth = srcWidth
        var dstHeight = srcHeight
        
        // アフィン変換後の外接矩形を計算してリサイズ
        if isResize {
            let boundingBox = calculateBoundingBoxForAffine(srcWidth, srcHeight, transform)
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
                            dstWidth: dstWidth,
                            dstHeight: dstHeight,
                            transform: transform
                        )
                    }
                }
            }
        }
    }
    
    func calculateBoundingBoxForAffine(
        _ srcWidth: Int,
        _ srcHeight: Int,
        _ transform: LL2DAffine
    ) -> (Int, Int) {
        // 元画像の4頂点
        let corners = [
            (x: 0.0, y: 0.0),
            (x: Double(srcWidth), y: 0.0),
            (x: Double(srcWidth), y: Double(srcHeight)),
            (x: 0.0, y: Double(srcHeight))
        ]
        
        // アフィン変換後の4頂点を計算
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
        
        let newWidth = Int(ceil(maxX - minX))
        let newHeight = Int(ceil(maxY - minY))
        
        return (newWidth, newHeight)
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
            pdst[y][x] = .init(0.0) // 透明または黒
        }
    }
}

class __LCImageProcAffineTransformNearestColor<TType, TColor> 
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
        _ isResize: Bool
    ) {
        let srcWidth = LCImageWidth(img_src_)
        let srcHeight = LCImageHeight(img_src_)
        
        var dstWidth = srcWidth
        var dstHeight = srcHeight
        
        // アフィン変換後の外接矩形を計算してリサイズ
        if isResize {
            let boundingBox = calculateBoundingBoxForAffine(srcWidth, srcHeight, transform)
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
                            dstWidth: dstWidth,
                            dstHeight: dstHeight,
                            transform: transform
                        )
                    }
                }
            }
        }
    }
    
    func calculateBoundingBoxForAffine(
        _ srcWidth: Int,
        _ srcHeight: Int,
        _ transform: LL2DAffine
    ) -> (Int, Int) {
        // 元画像の4頂点
        let corners = [
            (x: 0.0, y: 0.0),
            (x: Double(srcWidth), y: 0.0),
            (x: Double(srcWidth), y: Double(srcHeight)),
            (x: 0.0, y: Double(srcHeight))
        ]
        
        // アフィン変換後の4頂点を計算
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
        
        let newWidth = Int(ceil(maxX - minX))
        let newHeight = Int(ceil(maxY - minY))
        
        return (newWidth, newHeight)
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
            // 範囲外の場合はデフォルト値を設定 (透明色)
            pdst[y][x] = .init(
                R: TColor.Unit(0.0),
                G: TColor.Unit(0.0),
                B: TColor.Unit(0.0),
                A: TColor.Unit(0.0)
            )
        }
    }
}
