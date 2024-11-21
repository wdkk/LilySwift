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
        let module = __LCImageProcScaleBiCubicColor<LLUInt8, LLColor8>(LCImageRGBA8Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgba16:
        let module = __LCImageProcScaleBiCubicColor<LLUInt16, LLColor16>(LCImageRGBA16Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgbaf:
        let module = __LCImageProcScaleBiCubicColor<LLFloat, LLColor>(LCImageRGBAfMatrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    default:
        LLLogForce("unsupported this image type.")
        break
    }
}

class __LCImageProcScaleBiCubic<TType, TColor> where TColor: LLFloatConvertable {
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    typealias TPointer = UnsafeMutablePointer<UnsafeMutablePointer<UnsafeMutablePointer<TType>>>
    
    var matrix_getter: (LCImageSmPtr) -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) -> TMatrix?) { matrix_getter = mgetter }
    
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

        let new_wid = LCImageWidth(img_dst_)
        let new_hgt = LCImageHeight(img_dst_)  

        let mat_src = matrix_getter(img_src_)!
        let mat_dst = matrix_getter(img_dst_)!
        
        let sc_x = Double(wid - 1) / Double(new_wid - 1)
        let sc_y = Double(hgt - 1) / Double(new_hgt - 1)
        
        mat_src.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { psrc in
            mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { pdst in
                for y in 0 ..< new_hgt {
                    for x in 0 ..< new_wid {
                        interpolateBiCubic(psrc, pdst, x, y, sc_x, sc_y, wid, hgt)
                    }
                }
            }
        }
    }
    
    func cubicKernel(_ x: Double) -> Double {
        let absX = abs(x)
        if absX <= 1.0 {
            return (1.5 * absX - 2.5) * absX * absX + 1.0
        } else if absX < 2.0 {
            return ((-0.5 * absX + 2.5) * absX - 4.0) * absX + 2.0
        } else {
            return 0.0
        }
    }
    
    func interpolateBiCubic(
        _ psrc: UnsafeMutablePointer<UnsafeMutablePointer<TColor>>,
        _ pdst: UnsafeMutablePointer<UnsafeMutablePointer<TColor>>,
        _ x: Int,
        _ y: Int,
        _ sc_x: Double,
        _ sc_y: Double,
        _ wid: Int,
        _ hgt: Int
    ) {
        let fx = Double(x) * sc_x
        let fy = Double(y) * sc_y
        
        let x0 = Int(floor(fx))
        let y0 = Int(floor(fy))
        
        var sum: Double = 0.0
        var weightSum: Double = 0.0

        for m in -1...2 {
            for n in -1...2 {
                let px = max(0, min(wid - 1, x0 + n))
                let py = max(0, min(hgt - 1, y0 + m))
                
                let dx = fx - Double(x0 + n)
                let dy = fy - Double(y0 + m)
                
                let weight = cubicKernel(dx) * cubicKernel(dy)
                weightSum += weight
                sum += weight * psrc[py][px].d
            }
        }

        pdst[y][x] = .init(sum / weightSum)
    }
}

class __LCImageProcScaleBiCubicColor<TType, TColor> where TColor: LLColorType, TType: LLFloatConvertable {
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    typealias TPointer = UnsafeMutablePointer<UnsafeMutablePointer<UnsafeMutablePointer<TType>>>
    
    var matrix_getter: (LCImageSmPtr) -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) -> TMatrix?) { matrix_getter = mgetter }
    
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

        let new_wid = LCImageWidth(img_dst_)
        let new_hgt = LCImageHeight(img_dst_)  

        let mat_src = matrix_getter(img_src_)!
        let mat_dst = matrix_getter(img_dst_)!
        
        let sc_x = Double(wid - 1) / Double(new_wid - 1)
        let sc_y = Double(hgt - 1) / Double(new_hgt - 1)
        
        mat_src.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { psrc in
            mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { pdst in
                for y in 0 ..< new_hgt {
                    for x in 0 ..< new_wid {
                        interpolateBiCubic(psrc, pdst, x, y, sc_x, sc_y, wid, hgt)
                    }
                }
            }
        }
    }
    
    func cubicKernel(_ x: Double) -> Double {
        let absX = abs(x)
        if absX <= 1.0 {
            return (1.5 * absX - 2.5) * absX * absX + 1.0
        } else if absX < 2.0 {
            return ((-0.5 * absX + 2.5) * absX - 4.0) * absX + 2.0
        } else {
            return 0.0
        }
    }
    
    func interpolateBiCubic(
        _ psrc: UnsafeMutablePointer<UnsafeMutablePointer<TColor>>,
        _ pdst: UnsafeMutablePointer<UnsafeMutablePointer<TColor>>,
        _ x: Int,
        _ y: Int,
        _ sc_x: Double,
        _ sc_y: Double,
        _ wid: Int,
        _ hgt: Int
    )
    {
        let fx = Double(x) * sc_x
        let fy = Double(y) * sc_y
        
        let x0 = Int(floor(fx))
        let y0 = Int(floor(fy))
        
        var R: Double = 0.0
        var G: Double = 0.0
        var B: Double = 0.0
        var A: Double = 0.0
        var weightSum: Double = 0.0

        for m in -1...2 {
            for n in -1...2 {
                let px = max(0, min(wid - 1, x0 + n))
                let py = max(0, min(hgt - 1, y0 + m))
                
                let dx = fx - Double(x0 + n)
                let dy = fy - Double(y0 + m)
                
                let weight = cubicKernel(dx) * cubicKernel(dy)
                weightSum += weight
                
                let color = psrc[py][px]
                R += weight * color.R.d
                G += weight * color.G.d
                B += weight * color.B.d
                A += weight * color.A.d
            }
        }
        
        // 正規化して値を設定
        if weightSum > 0.0 {
            pdst[y][x] = .init(
                R: LLWithin( min:TColor.min, TColor.Unit(R / weightSum), max:TColor.max ),
                G: LLWithin( min:TColor.min, TColor.Unit(G / weightSum), max:TColor.max ),
                B: LLWithin( min:TColor.min, TColor.Unit(B / weightSum), max:TColor.max ),
                A: LLWithin( min:TColor.min, TColor.Unit(A / weightSum), max:TColor.max )
            )
        } else {
            // 重みがない場合のデフォルト値
            pdst[y][x] = .init(R: TColor.Unit(0.d), G: TColor.Unit(0.d), B: TColor.Unit(0.d), A: TColor.Unit(0.d))
        }
    }
}
