//
//  LCImage.proc.scaleBiLinear.swift
//  LilySwift
//
//  Created by Kengo Watanabe on 2024/11/17.
//  Copyright © 2024 Watanabe-Denki, Inc. All rights reserved.
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
        let module = __LCImageProcScaleBiLinearInt<LLUInt8, LLUInt8>(LCImageGrey8Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .grey16:
        let module = __LCImageProcScaleBiLinearInt<LLUInt16, LLUInt16>(LCImageGrey16Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .greyf:
        let module = __LCImageProcScaleBiLinearFloat<LLFloat, LLFloat>(LCImageGreyfMatrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgba8:
        let module = __LCImageProcScaleBiLinearInt<LLUInt8, LLColor8>(LCImageRGBA8Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgba16:
        let module = __LCImageProcScaleBiLinearInt<LLUInt16, LLColor16>(LCImageRGBA16Matrix)
        module.convert(img_src_, img_dst_, width, height)
        break
    case .rgbaf:
        let module = __LCImageProcScaleBiLinearFloat<LLFloat, LLColor>(LCImageRGBAfMatrix)
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
{
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

        let new_wid = LCImageWidth(img_dst_)
        let new_hgt = LCImageHeight(img_dst_)  

        let mat_src = matrix_getter(img_src_)!
        let mat_dst = matrix_getter(img_dst_)!
        
        let sc_x = Double(wid - 1) / Double(new_wid - 1)
        let sc_y = Double(hgt - 1) / Double(new_hgt - 1)
        
        if type == .grey8 || type == .grey16 || type == .greyf {
            mat_src.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { psrc in
                mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { pdst in
                    for y in 0 ..< new_hgt {
                        for x in 0 ..< new_wid {
                            interpolateBiLinearGrey( psrc, pdst, x, y, sc_x, sc_y, wid, hgt, new_wid, new_hgt )
                        }
                    }
                }
            }
        }
        else {
            mat_src.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { psrc in
                mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { pdst in
                    for y in 0 ..< new_hgt {
                        for x in 0 ..< new_wid {
                            interpolateBiLinearColor( psrc, pdst, x, y, sc_x, sc_y, wid, hgt, new_wid, new_hgt )
                        }
                    }
                }
            }
        }
    }
    
    func interpolateBiLinearGrey(
        _ psrc: UnsafeMutablePointer<UnsafeMutablePointer<TType>>,
        _ pdst: UnsafeMutablePointer<UnsafeMutablePointer<TType>>,
        _ x: Int,
        _ y: Int,
        _ sc_x: Double,
        _ sc_y: Double,
        _ wid: Int,
        _ hgt: Int,
        _ new_wid: Int,
        _ new_hgt: Int
    )
    {}
    
    func interpolateBiLinearColor(
        _ psrc: UnsafeMutablePointer<UnsafeMutablePointer<TType>>,
        _ pdst: UnsafeMutablePointer<UnsafeMutablePointer<TType>>,
        _ x: Int,
        _ y: Int,
        _ sc_x: Double,
        _ sc_y: Double,
        _ wid: Int,
        _ hgt: Int,
        _ new_wid: Int,
        _ new_hgt: Int
    )
    {}
}

class __LCImageProcScaleBiLinearInt<TType, TColor> 
: __LCImageProcScaleBiLinear<TType, TColor> 
where TType:BinaryInteger
, TColor:LLColorType
{
    override func interpolateBiLinearGrey(
        _ psrc: UnsafeMutablePointer<UnsafeMutablePointer<TType>>,
        _ pdst: UnsafeMutablePointer<UnsafeMutablePointer<TType>>,
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
        let fx = Double(x) * sc_x
        let fy = Double(y) * sc_y
        
        let x0 = Int(fx)
        let y0 = Int(fy)
        let x1 = min(x0 + 1, wid - 1)
        let y1 = min(y0 + 1, hgt - 1)
        
        let dx = fx - Double(x0)
        let dy = fy - Double(y0)
        
        // 線形補間に用いる値
        let v00 = Double( psrc[y0][x0] )
        let v01 = Double( psrc[y0][x1] )
        let v10 = Double( psrc[y1][x0] )
        let v11 = Double( psrc[y1][x1] )
        
        let invdx = (1.0 - dx)
        let invdy = (1.0 - dy)
        
        var v = invdx * invdy * v00
        v += dx * invdy * v01
        v += invdx * dy * v10
        v += dx * dy * v11
        
        pdst[y][x] = TType( v )
    }
    
    override func interpolateBiLinearColor(
        _ psrc: UnsafeMutablePointer<UnsafeMutablePointer<TType>>,
        _ pdst: UnsafeMutablePointer<UnsafeMutablePointer<TType>>,
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
        let fx = Double(x) * sc_x
        let fy = Double(y) * sc_y
        
        let x0 = Int(fx)
        let y0 = Int(fy)
        let x1 = min(x0 + 1, wid - 1)
        let y1 = min(y0 + 1, hgt - 1)
        
        let dx = fx - Double(x0)
        let dy = fy - Double(y0)
        
        // 線形補間に用いる値
        let v00 = Double( psrc[y0][x0] )
        let v01 = Double( psrc[y0][x1] )
        let v10 = Double( psrc[y1][x0] )
        let v11 = Double( psrc[y1][x1] )
        
        let invdx = (1.0 - dx)
        let invdy = (1.0 - dy)
        
        var v = invdx * invdy * v00
        v += dx * invdy * v01
        v += invdx * dy * v10
        v += dx * dy * v11
        
        pdst[y][x] = TType( v )
    }
}

class __LCImageProcScaleBiLinearFloat<TType, TColor>
: __LCImageProcScaleBiLinear<TType, TColor> 
where TType:BinaryFloatingPoint
, TColor:LLColorType
{
    override func interpolateBiLinearGrey(
        _ psrc: UnsafeMutablePointer<UnsafeMutablePointer<TType>>,
        _ pdst: UnsafeMutablePointer<UnsafeMutablePointer<TType>>,
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
        let fx = Double(x) * sc_x
        let fy = Double(y) * sc_y
        
        let x0 = Int(fx)
        let y0 = Int(fy)
        let x1 = min(x0 + 1, wid - 1)
        let y1 = min(y0 + 1, hgt - 1)
        
        let dx = fx - Double(x0)
        let dy = fy - Double(y0)
        
        // 線形補間に用いる値
        let v00 = Double( psrc[y0][x0] )
        let v01 = Double( psrc[y0][x1] )
        let v10 = Double( psrc[y1][x0] )
        let v11 = Double( psrc[y1][x1] )
        
        let invdx = (1.0 - dx)
        let invdy = (1.0 - dy)
        
        var v = invdx * invdy * v00
        v += dx * invdy * v01
        v += invdx * dy * v10
        v += dx * dy * v11
        
        pdst[y][x] = TType( v )
    }
}
