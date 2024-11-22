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

public func LCImageProcRotateNearest(     
    _ img_src_: LCImageSmPtr, 
    _ img_dst_: LCImageSmPtr, 
    _ degree: LLFloat, 
    _ resizing: Bool 
) 
{
    switch LCImageGetType(img_src_) {
    case .grey8:
        let module = __LCImageProcRotateNearest<LLUInt8, LLUInt8>(LCImageGrey8Matrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .grey16:
        let module = __LCImageProcRotateNearest<LLUInt16, LLUInt16>(LCImageGrey16Matrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .greyf:
        let module = __LCImageProcRotateNearest<LLFloat, LLFloat>(LCImageGreyfMatrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .rgba8:
        let module = __LCImageProcRotateNearestColor<LLUInt8, LLColor8>(LCImageRGBA8Matrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .rgba16:
        let module = __LCImageProcRotateNearestColor<LLUInt16, LLColor16>(LCImageRGBA16Matrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .rgbaf:
        let module = __LCImageProcRotateNearestColor<LLFloat, LLColor>(LCImageRGBAfMatrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    default:
        LLLogForce("unsupported this image type.")
        break
    }
}

class __LCImageProcRotateNearest<TType, TColor> where TColor:LLFloatConvertable
{
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    
    var matrix_getter: (LCImageSmPtr) -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) -> TMatrix?) {
        matrix_getter = mgetter
    }
    
    func convert(
        _ img_src_: LCImageSmPtr,
        _ img_dst_: LCImageSmPtr,
        _ degree: LLFloat,
        _ resizing: Bool
    ) {
        let radian = degree.d * .pi / 180.0
        let cosTheta = cos(radian)
        let sinTheta = sin(radian)
        
        let srcWidth = LCImageWidth(img_src_)
        let srcHeight = LCImageHeight(img_src_)
        
        let centerX = Double(srcWidth) / 2.0
        let centerY = Double(srcHeight) / 2.0
        
        // 新しい画像サイズの計算
        var dstWidth = srcWidth
        var dstHeight = srcHeight
        if resizing {
            let boundingBox = calculateBoundingBoxUsingCorners(srcWidth, srcHeight, radian)
            dstWidth = boundingBox.0
            dstHeight = boundingBox.1
        }
        
        // 出力画像のリサイズ
        let type = LCImageGetType(img_src_)
        LCImageResizeWithType(img_dst_, dstWidth, dstHeight, type)

        let dstCenterX = Double(dstWidth) / 2.0
        let dstCenterY = Double(dstHeight) / 2.0

        let mat_src = matrix_getter(img_src_)!
        let mat_dst = matrix_getter(img_dst_)!

        mat_src.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { psrc in
            mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { pdst in
                for y in 0..<dstHeight {
                    for x in 0..<dstWidth {
                        processPixel(
                            x: x,
                            y: y,
                            dstWidth: dstWidth,
                            dstHeight: dstHeight,
                            srcWidth: srcWidth,
                            srcHeight: srcHeight,
                            dstCenterX: dstCenterX,
                            dstCenterY: dstCenterY,
                            centerX: centerX,
                            centerY: centerY,
                            cosTheta: cosTheta,
                            sinTheta: sinTheta,
                            psrc: psrc,
                            pdst: pdst
                        )
                    }
                }
            }
        }
    }
    
    func calculateBoundingBoxUsingCorners(
        _ srcWidth: Int,
        _ srcHeight: Int,
        _ radian: Double
    ) 
    -> (Int, Int, Double, Double) 
    {
        let cosTheta = cos(radian)
        let sinTheta = sin(radian)
        
        // 元画像の4頂点の座標
        let corners = [
            (x: 0.0, y: 0.0),
            (x: Double(srcWidth), y: 0.0),
            (x: Double(srcWidth), y: Double(srcHeight)),
            (x: 0.0, y: Double(srcHeight))
        ]
        
        // 回転後の4頂点の座標を計算
        var rotatedCorners = corners.map { corner in
            let rotatedX = corner.x * cosTheta - corner.y * sinTheta
            let rotatedY = corner.x * sinTheta + corner.y * cosTheta
            return (x: rotatedX, y: rotatedY)
        }
        
        // 外接矩形の範囲を計算
        let minX = rotatedCorners.map { $0.x }.min()!
        let maxX = rotatedCorners.map { $0.x }.max()!
        let minY = rotatedCorners.map { $0.y }.min()!
        let maxY = rotatedCorners.map { $0.y }.max()!
        
        let newWidth = Int(ceil(maxX - minX))
        let newHeight = Int(ceil(maxY - minY))
        
        return (newWidth, newHeight, -minX, -minY) // 新しい幅、高さ、および移動オフセット
    }
    
    private func processPixel(
        x: Int,
        y: Int,
        dstWidth: Int,
        dstHeight: Int,
        srcWidth: Int,
        srcHeight: Int,
        dstCenterX: Double,
        dstCenterY: Double,
        centerX: Double,
        centerY: Double,
        cosTheta: Double,
        sinTheta: Double,
        psrc: UnsafeMutablePointer<UnsafeMutablePointer<TColor>>,
        pdst: UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    ) {
        // 逆変換で元画像上の座標を計算
        let dx = Double(x) - dstCenterX
        let dy = Double(y) - dstCenterY
        let srcX = cosTheta * dx + sinTheta * dy + centerX
        let srcY = -sinTheta * dx + cosTheta * dy + centerY
        
        // 最近傍補間
        let srcXInt = Int(round(srcX))
        let srcYInt = Int(round(srcY))
        
        // 範囲外チェック
        if srcXInt >= 0 && srcXInt < srcWidth && srcYInt >= 0 && srcYInt < srcHeight {
            pdst[y][x] = psrc[srcYInt][srcXInt]
        } else {
            pdst[y][x] = .init( 0.0 )
        }
    }
}

class __LCImageProcRotateNearestColor<TType, TColor> where TColor: LLColorType, TType: LLFloatConvertable {
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    
    var matrix_getter: (LCImageSmPtr) -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) -> TMatrix?) {
        matrix_getter = mgetter
    }
    
    func convert(
        _ img_src_: LCImageSmPtr,
        _ img_dst_: LCImageSmPtr,
        _ degree: LLFloat,
        _ resizing: Bool
    ) {
        let radian = degree.d * .pi / 180.0
        let cosTheta = cos(radian)
        let sinTheta = sin(radian)
        
        let srcWidth = LCImageWidth(img_src_)
        let srcHeight = LCImageHeight(img_src_)
        
        let centerX = Double(srcWidth) / 2.0
        let centerY = Double(srcHeight) / 2.0
        
        // 新しい画像サイズの計算
        var dstWidth = srcWidth
        var dstHeight = srcHeight
        if resizing {
            let boundingBox = calculateBoundingBoxUsingCorners(srcWidth, srcHeight, radian)
            dstWidth = boundingBox.0
            dstHeight = boundingBox.1
        }
        
        // 出力画像のリサイズ
        let type = LCImageGetType(img_src_)
        LCImageResizeWithType(img_dst_, dstWidth, dstHeight, type)

        let dstCenterX = Double(dstWidth) / 2.0
        let dstCenterY = Double(dstHeight) / 2.0

        let mat_src = matrix_getter(img_src_)!
        let mat_dst = matrix_getter(img_dst_)!

        mat_src.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { psrc in
            mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { pdst in
                for y in 0..<dstHeight {
                    for x in 0..<dstWidth {
                        processPixel(
                            x: x,
                            y: y,
                            dstWidth: dstWidth,
                            dstHeight: dstHeight,
                            srcWidth: srcWidth,
                            srcHeight: srcHeight,
                            dstCenterX: dstCenterX,
                            dstCenterY: dstCenterY,
                            centerX: centerX,
                            centerY: centerY,
                            cosTheta: cosTheta,
                            sinTheta: sinTheta,
                            psrc: psrc,
                            pdst: pdst
                        )
                    }
                }
            }
        }
    }
    
    func calculateBoundingBoxUsingCorners(
        _ srcWidth: Int,
        _ srcHeight: Int,
        _ radian: Double
    ) 
    -> (Int, Int, Double, Double) 
    {
        let cosTheta = cos(radian)
        let sinTheta = sin(radian)
        
        // 元画像の4頂点の座標
        let corners = [
            (x: 0.0, y: 0.0),
            (x: Double(srcWidth), y: 0.0),
            (x: Double(srcWidth), y: Double(srcHeight)),
            (x: 0.0, y: Double(srcHeight))
        ]
        
        // 回転後の4頂点の座標を計算
        var rotatedCorners = corners.map { corner in
            let rotatedX = corner.x * cosTheta - corner.y * sinTheta
            let rotatedY = corner.x * sinTheta + corner.y * cosTheta
            return (x: rotatedX, y: rotatedY)
        }
        
        // 外接矩形の範囲を計算
        let minX = rotatedCorners.map { $0.x }.min()!
        let maxX = rotatedCorners.map { $0.x }.max()!
        let minY = rotatedCorners.map { $0.y }.min()!
        let maxY = rotatedCorners.map { $0.y }.max()!
        
        let newWidth = Int(ceil(maxX - minX))
        let newHeight = Int(ceil(maxY - minY))
        
        return (newWidth, newHeight, -minX, -minY) // 新しい幅、高さ、および移動オフセット
    }
    
    private func processPixel(
        x: Int,
        y: Int,
        dstWidth: Int,
        dstHeight: Int,
        srcWidth: Int,
        srcHeight: Int,
        dstCenterX: Double,
        dstCenterY: Double,
        centerX: Double,
        centerY: Double,
        cosTheta: Double,
        sinTheta: Double,
        psrc: UnsafeMutablePointer<UnsafeMutablePointer<TColor>>,
        pdst: UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    ) {
        // 逆変換で元画像上の座標を計算
        let dx = Double(x) - dstCenterX
        let dy = Double(y) - dstCenterY
        let srcX = cosTheta * dx + sinTheta * dy + centerX
        let srcY = -sinTheta * dx + cosTheta * dy + centerY
        
        // 最近傍補間
        let srcXInt = Int(round(srcX))
        let srcYInt = Int(round(srcY))
        
        // 範囲外チェック
        if srcXInt >= 0 && srcXInt < srcWidth && srcYInt >= 0 && srcYInt < srcHeight {
            pdst[y][x] = psrc[srcYInt][srcXInt]
        } 
        else {
            // 範囲外はデフォルト値 (透明色または黒)
            pdst[y][x] = .init(
                R: TColor.Unit(0.0),
                G: TColor.Unit(0.0),
                B: TColor.Unit(0.0),
                A: TColor.Unit(0.0)
            )
        }
    }
}
