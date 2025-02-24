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

public func LCImageProcScaleNearest(
    _ img_src_:LCImageSmPtr, 
    _ img_dst_:LCImageSmPtr,
    _ width:Int,
    _ height:Int 
) 
async
{
    switch await LCImageGetType( img_src_ ) {
    case .grey8:
        let module = __LCImageProcScaleNearest<LLUInt8, LLUInt8>( LCImageGrey8Matrix )
        await module.convert( img_src_, img_dst_, width, height )
        break
    case .grey16:
        let module = __LCImageProcScaleNearest<LLUInt16, LLUInt16>( LCImageGrey16Matrix )
        await module.convert( img_src_, img_dst_, width, height )
        break
    case .greyf:
        let module = __LCImageProcScaleNearest<LLFloat, LLFloat>( LCImageGreyfMatrix )
        await module.convert( img_src_, img_dst_, width, height )
        break
    case .rgba8:
        let module = __LCImageProcScaleNearest<LLUInt8, LLColor8>( LCImageRGBA8Matrix )
        await module.convert( img_src_, img_dst_, width, height )
        break
    case .rgba16:
        let module = __LCImageProcScaleNearest<LLUInt16, LLColor16>( LCImageRGBA16Matrix )
        await module.convert( img_src_, img_dst_, width, height )
        break
    case .rgbaf:
        let module = __LCImageProcScaleNearest<LLFloat, LLColor>( LCImageRGBAfMatrix )
        await module.convert( img_src_, img_dst_, width, height )
        break
    case .hsvf:
        let img_conv = await LCImageClone( img_src_ )
        await LCImageConvertType( img_conv, .rgbaf )
        await LCImageProcScaleNearest( img_conv, img_dst_, width, height )
        await LCImageConvertType( img_dst_, .hsvf )
        break
    case .hsvi:
        let img_conv = await LCImageClone( img_src_ )
        await LCImageConvertType( img_conv, .rgbaf )
        await LCImageProcScaleNearest( img_conv, img_dst_, width, height )
        await LCImageConvertType( img_dst_, .hsvi )
        break
    default:
        LLLogForce( "unsupported this image type." )
        break
    }
}

class __LCImageProcScaleNearest<TType, TColor> 
{
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    
    var matrix_getter: (LCImageSmPtr) async -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) async -> TMatrix?) {
        matrix_getter = mgetter
    }
    
    func convert(
        _ img_src_: LCImageSmPtr,
        _ img_dst_: LCImageSmPtr,
        _ new_width: Int,
        _ new_height: Int
    ) 
    async
    {
        let type = await LCImageGetType( img_src_ )
        let wid = await LCImageWidth( img_src_ )
        let hgt = await LCImageHeight( img_src_ )

        await LCImageResizeWithType( img_dst_, new_width, new_height, type )

        let new_wid = await LCImageWidth( img_dst_ )
        let new_hgt = await LCImageHeight( img_dst_ )  
        
        let mat_src = await matrix_getter( img_src_ )!
        let mat_dst = await matrix_getter( img_dst_ )!
        
        let sc_x = Double(wid) / Double(new_wid)
        let sc_y = Double(hgt) / Double(new_hgt)
        
        mat_src.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { psrc in
            mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TColor>.self, capacity: 1) { pdst in
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
