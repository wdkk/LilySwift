//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

/// 画像データの内部実装クラス
public protocol LCImageRaw
{  
    func getImageType() -> LLImageType
    
    func getRawMemory() -> LLBytePtr?
    
    func getRawMatrix() -> LLVoidMatrix?
        
    func getWidth() -> Int
    
    func getHeight() -> Int
    
    func getRowBytes() -> Int
    
    func getMemoryLength() -> Int
    
    func getScale() -> LLFloat
    
    func setScale( _ sc:LLFloat )
    
    func clone() -> LCImageRaw
    
    func clonePremultipliedAlpha() -> LCImageRaw
    
    func convert( _ type:LLImageType ) -> LCImageRaw
}

public protocol LCImageRawConvartable
{
    associatedtype ConvertFromFunc
    associatedtype ConvertToFunc
    func requestFunctionOfConvertRawColorFrom() -> ConvertFromFunc?
    func requestFunctionOfConvertRawColorTo() -> ConvertToFunc?
}

/// 画像データモジュール
public class LCImageSmPtr
{
    /// 内部オブジェクト
    var rawimg:LCImageRaw?
    
    /// 初期化
    init() {}
}

public class LCImageGenericRaw<TColor> : LCImageRaw
{
    public typealias SelfColorPtr = UnsafeMutablePointer<TColor>
    public typealias SelfColorMatrix = UnsafeMutablePointer<SelfColorPtr>
    
    public typealias ConvertFromFunc = (TColor) -> LLColor
    public typealias ConvertToFunc = (LLColor) -> TColor
    
    public func requestFunctionOfConvertRawColorFrom() -> ConvertFromFunc? { return nil }
    public func requestFunctionOfConvertRawColorTo() -> ConvertToFunc? { return nil }
    
    var type:LLImageType = .none //!< 画像データ 
    var memory:LLBytePtr?        //!< 生ピクセルメモリ
    var matrix:SelfColorMatrix? = nil //!< ピクセルメモリの2次元アクセス用ポインタ
    var width:Int = 0            //!< 画像の横幅
    var height:Int = 0           //!< 画像の高さ
    var row_bytes:Int = 0        //!< 1行のピクセルメモリバイト数
    var memory_length:Int = 0    //!< ピクセルメモリの総量バイト数
    var scale:LLFloat = 0        //!< 画像が認識されるスケール(Retina対応なのかなど)
    
    
    public func getImageType() -> LLImageType {
        return self.type
    }
    
    public func getRawMemory() -> LLBytePtr? {
        return self.memory
    }

    public func getRawMatrix() -> LLVoidMatrix? {
        let p:UnsafeRawPointer = UnsafeRawPointer( self.matrix! )
        return LLVoidMatrix( OpaquePointer( p ) )
    }
    
    public func getMatrix() -> SelfColorMatrix? {
        return self.matrix
    }
    
    public func getWidth() -> Int {
        return self.width
    }
    
    public func getHeight() -> Int {
        return self.height
    }
    
    public func getRowBytes() -> Int {
        return self.row_bytes
    }
    
    public func getMemoryLength() -> Int {
        return self.memory_length
    }
    
    public func getScale() -> LLFloat {
        return self.scale
    }
    
    public func setScale( _ sc: LLFloat ) {
        self.scale = sc
    }

    public required init( _ wid:Int, _ hgt:Int ) { }
    
    deinit { 
        self.memory?.deallocate()
        self.matrix?.deallocate()
    }
        
    public func clone() -> LCImageRaw {
        let img_dst = Self( self.width, self.height )
        img_dst.setScale( self.scale )
        memcpy( img_dst.getRawMemory(), self.getRawMemory(), self.getMemoryLength() )
        return img_dst
    }    
    
    public func clonePremultipliedAlpha() -> LCImageRaw {
        let wid:Int = self.width
        let hgt:Int = self.height
        
        let img_dst = Self( wid, hgt )
        img_dst.setScale( self.scale )
        
        let mat_src:UnsafeMutablePointer<UnsafeMutablePointer<TColor>> = self.getMatrix()!
        let mat_dst:UnsafeMutablePointer<UnsafeMutablePointer<TColor>> = img_dst.getMatrix()!
        
        let funcFrom:(TColor)->LLColor = self.requestFunctionOfConvertRawColorFrom()!
        let funcTo:(LLColor)->TColor = img_dst.requestFunctionOfConvertRawColorTo()!
        
        for y:Int in 0 ..< hgt {
            for x:Int in 0 ..< wid {
                let cf = funcFrom( mat_src[y][x] )
                let k = cf.A
                let ck = LLColor( R: cf.R * k, G: cf.G * k, B: cf.B * k, A: cf.A )
                mat_dst[y][x] = funcTo( ck )
            }
        }
        
        return img_dst
    }
    
    // TODO: 型ごとに処理を書いている部分を整えたい
    public func convert( _ type:LLImageType ) -> LCImageRaw {
        if type == self.getImageType() { return clone() }
        
        let wid:Int = self.getWidth()
        let hgt:Int = self.getHeight()
        let mat_src:SelfColorMatrix = self.getMatrix()!
        let funcFrom:ConvertFromFunc = self.requestFunctionOfConvertRawColorFrom()!
        
        switch type {
        case .rgba8:
            let img_dst:LCImageRGBA8 = LCImageRGBA8( self.width, self.height )
            img_dst.setScale( self.scale )
            let mat_dst:LLColor8Matrix = img_dst.getMatrix()!
            let funcTo:LCImageRGBA8.ConvertToFunc = img_dst.requestFunctionOfConvertRawColorTo()!
            for y:Int in 0 ..< hgt {
                for x:Int in 0 ..< wid {
                    mat_dst[y][x] = funcTo( funcFrom( mat_src[y][x] ) )
                }
            }
            return img_dst
        case .rgba16:
            let img_dst:LCImageRGBA16 = LCImageRGBA16( self.width, self.height )
            img_dst.setScale( self.scale )
            let mat_dst:LLColor16Matrix = img_dst.getMatrix()!
            let funcTo:LCImageRGBA16.ConvertToFunc = img_dst.requestFunctionOfConvertRawColorTo()!
            for y:Int in 0 ..< hgt {
                for x:Int in 0 ..< wid {
                    mat_dst[y][x] = funcTo( funcFrom( mat_src[y][x] ) )
                }
            }
            return img_dst
        case .rgbaf:
            let img_dst:LCImageRGBAf = LCImageRGBAf( self.width, self.height )
            img_dst.setScale( self.scale )
            let mat_dst:LLColorMatrix = img_dst.getMatrix()!
            let funcTo:LCImageRGBAf.ConvertToFunc = img_dst.requestFunctionOfConvertRawColorTo()!
            for y:Int in 0 ..< hgt {
                for x:Int in 0 ..< wid {
                    mat_dst[y][x] = funcTo( funcFrom( mat_src[y][x] ) )
                }
            }
            return img_dst
        case .grey8:
            let img_dst:LCImageGrey8 = LCImageGrey8( self.width, self.height )
            img_dst.setScale( self.scale )
            let mat_dst:LLUInt8Matrix = img_dst.getMatrix()!
            let funcTo:LCImageGrey8.ConvertToFunc = img_dst.requestFunctionOfConvertRawColorTo()!
            for y:Int in 0 ..< hgt {
                for x:Int in 0 ..< wid {
                    mat_dst[y][x] = funcTo( funcFrom( mat_src[y][x] ) )
                }
            }
            return img_dst
        case .grey16:
            let img_dst:LCImageGrey16 = LCImageGrey16( self.width, self.height )
            img_dst.setScale( self.scale )
            let mat_dst:LLUInt16Matrix = img_dst.getMatrix()!
            let funcTo:LCImageGrey16.ConvertToFunc = img_dst.requestFunctionOfConvertRawColorTo()!
            for y:Int in 0 ..< hgt {
                for x:Int in 0 ..< wid {
                    mat_dst[y][x] = funcTo( funcFrom( mat_src[y][x] ) )
                }
            }
            return img_dst
        case .greyf:
            let img_dst:LCImageGreyf = LCImageGreyf( self.width, self.height )
            img_dst.setScale( self.scale )
            let mat_dst:LLFloatMatrix = img_dst.getMatrix()!
            let funcTo:LCImageGreyf.ConvertToFunc = img_dst.requestFunctionOfConvertRawColorTo()!
            for y:Int in 0 ..< hgt {
                for x:Int in 0 ..< wid {
                    mat_dst[y][x] = funcTo( funcFrom( mat_src[y][x] ) )
                }
            }
            return img_dst
        default: 
            return clone()
        }
    }
    
    // アラインメント境界を求める関数
    static func requestAlignedMemoryLength( _ memsize:Int, _ alignment:Int ) -> Int {
        let modv:Int = memsize % alignment
        if modv == 0 { return memsize }
        return memsize + ( alignment - modv )
    }
    
    func treatMemory( _ wid:Int, _ hgt:Int, _ type:LLImageType ) {
        self.width = wid
        self.height = hgt
        self.type = type

        let unit_bytes:Int = LLImageTypeGetByte( self.type )
        let row_bytes:Int = wid * unit_bytes
        
        self.row_bytes = row_bytes
        self.memory_length = Self.requestAlignedMemoryLength( self.row_bytes * hgt, 4096 )
        self.memory = UnsafeMutablePointer<LLUInt8>.allocate( capacity: self.memory_length )
        self.scale = 1.0

        // 縦方向マトリクスのメモリ確保
        self.matrix = SelfColorMatrix.allocate( capacity: hgt )

        let mem:LLBytePtr = self.memory!
        let mat:UnsafeMutablePointer<UnsafeMutablePointer<TColor>> = self.matrix!        
        for y:Int in 0 ..< height {
            mat[y] = SelfColorPtr( OpaquePointer( mem + (y * self.row_bytes) ) )
        }
    }
}
