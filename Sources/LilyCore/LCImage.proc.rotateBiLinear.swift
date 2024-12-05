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

public func LCImageProcRotateBiLinear(
    _ img_src_: LCImageSmPtr,
    _ img_dst_: LCImageSmPtr,
    _ degree: LLFloat,
    _ resizing: Bool
) {
    switch LCImageGetType(img_src_) {
    case .grey8:
        let module = __LCImageProcRotateBiLinear<LLUInt8, LLUInt8>(LCImageGrey8Matrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .grey16:
        let module = __LCImageProcRotateBiLinear<LLUInt16, LLUInt16>(LCImageGrey16Matrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .greyf:
        let module = __LCImageProcRotateBiLinear<LLFloat, LLFloat>(LCImageGreyfMatrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .rgba8:
        let module = __LCImageProcRotateBiLinearColor<LLUInt8, LLColor8>(LCImageRGBA8Matrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .rgba16:
        let module = __LCImageProcRotateBiLinearColor<LLUInt16, LLColor16>(LCImageRGBA16Matrix)
        module.convert(img_src_, img_dst_, degree, resizing)
        break
    case .rgbaf:
        let module = __LCImageProcRotateBiLinearColor<LLFloat, LLColor>(LCImageRGBAfMatrix)
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

class __LCImageProcRotateBiLinear<TType, TColor>
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
                        interpolateBiLinear(
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
    
    func interpolateBiLinear(
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
    ) {
        // 逆変換で元画像上の座標を計算
        let dx = Double(x) - dstCenterX
        let dy = Double(y) - dstCenterY
        let srcX = cosTheta * dx + sinTheta * dy + centerX
        let srcY = -sinTheta * dx + cosTheta * dy + centerY

        let x0 = Int(floor(srcX))
        let y0 = Int(floor(srcY))
        let x1 = min(x0 + 1, srcWidth - 1)
        let y1 = min(y0 + 1, srcHeight - 1)
        
        let dx_frac = srcX - x0.d
        let dy_frac = srcY - y0.d

        if x0 >= 0 && y0 >= 0 && x1 < srcWidth && y1 < srcHeight {
            let v00 = psrc[y0][x0].f
            let v01 = psrc[y0][x1].f
            let v10 = psrc[y1][x0].f
            let v11 = psrc[y1][x1].f

            let inv_dx = (1.0.f - dx_frac.f)
            let inv_dy = (1.0.f - dy_frac.f)
            
            var value = inv_dx * inv_dy * v00
            value += dx_frac.f * inv_dy * v01
            value += inv_dx * dy_frac.f * v10
            value += dx_frac.f * dy_frac.f * v11
            
            pdst[y][x] = .init(value)
        } 
        else {
            pdst[y][x] = TColor( 0.0 )
        }
    }
}

class __LCImageProcRotateBiLinearColor<TType, TColor>
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
                        interpolateBiLinear(
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
    
    func interpolateBiLinear(
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

        let x0 = Int(floor(srcX))
        let y0 = Int(floor(srcY))
        let x1 = min(x0 + 1, srcWidth - 1)
        let y1 = min(y0 + 1, srcHeight - 1)
        
        let dx_frac = srcX - x0.d
        let dy_frac = srcY - y0.d
        
        if x0 >= 0 && y0 >= 0 && x1 < srcWidth-1 && y1 < srcHeight-1 {
            let c00 = psrc[y0][x0]
            let c01 = psrc[y0][x1]
            let c10 = psrc[y1][x0]
            let c11 = psrc[y1][x1]
            
            let inv_dx = 1.0 - dx_frac
            let inv_dy = 1.0 - dy_frac

            let R = inv_dx * inv_dy * c00.R.d +
                    dx_frac * inv_dy * c01.R.d +
                    inv_dx * dy_frac * c10.R.d +
                    dx_frac * dy_frac * c11.R.d

            let G = inv_dx * inv_dy * c00.G.d +
                    dx_frac * inv_dy * c01.G.d +
                    inv_dx * dy_frac * c10.G.d +
                    dx_frac * dy_frac * c11.G.d

            let B = inv_dx * inv_dy * c00.B.d +
                    dx_frac * inv_dy * c01.B.d +
                    inv_dx * dy_frac * c10.B.d +
                    dx_frac * dy_frac * c11.B.d

            let A = inv_dx * inv_dy * c00.A.d +
                    dx_frac * inv_dy * c01.A.d +
                    inv_dx * dy_frac * c10.A.d +
                    dx_frac * dy_frac * c11.A.d
            
            pdst[y][x] = .init(
                R: TColor.Unit(R),
                G: TColor.Unit(G),
                B: TColor.Unit(B),
                A: TColor.Unit(A)
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
