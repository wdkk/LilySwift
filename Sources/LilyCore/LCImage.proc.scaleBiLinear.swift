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

public func LCImageProcScaleBiLinear(
    _ img_src_: LCImageSmPtr,
    _ img_dst_: LCImageSmPtr,
    _ width: Int,
    _ height: Int
) {
    switch LCImageGetType(img_src_) {
    case .grey8:
        let module = __LCImageProcScaleBiLinear<LLUInt8, LLUInt8>(LCImageGrey8Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .grey16:
        let module = __LCImageProcScaleBiLinear<LLUInt16, LLUInt16>(LCImageGrey16Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .greyf:
        let module = __LCImageProcScaleBiLinear<LLFloat, LLFloat>(LCImageGreyfMatrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgba8:
        let module = __LCImageProcScaleBiLinearColor<LLUInt8, LLColor8>(LCImageRGBA8Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgba16:
        let module = __LCImageProcScaleBiLinearColor<LLUInt16, LLColor16>(LCImageRGBA16Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgbaf:
        let module = __LCImageProcScaleBiLinearColor<LLFloat, LLColor>(LCImageRGBAfMatrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .hsvf:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcScaleBiLinear(img_conv, img_dst_, width, height)
        LCImageConvertType(img_dst_, .hsvf)
        break
    case .hsvi:
        let img_conv = LCImageClone(img_src_)
        LCImageConvertType(img_conv, .rgbaf)
        LCImageProcScaleBiLinear(img_conv, img_dst_, width, height)
        LCImageConvertType(img_dst_, .hsvi)
        break
    default:
        LLLogForce("unsupported this image type.")
        break
    }
}


class __LCImageProcScaleBiLinear<TType, TColor> 
where TColor:LLFloatConvertable
{
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    typealias TPointer = UnsafeMutablePointer<UnsafeMutablePointer<UnsafeMutablePointer<TType>>>
    
    var matrix_getter: (LCImageSmPtr) -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) -> TMatrix?) { matrix_getter = mgetter }
    
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
                        interpolateBiLinear( psrc, pdst, x, y, sc_x, sc_y, wid, hgt, new_wid, new_hgt )
                    }
                }
            }
        }
    }
    
    func interpolateBiLinear(
        _ psrc: TMatrix,
        _ pdst: TMatrix,
        _ x: Int,
        _ y: Int,
        _ sc_x: Double,
        _ sc_y: Double,
        _ wid: Int,
        _ hgt: Int,
        _ new_wid: Int,
        _ new_hgt: Int
    )
    {
        // 元画像上の座標
        let fx = (Double(x) * sc_x).f
        let fy = (Double(y) * sc_y).f
        
        let x0 = Int(fx)
        let y0 = Int(fy)
        let x1 = min(x0 + 1, wid - 1)
        let y1 = min(y0 + 1, hgt - 1)
        
        let dx = fx - x0.f
        let dy = fy - y0.f
        
        // 線形補間に用いる値
        let v00 = psrc[y0][x0].f
        let v01 = psrc[y0][x1].f
        let v10 = psrc[y1][x0].f
        let v11 = psrc[y1][x1].f
    
        let invdx = (1.0.f - dx)
        let invdy = (1.0.f - dy)
        
        var v = invdx * invdy * v00
        v += dx * invdy * v01
        v += invdx * dy * v10
        v += dx * dy * v11
        
        pdst[y][x] = .init( v )
    }
}

class __LCImageProcScaleBiLinearColor<TType, TColor>
where TColor:LLColorType, TType:LLFloatConvertable
{
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    
    var matrix_getter: (LCImageSmPtr) -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) -> TMatrix?) { matrix_getter = mgetter }
    
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
                        interpolateBiLinear( psrc, pdst, x, y, sc_x, sc_y, wid, hgt, new_wid, new_hgt )
                    }
                }
            }
        }
    }
    
    func interpolateBiLinear(
        _ psrc:TMatrix,
        _ pdst:TMatrix,
        _ x: Int,
        _ y: Int,
        _ sc_x: Double,
        _ sc_y: Double,
        _ wid: Int,
        _ hgt: Int,
        _ new_wid: Int,
        _ new_hgt: Int
    )
    {
        // 元画像上の座標
        let fx = (x.d * sc_x).f
        let fy = (y.d * sc_y).f
        
        let x0 = Int(fx)
        let y0 = Int(fy)
        let x1 = min(x0 + 1, wid - 1)
        let y1 = min(y0 + 1, hgt - 1)
        
        let dx = fx - x0.f
        let dy = fy - y0.f
        
        // 線形補間に用いる値
        let v00 = psrc[y0][x0]
        let v01 = psrc[y0][x1]
        let v10 = psrc[y1][x0]
        let v11 = psrc[y1][x1]
    
        let invdx = (1.0.f - dx)
        let invdy = (1.0.f - dy)
        
        let k00 = invdx * invdy
        let k01 = dx * invdy
        let k10 = invdx * dy
        let k11 = dx * dy
        
        var R = k00 * v00.R.f
        R += k01 * v01.R.f
        R += k10 * v10.R.f
        R += k11 * v11.R.f
        var G = k00 * v00.G.f
        G += k01 * v01.G.f
        G += k10 * v10.G.f 
        G += k11 * v11.G.f
        var B = k00 * v00.B.f
        B += k01 * v01.B.f
        B += k10 * v10.B.f
        B += k11 * v11.B.f
        var A = k00 * v00.A.f
        A += k01 * v01.A.f
        A += k10 * v10.A.f
        A += k11 * v11.A.f
       
        pdst[y][x] = .init( 
            R: TColor.Unit( R ), 
            G: TColor.Unit( G ),
            B: TColor.Unit( B ),
            A: TColor.Unit( A )
        )
    }
}
