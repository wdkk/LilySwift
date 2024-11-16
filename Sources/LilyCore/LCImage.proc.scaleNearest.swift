//
//  LCImage.proc.scaleNearest.swift
//  LilySwift
//
//  Created by Kengo Watanabe on 2024/11/17.
//  Copyright © 2024 Watanabe-Denki, Inc. All rights reserved.
//

import Foundation

public func LCImageProcScaleNearest(
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr,
    _ width:Int,
    _ height:Int 
) 
{
    switch LCImageGetType( img_src_ ) {
    case .grey8:
        let module = __LCImageProcScaleNearest<LLUInt8, LLUInt8>( LCImageGrey8Matrix )
        module.convert( img_src_, img_dst_, width, height )
        break
    case .grey16:
        let module = __LCImageProcScaleNearest<LLUInt16, LLUInt16>( LCImageGrey16Matrix )
        module.convert( img_src_, img_dst_, width, height )
        break
    case .greyf:
        let module = __LCImageProcScaleNearest<LLFloat, LLFloat>( LCImageGreyfMatrix )
        module.convert( img_src_, img_dst_, width, height )
        break
    case .rgba8:
        let module = __LCImageProcScaleNearest<LLUInt8, LLColor8>( LCImageRGBA8Matrix )
        module.convert( img_src_, img_dst_, width, height )
        break
    case .rgba16:
        let module = __LCImageProcScaleNearest<LLUInt16, LLColor16>( LCImageRGBA16Matrix )
        module.convert( img_src_, img_dst_, width, height )
        break
    case .rgbaf:
        let module = __LCImageProcScaleNearest<LLFloat, LLColor>( LCImageRGBAfMatrix )
        module.convert( img_src_, img_dst_, width, height )
        break
    case .hsvf:
        let img_conv = LCImageClone( img_src_ )
        LCImageConvertType( img_conv, .rgbaf )
        LCImageProcScaleNearest( img_conv, img_dst_, width, height )
        LCImageConvertType( img_dst_, .hsvf )
        break
    case .hsvi:
        let img_conv = LCImageClone( img_src_ )
        LCImageConvertType( img_conv, .rgbaf )
        LCImageProcScaleNearest( img_conv, img_dst_, width, height )
        LCImageConvertType( img_dst_, .hsvi )
        break
    default:
        LLLogForce( "unsupported this image type." )
        break
    }
}

class __LCImageProcScaleNearest<TType, TColor> {
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
    ) 
    {
        let type = LCImageGetType( img_src_ )
        let wid = LCImageWidth( img_src_ )
        let hgt = LCImageHeight( img_src_ )

        LCImageResizeWithType( img_dst_, new_width, new_height, type )

        let new_wid = LCImageWidth( img_dst_ )
        let new_hgt = LCImageHeight( img_dst_ )  
        
        let mat_src = matrix_getter( img_src_ )!
        let mat_dst = matrix_getter( img_dst_ )!
        
        let sc_x = Double(wid) / Double(new_wid)
        let sc_y = Double(hgt) / Double(new_hgt)
        
        mat_src.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { psrc in
            mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { pdst in
                for y in 0 ..< new_hgt {
                    for x in 0 ..< new_wid {
                        let xx = Int(Double(x) * sc_x)
                        let yy = Int(Double(y) * sc_y)
                        pdst[y][x] = psrc[yy][xx]
                    }
                }
            }
        }
    }
}
