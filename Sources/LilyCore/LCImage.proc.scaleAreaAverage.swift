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

public func LCImageProcScaleAreaAverage(
    _ img_src_: LCImageSmPtr,
    _ img_dst_: LCImageSmPtr,
    _ width: Int,
    _ height: Int
) 
{
    switch LCImageGetType(img_src_) {
    case .grey8:
        let module = __LCImageProcScaleAreaAverage<LLUInt8, LLUInt8>(LCImageGrey8Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .grey16:
        let module = __LCImageProcScaleAreaAverage<LLUInt16, LLUInt16>(LCImageGrey16Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .greyf:
        let module = __LCImageProcScaleAreaAverage<LLFloat, LLFloat>(LCImageGreyfMatrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgba8:
        let module = __LCImageProcScaleAreaAverageColor<LLUInt8, LLColor8>(LCImageRGBA8Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgba16:
        let module = __LCImageProcScaleAreaAverageColor<LLUInt16, LLColor16>(LCImageRGBA16Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgbaf:
        let module = __LCImageProcScaleAreaAverageColor<LLFloat, LLColor>(LCImageRGBAfMatrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .hsvf:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcScaleAreaAverage(img_conv, img_dst_, width, height)
        LCImageConvertType(img_dst_, .hsvf)
        break
    case .hsvi:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcScaleAreaAverage(img_conv, img_dst_, width, height)
        LCImageConvertType(img_dst_, .hsvi)
        break
    default:
        LLLogForce("unsupported this image type.")
        break
    }
}

class __LCImageProcScaleAreaAverage<TType, TColor> where TColor: LLFloatConvertable {
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
    ) 
    {
        let type = LCImageGetType(img_src_)
        let wid = LCImageWidth(img_src_)
        let hgt = LCImageHeight(img_src_)

        LCImageResizeWithType(img_dst_, new_width, new_height, type)

        let mat_src = matrix_getter(img_src_)!
        let mat_dst = matrix_getter(img_dst_)!
        
        let scale_x = Double(wid) / Double(new_width)
        let scale_y = Double(hgt) / Double(new_height)
        
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
}

class __LCImageProcScaleAreaAverageColor<TType, TColor> where TColor: LLColorType, TType: LLFloatConvertable {
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
    ) 
    {
        let type = LCImageGetType(img_src_)
        let wid = LCImageWidth(img_src_)
        let hgt = LCImageHeight(img_src_)

        LCImageResizeWithType(img_dst_, new_width, new_height, type)

        let mat_src = matrix_getter(img_src_)!
        let mat_dst = matrix_getter(img_dst_)!
        
        let scale_x = Double(wid) / Double(new_width)
        let scale_y = Double(hgt) / Double(new_height)
        
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
                
                mat_dst[y][x] = .init(
                    R: TColor.Unit(R / count),
                    G: TColor.Unit(G / count),
                    B: TColor.Unit(B / count),
                    A: TColor.Unit(A / count)
                )
            }
        }
    }
}
