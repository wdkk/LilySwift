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

public func LCImageProcScaleSmooth(
    _ img_src_: LCImageSmPtr,
    _ img_dst_: LCImageSmPtr,
    _ width: Int,
    _ height: Int
) {
    switch LCImageGetType(img_src_) {
    case .grey8:
        let module = __LCImageProcScaleSmooth<LLUInt8, LLUInt8>(LCImageGrey8Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .grey16:
        let module = __LCImageProcScaleSmooth<LLUInt16, LLUInt16>(LCImageGrey16Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .greyf:
        let module = __LCImageProcScaleSmooth<LLFloat, LLFloat>(LCImageGreyfMatrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgba8:
        let module = __LCImageProcScaleSmoothColor<LLUInt8, LLColor8>(LCImageRGBA8Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgba16:
        let module = __LCImageProcScaleSmoothColor<LLUInt16, LLColor16>(LCImageRGBA16Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgbaf:
        let module = __LCImageProcScaleSmoothColor<LLFloat, LLColor>(LCImageRGBAfMatrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .hsvf:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcScaleSmooth(img_conv, img_dst_, width, height)
        LCImageConvertType(img_dst_, .hsvf)
        break
    case .hsvi:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcScaleSmooth(img_conv, img_dst_, width, height)
        LCImageConvertType(img_dst_, .hsvi)
        break
    default:
        LLLogForce("unsupported this image type.")
        break
    }
}

class __LCImageProcScaleSmooth<TType, TColor>
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
        _ new_width: Int,
        _ new_height: Int
    ) {
        let type = LCImageGetType(img_src_)
        let wid = LCImageWidth(img_src_)
        let hgt = LCImageHeight(img_src_)

        LCImageResizeWithType(img_dst_, new_width, new_height, type)

        let mat_src = matrix_getter(img_src_)!
        let mat_dst = matrix_getter(img_dst_)!
        
        let scale_x = Double(wid) / Double(new_width)
        let scale_y = Double(hgt) / Double(new_height)
        
        if scale_x > 1.0 && scale_y > 1.0 {
            // 両方向で縮小 → AreaAverage
            areaAverage(mat_src, mat_dst, wid, hgt, new_width, new_height, scale_x, scale_y)
        } 
        else if scale_x <= 1.0 && scale_y <= 1.0 {
            // 両方向で拡大 → BiLinear
            biLinear(mat_src, mat_dst, wid, hgt, new_width, new_height)
        } 
        else if scale_x > 1.0 {
            // x方向縮小, y方向拡大
            areaAverageXBiLinearY(mat_src, mat_dst, wid, hgt, new_width, new_height, scale_x, scale_y)
        } 
        else {
            // x方向拡大, y方向縮小
            biLinearXAreaAverageY(mat_src, mat_dst, wid, hgt, new_width, new_height, scale_x, scale_y)
        }
    }
    
    func areaAverage(
        _ mat_src: TMatrix,
        _ mat_dst: TMatrix,
        _ wid: Int,
        _ hgt: Int,
        _ new_width: Int,
        _ new_height: Int,
        _ scale_x: Double,
        _ scale_y: Double
    ) {
        for y in 0..<new_height {
            for x in 0..<new_width {
                let src_x1 = Int(floor(Double(x) * scale_x))
                let src_x2 = Int(ceil(Double(x + 1) * scale_x))
                let src_y1 = Int(floor(Double(y) * scale_y))
                let src_y2 = Int(ceil(Double(y + 1) * scale_y))
                
                var sum: Double = 0.0
                var count: Double = 0.0
                
                for sy in src_y1..<src_y2 {
                    for sx in src_x1..<src_x2 {
                        sum += mat_src[sy][sx].d
                        count += 1.0
                    }
                }
                
                mat_dst[y][x] = .init(sum / count)
            }
        }
    }
    
    func biLinear(
        _ mat_src: TMatrix,
        _ mat_dst: TMatrix,
        _ wid: Int,
        _ hgt: Int,
        _ new_width: Int,
        _ new_height: Int
    ) {
        for y in 0..<new_height {
            let fy = Double(y) * Double(hgt - 1) / Double(new_height - 1)
            let y0 = Int(floor(fy))
            let y1 = min(y0 + 1, hgt - 1)
            let dy = fy - Double(y0)
            
            for x in 0..<new_width {
                let fx = Double(x) * Double(wid - 1) / Double(new_width - 1)
                let x0 = Int(floor(fx))
                let x1 = min(x0 + 1, wid - 1)
                let dx = fx - Double(x0)
                
                let v00 = mat_src[y0][x0].d
                let v10 = mat_src[y0][x1].d
                let v01 = mat_src[y1][x0].d
                let v11 = mat_src[y1][x1].d
                
                let value = (1 - dx) * (1 - dy) * v00 +
                            dx * (1 - dy) * v10 +
                            (1 - dx) * dy * v01 +
                            dx * dy * v11
                
                mat_dst[y][x] = .init(value)
            }
        }
    }
    
    func areaAverageXBiLinearY(
        _ mat_src: TMatrix,
        _ mat_dst: TMatrix,
        _ wid: Int,
        _ hgt: Int,
        _ new_width: Int,
        _ new_height: Int,
        _ scale_x: Double,
        _ scale_y: Double
    ) {
        for y in 0..<new_height {
            let fy = Double(y) * Double(hgt - 1) / Double(new_height - 1)
            let y0 = Int(floor(fy))
            let y1 = min(y0 + 1, hgt - 1)
            let dy = fy - Double(y0)
            
            for x in 0..<new_width {
                let src_x1 = Int(floor(Double(x) * scale_x))
                let src_x2 = Int(ceil(Double(x + 1) * scale_x))
                
                var sum: Double = 0.0
                var count: Double = 0.0
                
                for sx in src_x1..<src_x2 {
                    let v0 = mat_src[y0][sx].d
                    let v1 = mat_src[y1][sx].d
                    let value = (1 - dy) * v0 + dy * v1
                    sum += value
                    count += 1.0
                }
                
                mat_dst[y][x] = .init(sum / count)
            }
        }
    }
    
    func biLinearXAreaAverageY(
        _ mat_src: TMatrix,
        _ mat_dst: TMatrix,
        _ wid: Int,
        _ hgt: Int,
        _ new_width: Int,
        _ new_height: Int,
        _ scale_x: Double,
        _ scale_y: Double
    ) {
        for y in 0..<new_height {
            let src_y1 = Int(floor(Double(y) * scale_y))
            let src_y2 = Int(ceil(Double(y + 1) * scale_y))
            
            for x in 0..<new_width {
                let fx = Double(x) * Double(wid - 1) / Double(new_width - 1)
                let x0 = Int(floor(fx))
                let x1 = min(x0 + 1, wid - 1)
                let dx = fx - Double(x0)
                
                var sum: Double = 0.0
                var count: Double = 0.0
                
                for sy in src_y1..<src_y2 {
                    let v0 = mat_src[sy][x0].d
                    let v1 = mat_src[sy][x1].d
                    let value = (1 - dx) * v0 + dx * v1
                    sum += value
                    count += 1.0
                }
                
                mat_dst[y][x] = .init(sum / count)
            }
        }
    }
}

class __LCImageProcScaleSmoothColor<TType, TColor> 
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
        _ new_width: Int,
        _ new_height: Int
    ) {
        let type = LCImageGetType(img_src_)
        let wid = LCImageWidth(img_src_)
        let hgt = LCImageHeight(img_src_)

        LCImageResizeWithType(img_dst_, new_width, new_height, type)

        let mat_src = matrix_getter(img_src_)!
        let mat_dst = matrix_getter(img_dst_)!
        
        let scale_x = Double(wid) / Double(new_width)
        let scale_y = Double(hgt) / Double(new_height)
        
        if scale_x > 1.0 && scale_y > 1.0 {
            // 両方向で縮小 → AreaAverage
            areaAverage(mat_src, mat_dst, wid, hgt, new_width, new_height, scale_x, scale_y)
        } 
        else if scale_x <= 1.0 && scale_y <= 1.0 {
            // 両方向で拡大 → BiLinear
            biLinear(mat_src, mat_dst, wid, hgt, new_width, new_height)
        } 
        else if scale_x > 1.0 {
            // x方向縮小, y方向拡大
            areaAverageXBiLinearY(mat_src, mat_dst, wid, hgt, new_width, new_height, scale_x, scale_y)
        } 
        else {
            // x方向拡大, y方向縮小
            biLinearXAreaAverageY(mat_src, mat_dst, wid, hgt, new_width, new_height, scale_x, scale_y)
        }
    }
    
    func areaAverage(
        _ mat_src: TMatrix,
        _ mat_dst: TMatrix,
        _ wid: Int,
        _ hgt: Int,
        _ new_width: Int,
        _ new_height: Int,
        _ scale_x: Double,
        _ scale_y: Double
    ) {
        for y in 0..<new_height {
            for x in 0..<new_width {
                let src_x1 = Int(floor(Double(x) * scale_x))
                let src_x2 = Int(ceil(Double(x + 1) * scale_x))
                let src_y1 = Int(floor(Double(y) * scale_y))
                let src_y2 = Int(ceil(Double(y + 1) * scale_y))
                
                var R: Double = 0.0
                var G: Double = 0.0
                var B: Double = 0.0
                var A: Double = 0.0
                var count: Double = 0.0
                
                for sy in src_y1..<src_y2 {
                    for sx in src_x1..<src_x2 {
                        let color = mat_src[sy][sx]
                        R += color.R.d
                        G += color.G.d
                        B += color.B.d
                        A += color.A.d
                        count += 1.0
                    }
                }
                
                mat_dst[y][x] = TColor(
                    R: TColor.Unit(R / count),
                    G: TColor.Unit(G / count),
                    B: TColor.Unit(B / count),
                    A: TColor.Unit(A / count)
                )
            }
        }
    }
    
    func biLinear(
        _ mat_src: TMatrix,
        _ mat_dst: TMatrix,
        _ wid: Int,
        _ hgt: Int,
        _ new_width: Int,
        _ new_height: Int
    ) {
        for y in 0..<new_height {
            let fy = Double(y) * Double(hgt - 1) / Double(new_height - 1)
            let y0 = Int(floor(fy))
            let y1 = min(y0 + 1, hgt - 1)
            let dy = fy - Double(y0)
            
            for x in 0..<new_width {
                let fx = Double(x) * Double(wid - 1) / Double(new_width - 1)
                let x0 = Int(floor(fx))
                let x1 = min(x0 + 1, wid - 1)
                let dx = fx - Double(x0)
                
                let c00 = mat_src[y0][x0]
                let c10 = mat_src[y0][x1]
                let c01 = mat_src[y1][x0]
                let c11 = mat_src[y1][x1]
                
                let R = (1 - dx) * (1 - dy) * c00.R.d +
                        dx * (1 - dy) * c10.R.d +
                        (1 - dx) * dy * c01.R.d +
                        dx * dy * c11.R.d
                let G = (1 - dx) * (1 - dy) * c00.G.d +
                        dx * (1 - dy) * c10.G.d +
                        (1 - dx) * dy * c01.G.d +
                        dx * dy * c11.G.d
                let B = (1 - dx) * (1 - dy) * c00.B.d +
                        dx * (1 - dy) * c10.B.d +
                        (1 - dx) * dy * c01.B.d +
                        dx * dy * c11.B.d
                let A = (1 - dx) * (1 - dy) * c00.A.d +
                        dx * (1 - dy) * c10.A.d +
                        (1 - dx) * dy * c01.A.d +
                        dx * dy * c11.A.d
                
                mat_dst[y][x] = TColor(
                    R: TColor.Unit(R),
                    G: TColor.Unit(G),
                    B: TColor.Unit(B),
                    A: TColor.Unit(A)
                )
            }
        }
    }
    
    func areaAverageXBiLinearY(
        _ mat_src: TMatrix,
        _ mat_dst: TMatrix,
        _ wid: Int,
        _ hgt: Int,
        _ new_width: Int,
        _ new_height: Int,
        _ scale_x: Double,
        _ scale_y: Double
    ) {
        for y in 0..<new_height {
            let fy = Double(y) * Double(hgt - 1) / Double(new_height - 1)
            let y0 = Int(floor(fy))
            let y1 = min(y0 + 1, hgt - 1)
            let dy = fy - Double(y0)
            
            for x in 0..<new_width {
                let src_x1 = Int(floor(Double(x) * scale_x))
                let src_x2 = Int(ceil(Double(x + 1) * scale_x))
                
                var R: Double = 0.0
                var G: Double = 0.0
                var B: Double = 0.0
                var A: Double = 0.0
                var count: Double = 0.0
                
                for sx in src_x1..<src_x2 {
                    let c0 = mat_src[y0][sx]
                    let c1 = mat_src[y1][sx]
                    R += (1 - dy) * c0.R.d + dy * c1.R.d
                    G += (1 - dy) * c0.G.d + dy * c1.G.d
                    B += (1 - dy) * c0.B.d + dy * c1.B.d
                    A += (1 - dy) * c0.A.d + dy * c1.A.d
                    count += 1.0
                }
                
                mat_dst[y][x] = TColor(
                    R: TColor.Unit(R / count),
                    G: TColor.Unit(G / count),
                    B: TColor.Unit(B / count),
                    A: TColor.Unit(A / count)
                )
            }
        }
    }
    
    func biLinearXAreaAverageY(
        _ mat_src: TMatrix,
        _ mat_dst: TMatrix,
        _ wid: Int,
        _ hgt: Int,
        _ new_width: Int,
        _ new_height: Int,
        _ scale_x: Double,
        _ scale_y: Double
    ) {
        for y in 0..<new_height {
            let src_y1 = Int(floor(Double(y) * scale_y))
            let src_y2 = Int(ceil(Double(y + 1) * scale_y))
            
            for x in 0..<new_width {
                let fx = Double(x) * Double(wid - 1) / Double(new_width - 1)
                let x0 = Int(floor(fx))
                let x1 = min(x0 + 1, wid - 1)
                let dx = fx - Double(x0)
                
                var R: Double = 0.0
                var G: Double = 0.0
                var B: Double = 0.0
                var A: Double = 0.0
                var count: Double = 0.0
                
                for sy in src_y1..<src_y2 {
                    let c0 = mat_src[sy][x0]
                    let c1 = mat_src[sy][x1]
                    
                    R += (1 - dx) * c0.R.d + dx * c1.R.d
                    G += (1 - dx) * c0.G.d + dx * c1.G.d
                    B += (1 - dx) * c0.B.d + dx * c1.B.d
                    A += (1 - dx) * c0.A.d + dx * c1.A.d
                    count += 1.0
                }
                
                mat_dst[y][x] = TColor(
                    R: TColor.Unit(R / count),
                    G: TColor.Unit(G / count),
                    B: TColor.Unit(B / count),
                    A: TColor.Unit(A / count)
                )
            }
        }
    }
}
