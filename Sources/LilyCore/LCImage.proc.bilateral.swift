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

public func LCImageProcBilateralFilter(
    _ img_src_: LCImageSmPtr, 
    _ img_dst_: LCImageSmPtr,
    _ kernel: Int,
    _ dist: Double,
    _ lumi: Double
) {
    switch LCImageGetType(img_src_) {
    case .grey8:
        let module = __LCImageProcBilateralFilter<LLUInt8, LLUInt8>(LCImageGrey8Matrix)
        module.apply(img_src_, img_dst_, kernel, dist, lumi)
    case .grey16:
        let module = __LCImageProcBilateralFilter<LLUInt16, LLUInt16>(LCImageGrey16Matrix)
        module.apply(img_src_, img_dst_, kernel, dist, lumi)
    case .greyf:
        let module = __LCImageProcBilateralFilter<LLFloat, LLFloat>(LCImageGreyfMatrix)
        module.apply(img_src_, img_dst_, kernel, dist, lumi)
    case .rgba8:
        let module = __LCImageProcBilateralFilterColor<LLUInt8, LLColor8>(LCImageRGBA8Matrix)
        module.apply(img_src_, img_dst_, kernel, dist, lumi)
    case .rgba16:
        let module = __LCImageProcBilateralFilterColor<LLUInt16, LLColor16>(LCImageRGBA16Matrix)
        module.apply(img_src_, img_dst_, kernel, dist, lumi)
    case .rgbaf:
        let module = __LCImageProcBilateralFilterColor<LLFloat, LLColor>(LCImageRGBAfMatrix)
        module.apply(img_src_, img_dst_, kernel, dist, lumi)
    case .hsvf:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcBilateralFilter( img_src_, img_dst_, kernel, dist, lumi )
        LCImageConvertType(img_dst_, .hsvf)
        break
    case .hsvi:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcBilateralFilter( img_src_, img_dst_, kernel, dist, lumi )
        LCImageConvertType(img_dst_, .hsvi)
        break
    default:
        LLLogForce("unsupported this image type.")
    }
}

class __LCImageProcBilateralFilter<TType, TColor>
where TColor: LLFloatConvertable & Comparable
{
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    
    var matrix_getter: (LCImageSmPtr) -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) -> TMatrix?) { self.matrix_getter = mgetter }
    
    func apply(
        _ img_src_: LCImageSmPtr,
        _ img_dst_: LCImageSmPtr,
        _ kernel: Int,
        _ dist: Double,
        _ lumi: Double
    ) {
        let wid = LCImageWidth(img_src_)
        let hgt = LCImageHeight(img_src_)
        LCImageResizeWithType(img_dst_, wid, hgt, LCImageGetType(img_src_))

        let mat_src = matrix_getter(img_src_)!
        let mat_dst = matrix_getter(img_dst_)!
        let radius = kernel / 2
        let distFactor = -1.0 / (2.0 * dist * dist)
        let lumiFactor = -1.0 / (2.0 * lumi * lumi)
        
        mat_src.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { psrc in
            mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { pdst in
                for y in 0..<hgt {
                    for x in 0..<wid {
                        pdst[y][x] = computeFilteredPixel(
                            X: x,
                            y: y,
                            src: psrc,
                            width: wid, 
                            height: hgt,
                            kernelRadius: radius,
                            distFactor: distFactor,
                            lumiFactor: lumiFactor
                        )
                    }
                }
            }
        }
    }

    private func computeFilteredPixel(
        X x: Int,
        y: Int,
        src: TMatrix,
        width: Int,
        height: Int,
        kernelRadius: Int,
        distFactor: Double,
        lumiFactor: Double
    )
    -> TColor 
    {
        var totalWeight: Double = 0.0
        var filteredPixel: Double = 0.0

        for ky in -kernelRadius...kernelRadius {
            for kx in -kernelRadius...kernelRadius {
                let nx = x + kx
                let ny = y + ky
                
                // 範囲外はスキップ
                guard nx >= 0, ny >= 0, nx < width, ny < height else { continue }
                
                let neighborPixel = src[ny][nx].d
                let spatialDistance = Double(kx * kx + ky * ky)
                let intensityDistance = (neighborPixel - src[y][x].d) * (neighborPixel - src[y][x].d)
                
                let weight = exp(spatialDistance * distFactor + intensityDistance * lumiFactor)
                totalWeight += weight
                filteredPixel += weight * neighborPixel
            }
        }
        
        return LLWithin(min: TColor.colorRangeMinValue, .init( filteredPixel / totalWeight ), max:TColor.colorRangeMaxValue ) 
    }
}

class __LCImageProcBilateralFilterColor<TType, TColor>
where TColor: LLColorType, TType: LLFloatConvertable {
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    
    var matrix_getter: (LCImageSmPtr) -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) -> TMatrix?) {
        self.matrix_getter = mgetter
    }
    
    func apply(
        _ img_src_: LCImageSmPtr,
        _ img_dst_: LCImageSmPtr,
        _ kernel: Int,
        _ dist: Double,
        _ lumi: Double
    ) {
        let wid = LCImageWidth(img_src_)
        let hgt = LCImageHeight(img_src_)
        LCImageResizeWithType(img_dst_, wid, hgt, LCImageGetType(img_src_))

        let mat_src = matrix_getter(img_src_)!
        let mat_dst = matrix_getter(img_dst_)!
        let radius = kernel / 2
        let distFactor = -1.0 / (2.0 * dist * dist)
        let lumiFactor = -1.0 / (2.0 * lumi * lumi)
        
        mat_src.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { psrc in
            mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { pdst in
                for y in 0..<hgt {
                    for x in 0..<wid {
                        pdst[y][x] = computeFilteredPixelColor(
                            x: x,
                            y: y,
                            src: psrc,
                            width: wid,
                            height: hgt,
                            kernelRadius: radius,
                            distFactor: distFactor,
                            lumiFactor: lumiFactor
                        )
                    }
                }
            }
        }
    }

    private func computeFilteredPixelColor(
        x: Int,
        y: Int,
        src: TMatrix,
        width: Int,
        height: Int,
        kernelRadius: Int,
        distFactor: Double,
        lumiFactor: Double
    ) 
    -> TColor 
    {
        var sumWeightR: Double = 0.0
        var sumWeightG: Double = 0.0
        var sumWeightB: Double = 0.0
        var sumWeightA: Double = 0.0
        
        var filteredR: Double = 0.0
        var filteredG: Double = 0.0
        var filteredB: Double = 0.0
        var filteredA: Double = 0.0
        
        let target_pixel = src[y][x]
        let targetR = target_pixel.R.d
        let targetG = target_pixel.G.d
        let targetB = target_pixel.B.d
        let targetA = target_pixel.A.d

        for ky in -kernelRadius...kernelRadius {
            for kx in -kernelRadius...kernelRadius {
                let nx = x + kx
                let ny = y + ky
                
                guard nx >= 0, ny >= 0, nx < width, ny < height else { continue }
                
                let neighbor = src[ny][nx]
                
                let k1 = Double(kx * kx + ky * ky) * distFactor
                
                let intensityR = (neighbor.R.d - targetR) * (neighbor.R.d - targetR)
                let intensityG = (neighbor.G.d - targetG) * (neighbor.G.d - targetG)
                let intensityB = (neighbor.B.d - targetB) * (neighbor.B.d - targetB)
                let intensityA = (neighbor.A.d - targetA) * (neighbor.A.d - targetA)
                
                let weightR = exp( k1 + intensityR * lumiFactor )
                let weightG = exp( k1 + intensityG * lumiFactor )
                let weightB = exp( k1 + intensityB * lumiFactor )
                let weightA = exp( k1 + intensityA * lumiFactor )

                // 加重平均を計算
                filteredR += weightR * neighbor.R.d
                filteredG += weightG * neighbor.G.d
                filteredB += weightB * neighbor.B.d
                filteredA += weightA * neighbor.A.d
                
                // 分母を加算
                sumWeightR += weightR
                sumWeightG += weightG
                sumWeightB += weightB
                sumWeightA += weightA
            }
        }

        // 正規化して TColor に戻す
        let R = filteredR / sumWeightR
        let G = filteredG / sumWeightG
        let B = filteredB / sumWeightB
        let A = filteredA / sumWeightA

        return TColor(
            R: LLWithin( min:TColor.min, TColor.Unit( R ), max:TColor.max ),
            G: LLWithin( min:TColor.min, TColor.Unit( G ), max:TColor.max ),
            B: LLWithin( min:TColor.min, TColor.Unit( B ), max:TColor.max ),
            A: LLWithin( min:TColor.min, TColor.Unit( A ), max:TColor.max )
        )
    }
}
