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

public func LCImageProcWhiteBalanceAutomatically( _ img_src_:LCImageSmPtr, _ img_dst_:LCImageSmPtr ) {
    switch LCImageGetType( img_src_ ) {
    case .grey8:
        let module = __LCImageProcWhiteBalanceAutomatically<LLUInt8, LLUInt8>( LCImageGrey8Matrix )
        module.setup( img_src_, img_dst_, 0.05, 1, 256, LLColor8_MaxValue.d )
        module.procGrey()
        break
    case .grey16:
        let module = __LCImageProcWhiteBalanceAutomatically<LLUInt16, LLUInt16>( LCImageGrey16Matrix )
        module.setup( img_src_, img_dst_, 0.05, 1, 65536, LLColor16_MaxValue.d )
        module.procGrey()
        break
    case .greyf:
        let img_conv = LCImageClone( img_src_ )
        LCImageConvertType( img_conv, .grey16 )
        LCImageProcWhiteBalanceAutomatically( img_conv, img_dst_ )
        LCImageConvertType( img_dst_, .greyf )
        break
    case .rgba8:
        let module = __LCImageProcWhiteBalanceAutomatically<LLUInt8, LLColor8>( LCImageRGBA8Matrix )
        module.setup( img_src_, img_dst_, 0.05, 3, 256, LLColor8_MaxValue.d )
        module.procChannel3()
        break
    case .rgba16:
        let module = __LCImageProcWhiteBalanceAutomatically<LLUInt16, LLColor16>( LCImageRGBA16Matrix )
        module.setup( img_src_, img_dst_, 0.05, 3, 65536, LLColor16_MaxValue.d )
        module.procChannel3()
        break
    case .rgbaf:
        let img_conv = LCImageClone( img_src_ )
        LCImageConvertType( img_conv, .rgba16 )
        LCImageProcWhiteBalanceAutomatically( img_conv, img_dst_ )
        LCImageConvertType( img_dst_, .rgbaf )
        break
    case .hsvf:
        let img_conv = LCImageClone( img_src_ )
        LCImageConvertType( img_conv, .rgba16 )
        LCImageProcWhiteBalanceAutomatically( img_conv, img_dst_ )
        LCImageConvertType( img_dst_, .hsvf )
        break
    case .hsvi:
        let img_conv = LCImageClone( img_src_ )
        LCImageConvertType( img_conv, .rgba16 )
        LCImageProcWhiteBalanceAutomatically( img_conv, img_dst_ )
        LCImageConvertType( img_dst_, .hsvi )
        break
    default:
        LLLogForce( "unsupported this image type." )
        break
    }
}

/*
class __LCImageProcWhiteBalanceAutomatically<TType:BinaryInteger, TColor>
{
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    typealias TPointer = UnsafeMutablePointer<UnsafeMutablePointer<UnsafeMutablePointer<TType>>>
    
    struct Param {
        var img_src:LCImageSmPtr?
        var img_dst:LCImageSmPtr?
        var hists = [[Int]]()
        var vmin = [Int]()
        var vmax = [Int]()
        var max_value:Double = 0.0
    }
    
    var param = Param()
    var matrix_getter:(LCImageSmPtr)->TMatrix?
    
    init( _ mgetter:@escaping (LCImageSmPtr)->TMatrix? ) {
        matrix_getter = mgetter
    }
    
    func setup(
        _ img_src_:LCImageSmPtr, 
        _ img_dst_:LCImageSmPtr,
        _ discard_ratio_:Double,   // 棄却するもととなる比率
        _ hist_dimension_:Int,     // ヒストグラムのチャンネル数
        _ hist_sample_:Int,        // ヒストグラムの粒度
        _ max_value_:Double )     
    {
        param.img_src = img_src_
        param.img_dst = img_dst_
        param.max_value = max_value_
        
        for j in 0 ..< hist_dimension_ {
            param.hists.append( [Int]() )
            for _ in 0 ... hist_sample_ {
                param.hists[j].append( 0 )
            }
        }

        let wid = LCImageWidth( img_src_ )
        let hgt = LCImageHeight( img_src_ )
        // 出力先画像
        LCImageResizeWithType( img_dst_, wid, hgt, LCImageGetType( img_src_ ) )
        let mat_src = matrix_getter( img_src_ )
        
        // ヒストグラム作成(ここもテンプレート化できればなお良い)
        if hist_dimension_ == 1 { createHistGrey( wid, hgt, mat_src! ) }
        else { createHistChannel3( wid, hgt, mat_src! ) }
        
        let total = wid * hgt
       
        for i in 0 ..< hist_dimension_ {
            param.vmin.append( 0 )
            param.vmax.append( hist_sample_ )
            
            for j in 0 ..< hist_sample_ {
                param.hists[i][j + 1] += param.hists[i][j]
            }

            let th1 = (discard_ratio_ * total.d).i!
            let th2 = ((1.0 - discard_ratio_) * total.d).i!
            while param.hists[i][param.vmin[i]] < th1 { param.vmin[i] += 1 }
            while param.hists[i][param.vmax[i]] > th2 { param.vmax[i] -= 1 }
            
            if param.vmax[i] < hist_sample_ - 1 { param.vmax[i] += 1 }
        }
    }
    
    func createHistGrey( _ wid_:Int, _ hgt_:Int, _ mat_src_:TMatrix ) {
        // ヒストグラムの作成
        for y in 0 ..< hgt_ {
            for x in 0 ..< wid_ {
                let px = mat_src_ as! TPointer
                let idx = px[y][x][0] as! Int
                param.hists[0][idx] += 1
            }
        } 
    }
    
    func createHistChannel3( _ wid_:Int, _ hgt_:Int, _ mat_src_:TMatrix ) {
        for y in 0 ..< hgt_ {
            for x in 0 ..< wid_ {
                let px = mat_src_ as! TPointer
                let idx0 = px[y][x][0] as! Int
                let idx1 = px[y][x][1] as! Int
                let idx2 = px[y][x][2] as! Int
                param.hists[0][idx0] += 1
                param.hists[1][idx1] += 1
                param.hists[2][idx2] += 1
            }
        } 
    }

    func procGrey() {
        let vmin = param.vmin
        let vmax = param.vmax
        let wid = LCImageWidth( param.img_src! )
        let hgt = LCImageHeight( param.img_src! )
        let mat_src = matrix_getter( param.img_src! )!
        let mat_dst = matrix_getter( param.img_dst! )!
        let max_value = param.max_value

        let psrc = mat_src as! TPointer
        let pdst = mat_dst as! TPointer
        
        for y in 0 ..< hgt {
            for x in 0 ..< wid {
                let val0 = Double( psrc[y][x][0] )

                let v = LLWithin( min: vmin[0].d, val0, max: vmax[0].d )
                pdst[y][x][0] = (v - vmin[0].d) * max_value / ( vmax[0].d - vmin[0].d ) as! TType
            }
        }
    }
    
    func procChannel3() {
        let vmin = param.vmin
        let vmax = param.vmax
        let wid = LCImageWidth( param.img_src! )
        let hgt = LCImageHeight( param.img_src! )
        let mat_src = matrix_getter( param.img_src! )!
        let mat_dst = matrix_getter( param.img_dst! )!
        let max_value = param.max_value

        let psrc = mat_src as! TPointer
        let pdst = mat_dst as! TPointer
        
        for y in 0 ..< hgt {
            for x in 0 ..< wid {
                let val0 = Double( psrc[y][x][0] )
                let val1 = Double( psrc[y][x][1] ) 
                let val2 = Double( psrc[y][x][2] )
                let val3 = psrc[y][x][3]
                
                let vR = LLWithin( min: vmin[0].d, val0, max: vmax[0].d )
                let vG = LLWithin( min: vmin[1].d, val1, max: vmax[1].d )
                let vB = LLWithin( min: vmin[2].d, val2, max: vmax[2].d )
                
                pdst[y][x][0] = ( vR - vmin[0].d ) * max_value / ( vmax[0].d - vmin[0].d ) as! TType
                pdst[y][x][1] = ( vG - vmin[1].d ) * max_value / ( vmax[1].d - vmin[1].d ) as! TType
                pdst[y][x][2] = ( vB - vmin[2].d ) * max_value / ( vmax[2].d - vmin[2].d ) as! TType
                pdst[y][x][3] = val3
            }
        }
    }
}
*/

class __LCImageProcWhiteBalanceAutomatically<TType: BinaryInteger, TColor> {
    typealias TMatrix = UnsafeMutablePointer<UnsafeMutablePointer<TColor>>
    typealias TPointer = UnsafeMutablePointer<UnsafeMutablePointer<UnsafeMutablePointer<TType>>>
    
    struct Param {
        var img_src: LCImageSmPtr?
        var img_dst: LCImageSmPtr?
        var hists = [[Int]]()
        var vmin = [Int]()
        var vmax = [Int]()
        var max_value: Double = 0.0
    }
    
    var param = Param()
    var matrix_getter: (LCImageSmPtr) -> TMatrix?
    
    init(_ mgetter: @escaping (LCImageSmPtr) -> TMatrix?) {
        matrix_getter = mgetter
    }
    
    func setup(
        _ img_src_: LCImageSmPtr,
        _ img_dst_: LCImageSmPtr,
        _ discard_ratio_: Double,
        _ hist_dimension_: Int,
        _ hist_sample_: Int,
        _ max_value_: Double
    ) {
        param.img_src = img_src_
        param.img_dst = img_dst_
        param.max_value = max_value_
        
        for j in 0..<hist_dimension_ {
            param.hists.append([Int]())
            for _ in 0...hist_sample_ {
                param.hists[j].append(0)
            }
        }

        let wid = LCImageWidth(img_src_)
        let hgt = LCImageHeight(img_src_)
        LCImageResizeWithType(img_dst_, wid, hgt, LCImageGetType(img_src_))
        let mat_src = matrix_getter(img_src_)
        
        if hist_dimension_ == 1 {
            createHistGrey(wid, hgt, mat_src!)
        } else {
            createHistChannel3(wid, hgt, mat_src!)
        }
        
        let total = wid * hgt
        
        for i in 0..<hist_dimension_ {
            param.vmin.append(0)
            param.vmax.append(hist_sample_)
            
            for j in 0..<hist_sample_ {
                param.hists[i][j + 1] += param.hists[i][j]
            }

            let th1 = (discard_ratio_ * Double(total)).i!
            let th2 = ((1.0 - discard_ratio_) * Double(total)).i!
            while param.hists[i][param.vmin[i]] < th1 { param.vmin[i] += 1 }
            while param.hists[i][param.vmax[i]] > th2 { param.vmax[i] -= 1 }
            
            if param.vmax[i] < hist_sample_ - 1 { param.vmax[i] += 1 }
        }
    }
    
    func createHistGrey(_ wid_: Int, _ hgt_: Int, _ mat_src_: TMatrix) {
        mat_src_.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { px in
            for y in 0..<hgt_ {
                for x in 0..<wid_ {
                    let idx = Int(px[y][x])  // px[y][x] は TType として扱われる
                    param.hists[0][idx] += 1
                }
            }
        }
    }

    func createHistChannel3(_ wid_: Int, _ hgt_: Int, _ mat_src_: TMatrix) {
        mat_src_.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { px in
            for y in 0..<hgt_ {
                for x in 0..<wid_ {
                    let idx0 = Int(px[y][x * 3 + 0])  // チャンネルごとにポインタにアクセス
                    let idx1 = Int(px[y][x * 3 + 1])
                    let idx2 = Int(px[y][x * 3 + 2])
                    param.hists[0][idx0] += 1
                    param.hists[1][idx1] += 1
                    param.hists[2][idx2] += 1
                }
            }
        }
    }

    func procGrey() {
        let vmin = param.vmin
        let vmax = param.vmax
        let wid = LCImageWidth(param.img_src!)
        let hgt = LCImageHeight(param.img_src!)
        let mat_src = matrix_getter(param.img_src!)!
        let mat_dst = matrix_getter(param.img_dst!)!
        let max_value = param.max_value
        
        mat_src.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { psrc in
            mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { pdst in
                for y in 0..<hgt {
                    for x in 0..<wid {
                        let val0 = Double(psrc[y][x])  // 添字アクセスは TType の要素に対して直接行う
                        let v = LLWithin(min: Double(vmin[0]), val0, max: Double(vmax[0]))
                        pdst[y][x] = TType((v - Double(vmin[0])) * max_value / (Double(vmax[0]) - Double(vmin[0])))
                    }
                }
            }
        }
    }

    func procChannel3() {
        let vmin = param.vmin
        let vmax = param.vmax
        let wid = LCImageWidth(param.img_src!)
        let hgt = LCImageHeight(param.img_src!)
        let mat_src = matrix_getter(param.img_src!)!
        let mat_dst = matrix_getter(param.img_dst!)!
        let max_value = param.max_value
        
        mat_src.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { psrc in
            mat_dst.withMemoryRebound(to: UnsafeMutablePointer<TType>.self, capacity: 1) { pdst in
                for y in 0..<hgt {
                    for x in 0..<wid {
                        let val0 = Double(psrc[y][x * 3 + 0])  // チャンネルごとにアクセス
                        let val1 = Double(psrc[y][x * 3 + 1])
                        let val2 = Double(psrc[y][x * 3 + 2])
                        let val3 = psrc[y][x * 3 + 3]
                        
                        let vR = LLWithin(min: Double(vmin[0]), val0, max: Double(vmax[0]))
                        let vG = LLWithin(min: Double(vmin[1]), val1, max: Double(vmax[1]))
                        let vB = LLWithin(min: Double(vmin[2]), val2, max: Double(vmax[2]))
                        
                        pdst[y][x * 3 + 0] = TType((vR - Double(vmin[0])) * max_value / (Double(vmax[0]) - Double(vmin[0])))
                        pdst[y][x * 3 + 1] = TType((vG - Double(vmin[1])) * max_value / (Double(vmax[1]) - Double(vmin[1])))
                        pdst[y][x * 3 + 2] = TType((vB - Double(vmin[2])) * max_value / (Double(vmax[2]) - Double(vmin[2])))
                        pdst[y][x * 3 + 3] = val3
                    }
                }
            }
        }
    }
}
