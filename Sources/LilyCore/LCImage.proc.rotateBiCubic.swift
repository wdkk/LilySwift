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

public func LCImageProcRotateBiCubic(
    _ img_src_: LCImageSmPtr,
    _ img_dst_: LCImageSmPtr,
    _ degree: LLFloat,
    _ resizing: Bool
) {
    switch LCImageGetType(img_src_) {
    case .grey8:
        let module = __LCImageProcRotateBiCubic<LLUInt8, LLUInt8>(LCImageGrey8Matrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .grey16:
        let module = __LCImageProcRotateBiCubic<LLUInt16, LLUInt16>(LCImageGrey16Matrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .greyf:
        let module = __LCImageProcRotateBiCubic<LLFloat, LLFloat>(LCImageGreyfMatrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .rgba8:
        let module = __LCImageProcRotateBiCubicColor<LLUInt8, LLColor8>(LCImageRGBA8Matrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .rgba16:
        let module = __LCImageProcRotateBiCubicColor<LLUInt16, LLColor16>(LCImageRGBA16Matrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .rgbaf:
        let module = __LCImageProcRotateBiCubicColor<LLFloat, LLColor>(LCImageRGBAfMatrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .hsvf:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcRotateBiLinear(img_conv, img_dst_, degree, resizing)
        LCImageConvertType(img_dst_, .hsvf)
        break
    case .hsvi:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcRotateBiLinear(img_conv, img_dst_, degree, resizing)
        LCImageConvertType(img_dst_, .hsvi)
        break
    default:
        LLLogForce("unsupported this image type.")
        break
    }
}

class __LCImageProcRotateBiCubic<TType, TColor>
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
                        interpolateBiCubic(
                            psrc,
                            pdst,
                            x,
                            y,
                            srcWidth,
                            srcHeight,
                            dstCenterX,
                            dstCenterY,
                            centerX,
                            centerY,
                            cosTheta,
                            sinTheta
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
        let rotated_corners = corners.map { corner in
            let rotatedX = corner.x * cosTheta - corner.y * sinTheta
            let rotatedY = corner.x * sinTheta + corner.y * cosTheta
            return (x: rotatedX, y: rotatedY)
        }
        
        // 外接矩形の範囲を計算
        let minX = rotated_corners.map { $0.x }.min()!
        let maxX = rotated_corners.map { $0.x }.max()!
        let minY = rotated_corners.map { $0.y }.min()!
        let maxY = rotated_corners.map { $0.y }.max()!
        
        let newWidth = Int(ceil(maxX - minX))
        let newHeight = Int(ceil(maxY - minY))
        
        return (newWidth, newHeight, -minX, -minY) // 新しい幅、高さ、および移動オフセット
    }
    
    func cubicInterpolate(
        _ p0: Double,
        _ p1: Double,
        _ p2: Double,
        _ p3: Double,
        _ t: Double
    ) 
    -> Double 
    {
        let a = -0.5 * p0 + 1.5 * p1 - 1.5 * p2 + 0.5 * p3
        let b = p0 - 2.5 * p1 + 2.0 * p2 - 0.5 * p3
        let c = -0.5 * p0 + 0.5 * p2
        let d = p1
        return a * t * t * t + b * t * t + c * t + d
    }
    
    func interpolateBiCubic(
        _ psrc:TMatrix,
        _ pdst:TMatrix,
        _ x: Int,
        _ y: Int,
        _ srcWidth: Int,
        _ srcHeight: Int,
        _ dstCenterX: Double,
        _ dstCenterY: Double,
        _ centerX: Double,
        _ centerY: Double,
        _ cosTheta: Double,
        _ sinTheta: Double
    ) 
    {
        // 逆変換で元画像上の座標を計算
        let dx = Double(x) - dstCenterX
        let dy = Double(y) - dstCenterY
        let srcX = cosTheta * dx + sinTheta * dy + centerX
        let srcY = -sinTheta * dx + cosTheta * dy + centerY

        let xInt = Int(floor(srcX))
        let yInt = Int(floor(srcY))
        
        let dx_frac = srcX - xInt.d
        let dy_frac = srcY - yInt.d

        if xInt >= 1 && yInt >= 1 && xInt < srcWidth - 2 && yInt < srcHeight - 2 {
            var columnResults = [Double](repeating: 0.0, count: 4)
            
            // 縦方向の補間
            for i in -1...2 {
                let row = [psrc[yInt + i][xInt - 1].d, psrc[yInt + i][xInt].d, psrc[yInt + i][xInt + 1].d, psrc[yInt + i][xInt + 2].d]
                columnResults[i + 1] = cubicInterpolate(row[0], row[1], row[2], row[3], dx_frac)
            }
            
            // 横方向の補間
            let final_value = cubicInterpolate(columnResults[0], columnResults[1], columnResults[2], columnResults[3], dy_frac)
            pdst[y][x] = LLWithin(min: TColor.colorRangeMinValue, .init( final_value ), max:TColor.colorRangeMaxValue ) 
        } 
        else {
            pdst[y][x] = TColor(0.0) // 範囲外はデフォルト値
        }
    }
}

class __LCImageProcRotateBiCubicColor<TType, TColor>
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
        _ degree: LLFloat,
        _ resizing: Bool
    )
    {
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
                        interpolateBiCubic(
                            psrc,
                            pdst,
                            x,
                            y,
                            srcWidth,
                            srcHeight,
                            dstCenterX,
                            dstCenterY,
                            centerX,
                            centerY,
                            cosTheta,
                            sinTheta
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
        let rotated_corners = corners.map { corner in
            let rotatedX = corner.x * cosTheta - corner.y * sinTheta
            let rotatedY = corner.x * sinTheta + corner.y * cosTheta
            return (x: rotatedX, y: rotatedY)
        }
        
        // 外接矩形の範囲を計算
        let minX = rotated_corners.map { $0.x }.min()!
        let maxX = rotated_corners.map { $0.x }.max()!
        let minY = rotated_corners.map { $0.y }.min()!
        let maxY = rotated_corners.map { $0.y }.max()!
        
        let newWidth = Int(ceil(maxX - minX))
        let newHeight = Int(ceil(maxY - minY))
        
        return (newWidth, newHeight, -minX, -minY) // 新しい幅、高さ、および移動オフセット
    }
    
    func cubicInterpolate(
        _ p0: Double,
        _ p1: Double,
        _ p2: Double,
        _ p3: Double,
        _ t: Double
    ) 
    -> Double 
    {
        let a = -0.5 * p0 + 1.5 * p1 - 1.5 * p2 + 0.5 * p3
        let b = p0 - 2.5 * p1 + 2.0 * p2 - 0.5 * p3
        let c = -0.5 * p0 + 0.5 * p2
        let d = p1
        return a * t * t * t + b * t * t + c * t + d
    }
    
    func interpolateBiCubic(
        _ psrc:TMatrix,
        _ pdst:TMatrix,
        _ x: Int,
        _ y: Int,
        _ srcWidth: Int,
        _ srcHeight: Int,
        _ dstCenterX: Double,
        _ dstCenterY: Double,
        _ centerX: Double,
        _ centerY: Double,
        _ cosTheta: Double,
        _ sinTheta: Double
    ) 
    {
        // 逆変換で元画像上の座標を計算
        let dx = Double(x) - dstCenterX
        let dy = Double(y) - dstCenterY
        let srcX = cosTheta * dx + sinTheta * dy + centerX
        let srcY = -sinTheta * dx + cosTheta * dy + centerY

        let xInt = Int(floor(srcX))
        let yInt = Int(floor(srcY))
        
        let dx_frac = srcX - xInt.d
        let dy_frac = srcY - yInt.d

        if xInt >= 1 && yInt >= 1 && xInt < srcWidth - 2 && yInt < srcHeight - 2 {
            // RGBA 各成分の BiCubic 補間
            var columnResultsR = [Double](repeating: 0.0, count: 4)
            var columnResultsG = [Double](repeating: 0.0, count: 4)
            var columnResultsB = [Double](repeating: 0.0, count: 4)
            var columnResultsA = [Double](repeating: 0.0, count: 4)
            
            for i in -1...2 {
                let row = [
                    psrc[yInt + i][xInt - 1],
                    psrc[yInt + i][xInt],
                    psrc[yInt + i][xInt + 1],
                    psrc[yInt + i][xInt + 2]
                ]
                columnResultsR[i + 1] = cubicInterpolate(row[0].R.d, row[1].R.d, row[2].R.d, row[3].R.d, dx_frac)
                columnResultsG[i + 1] = cubicInterpolate(row[0].G.d, row[1].G.d, row[2].G.d, row[3].G.d, dx_frac)
                columnResultsB[i + 1] = cubicInterpolate(row[0].B.d, row[1].B.d, row[2].B.d, row[3].B.d, dx_frac)
                columnResultsA[i + 1] = cubicInterpolate(row[0].A.d, row[1].A.d, row[2].A.d, row[3].A.d, dx_frac)
            }
            
            let finalR = cubicInterpolate(columnResultsR[0], columnResultsR[1], columnResultsR[2], columnResultsR[3], dy_frac)
            let finalG = cubicInterpolate(columnResultsG[0], columnResultsG[1], columnResultsG[2], columnResultsG[3], dy_frac)
            let finalB = cubicInterpolate(columnResultsB[0], columnResultsB[1], columnResultsB[2], columnResultsB[3], dy_frac)
            let finalA = cubicInterpolate(columnResultsA[0], columnResultsA[1], columnResultsA[2], columnResultsA[3], dy_frac)
            
            pdst[y][x] = .init(
                R: LLWithin( min:TColor.min, TColor.Unit( finalR ), max:TColor.max ),
                G: LLWithin( min:TColor.min, TColor.Unit( finalG ), max:TColor.max ),
                B: LLWithin( min:TColor.min, TColor.Unit( finalB ), max:TColor.max ),
                A: LLWithin( min:TColor.min, TColor.Unit( finalA ), max:TColor.max )
            )
        }
        else {
            // 範囲外はデフォルト値 (透明色)
            pdst[y][x] = .init(
                R: TColor.Unit(0.0),
                G: TColor.Unit(0.0),
                B: TColor.Unit(0.0),
                A: TColor.Unit(0.0)
            )
        }
    }
}
