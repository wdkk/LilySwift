//
//  LCImage.proc.scaleBiCubic.swift
//  LilySwift
//
//  Created by Kengo Watanabe on 2024/11/17.
//  Copyright © 2024 Watanabe-Denki, Inc. All rights reserved.
//

import Foundation

public func LCImageProcScaleBiCubic(
    _ img_src_: LCImageSmPtr,
    _ img_dst_: LCImageSmPtr,
    _ width: Int,
    _ height: Int
) {
    switch LCImageGetType(img_src_) {
    case .grey8:
        let module = __LCImageProcScaleBiCubic<LLUInt8, LLUInt8>(LCImageGrey8Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .grey16:
        let module = __LCImageProcScaleBiCubic<LLUInt16, LLUInt16>(LCImageGrey16Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .greyf:
        let module = __LCImageProcScaleBiCubic<LLFloat, LLFloat>(LCImageGreyfMatrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgba8:
        let module = __LCImageProcScaleBiCubic<LLColor8, LLColor8>(LCImageRGBA8Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgba16:
        let module = __LCImageProcScaleBiCubic<LLColor16, LLColor16>(LCImageRGBA16Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgbaf:
        let module = __LCImageProcScaleBiCubic<LLColor, LLColor>(LCImageRGBAfMatrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    default:
        LLLogForce("unsupported this image type.")
        break
    }
}

class __LCImageProcScaleBiCubic<TType, TColor> {
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    typealias TPointer = UnsafeMutablePointer<UnsafeMutablePointer<UnsafeMutablePointer<TType>>>
    
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
        
        let sc_x = Double(wid) / Double(new_width)
        let sc_y = Double(hgt) / Double(new_height)
        
        mat_src.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { psrc in
            mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { pdst in
                for y in 0..<new_height {
                    for x in 0..<new_width {
                        // 元画像上の位置
                        let fx = Double(x) * sc_x
                        let fy = Double(y) * sc_y
                        
                        let x0 = Int(fx)
                        let y0 = Int(fy)
                        
                        let dx = fx - Double(x0)
                        let dy = fy - Double(y0)
                        
                        // 16ピクセルを使用して補間
                        //let value = bicubicInterpolate(psrc, x0, y0, dx, dy, wid, hgt)
                        
                        //pdst[y][x] = value
                    }
                }
            }
        }
    }
    
    /*
    private func bicubicInterpolate(
        _ psrc: UnsafeMutablePointer<UnsafeMutablePointer<TType>>,
        _ x: Int,
        _ y: Int,
        _ dx: Double,
        _ dy: Double,
        _ width: Int,
        _ height: Int
    ) -> TType
    {
        var result = 0.0
        
        // 三次補間関数
        func cubicWeight(_ t: Double) -> Double {
            let absT = abs(t)
            if absT <= 1.0 {
                return 1.0 - 2.0 * absT * absT + absT * absT * absT
            }
            else if absT <= 2.0 {
                return 4.0 - 8.0 * absT + 5.0 * absT * absT - absT * absT * absT
            }
            return 0.0
        }
        
        // 4×4のピクセル領域を走査
        for m in -1...2 {
            for n in -1...2 {
                let px = min(max(x + n, 0), width - 1)
                let py = min(max(y + m, 0), height - 1)
                let weight = cubicWeight(Double(n) - dx) * cubicWeight(Double(m) - dy)
                result += Double(psrc[py][px]) * weight
            }
        }
        
        return TType(result)
    }
    */
}
