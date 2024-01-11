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

/// 画像データ形式
/// - LCImage(LLImage)の画像データ形式を示す列挙子
public enum LLImageType : Int
{
    case none = 0    /// 不明な型
    case grey8 = 1   /// グレースケール 1チャンネル x unsigned int 8bit
    case grey16 = 2  /// グレースケール 1チャンネル x unsigned short 16bit
    case greyf = 3   /// グレースケール 1チャンネル x float 32bit
    case rgba8 = 4   /// RGBA 4チャンネル x unsigned int 8bit
    case rgba16 = 5  /// RGBA 4チャンネル x unsigned short 16bit
    case rgbaf = 6   /// RGBA 4チャンネル x float 32bit
    case hsvi = 7    /// HSV 3チャンネル (H:unsigned short, S:unsigned char, V:unsigned char)
    case hsvf = 8    /// HSV 3チャンネル x float 32bit
}

/// 画像読み込み形式
/// - 読み込みを行う画像形式の指定に用いる
public enum LLImageLoadType : Int
{
    case auto = 0       /// 自動. 拡張子で判断がなされる
    case png = 1        /// PNG形式
    case jpeg = 2       /// JPEG形式
    case bitmap = 3     /// Bitmap形式
    case tiff = 4       /// Tiff形式
    case gif = 5        /// GIF形式
    case targa = 6      /// Targa(tga)形式
}

/// 画像保存形式
/// - 保存をを行う際の画像形式の指定に用いる
public enum LLImageSaveType : Int
{
    case auto = 0       /// 自動. 主にpng形式で保存される
    case png = 1        /// PNG形式
    case jpeg = 2       /// JPEG形式
#if !os(iOS)
    case bitmap = 3     /// Bitmap形式
    case tiff = 4       /// GIF形式
    case targa = 5      /// Targa(tga)形式
#endif
}
    
/// Tiff形式の情報
/// - Tiff形式に保存を行う時などに用いる設定
public enum LLImageTiffInfo : Int
{
    case none = 0   /// 無圧縮
    case lzw = 1    /// ランレングス圧縮
}

/// Bitmap形式の情報
/// - Bitmap形式に保存を行う時などに用いる設定
public enum LLImageBitmapInfo : Int
{
    case bit24 = 0   /// 24bit形式    
    case bit32 = 1   /// 32bit形式
}

/// Targa形式の情報
/// - Targa形式に保存を行う時などに用いる設定
public enum LLImageTargaInfo : Int
{
    case bit24 = 0    /// 24bit形式
    case bit32 = 1    /// 32bit形式
}

/// 色深度
/// - 色深度を表す値
public enum LLColorDepth : Int
{
    case uint8 = 0    /// 符号無し整数8bit
    case uint16 = 1   /// 符号無し整数16bit
}

/// 画像読み込み時のオプション
/// - 画像読み込み時に指定するオプション群
public struct LLImageLoadOption
{
    public var type:LLImageLoadType    /// 読み込み形式
    // TODO: 16bitImageへのメモリマップも視野に
    public var depth:LLColorDepth   
}
    
/// 画像保存時のオプション
/// - 画像保存時に指定するオプション群
public struct LLImageSaveOption
{
    public var type:LLImageSaveType = .auto           /// 書き出しする画像形式
    public var jpeg_quality:LLFloat = 0.85            /// JPEG保存時の品質( 低品質:0.0 ~ 最高品質:1.0, 標準:0.85 )
    public var png_compress:LLFloat = 2.0             /// PNG保存時の圧縮率( 標準2.0 )
    // TODO: 16bitPNGの対応
    public var png_depth:LLColorDepth = .uint8        /// PNG保存時の色深度
    public var bitmap_info:LLImageBitmapInfo = .bit24 /// Bitmap保存時の情報
    public var targa_info:LLImageTargaInfo = .bit32   /// Targa保存時の情報
    public var tiff_info:LLImageTiffInfo = .lzw       /// Tiff保存時の情報
}

/// タブレット状態情報構造体
/// - タブレットが得ている状態値を扱う構造体
public struct LLTabletState
{
    public var x:LLFloat = 0.0   /// x座標
    public var y:LLFloat = 0.0   /// y座標
    public var z:LLFloat = 0.0   /// z座標
    public var twist:LLFloat = 0.0  /// 回転( 0.0 ~ 1.0 )
    public var altitude:LLFloat = 0.0  /// 傾き( 0.0 ~ 1.0 )
    public var azimuth:LLFloat = 0.0   /// 角度( 0.0 ~ 1.0 )
    public var pressure:LLFloat = 0.0  /// 筆圧( 0.0 ~ 1.0 )
}

/// 8bit色情報構造体
/// - 1チャンネルあたり8bitのRGBA色情報をもつ構造体
public struct LLColor8
{
    public typealias Unit = LLUInt8
    public var R:Unit = 0 /// R値 (min:0 ~ max:255)
    public var G:Unit = 0 /// G値 (min:0 ~ max:255)
    public var B:Unit = 0 /// B値 (min:0 ~ max:255)
    public var A:Unit = 0 /// A値 (min:0 ~ max:255)
    
    public init( R:Unit, G:Unit, B:Unit, A:Unit ) {
        self.R = R
        self.G = G
        self.B = B
        self.A = A
    }
}
/// NULL無しLLColor8ポインタ型
public typealias LLColor8Ptr = UnsafeMutablePointer<LLColor8>
/// NULL無しLLColor8 2次元マトリクス型
public typealias LLColor8Matrix = UnsafeMutablePointer<LLColor8Ptr>

/// 16bit色情報構造体
/// - 1チャンネルあたり16bitのRGBA色情報をもつ構造体
public struct LLColor16
{
    public typealias Unit = LLUInt16
    public var R:Unit = 0 /// R値 (min:0 ~ max:65535)
    public var G:Unit = 0 /// G値 (min:0 ~ max:65535)
    public var B:Unit = 0 /// B値 (min:0 ~ max:65535)
    public var A:Unit = 0 /// A値 (min:0 ~ max:65535)
    
    public init( R:Unit, G:Unit, B:Unit, A:Unit ) {
        self.R = R
        self.G = G
        self.B = B
        self.A = A
    }
}
/// NULL無しLLColor16ポインタ型
public typealias LLColor16Ptr = UnsafeMutablePointer<LLColor16>
/// NULL無しLLColor16 2次元マトリクス型
public typealias LLColor16Matrix = UnsafeMutablePointer<LLColor16Ptr>

/// 32bit色情報構造体
/// - 1チャンネルあたり32bitのRGBA色情報をもつ構造体
public struct LLColor32
{
    public typealias Unit = LLInt32
    public var R:Unit = 0 /// R値 ( min:-2147483648 ~ max:2147483647 )
    public var G:Unit = 0 /// G値 ( min:-2147483648 ~ max:2147483647 )
    public var B:Unit = 0 /// B値 ( min:-2147483648 ~ max:2147483647 )
    public var A:Unit = 0 /// A値 ( min:-2147483648 ~ max:2147483647 )
    
    public init( R:Unit, G:Unit, B:Unit, A:Unit ) {
        self.R = R
        self.G = G
        self.B = B
        self.A = A
    }
}
/// NULL無しLLColor32ポインタ型
public typealias LLColor32Ptr = UnsafeMutablePointer<LLColor32>
/// NULL無しLLColor32 2次元マトリクス型
public typealias LLColor32Matrix = UnsafeMutablePointer<LLColor32Ptr>

/// 64bit色情報構造体
/// - 1チャンネルあたり64bitのRGBA色情報をもつ構造体
public struct LLColor64
{
    public typealias Unit = LLInt64
    public var R:LLInt64 = 0  /// R値 ( min:-9223372036854775808 ~ max:9223372036854775807 )
    public var G:LLInt64 = 0  /// G値 ( min:-9223372036854775808 ~ max:9223372036854775807 )
    public var B:LLInt64 = 0  /// B値 ( min:-9223372036854775808 ~ max:9223372036854775807 )
    public var A:LLInt64 = 0  /// A値 ( min:-9223372036854775808 ~ max:9223372036854775807 )

    public init( R:Unit, G:Unit, B:Unit, A:Unit ) {
        self.R = R
        self.G = G
        self.B = B
        self.A = A
    }
}
/// NULL無しLLColor64ポインタ型
public typealias LLColor64Ptr = UnsafeMutablePointer<LLColor64>
/// NULL無しLLColor64 2次元マトリクス型
public typealias LLColor64Matrix = UnsafeMutablePointer<LLColor64Ptr>

/// Float型色情報構造体
/// - 1チャンネルあたり32bitFloatのRGBA色情報をもつ構造体
public struct LLColor
{
    public typealias Unit = LLFloat
    public var R:Unit = 0.0  /// R値 ( min:0.0 ~ max:1,0 )
    public var G:Unit = 0.0  /// G値 ( min:0.0 ~ max:1,0 )
    public var B:Unit = 0.0  /// B値 ( min:0.0 ~ max:1,0 )
    public var A:Unit = 0.0  /// A値 ( min:0.0 ~ max:1,0 )

    public init( R:Unit, G:Unit, B:Unit, A:Unit ) {
        self.R = R
        self.G = G
        self.B = B
        self.A = A
    }
}
/// NULL無しLLColorポインタ型
public typealias LLColorPtr = UnsafeMutablePointer<LLColor>
/// NULL無しLLColor 2次元マトリクス型
public typealias LLColorMatrix = UnsafeMutablePointer<LLColorPtr>

/// Double型色情報構造体
/// - 1チャンネルあたり32bitFloatのRGBA色情報をもつ構造体
public struct LLColorD
{
    public typealias Unit = LLDouble
    public var R:Unit = 0.0  /// R値 ( min:0.0 ~ max:1,0 )
    public var G:Unit = 0.0  /// G値 ( min:0.0 ~ max:1,0 )
    public var B:Unit = 0.0  /// B値 ( min:0.0 ~ max:1,0 )
    public var A:Unit = 0.0  /// A値 ( min:0.0 ~ max:1,0 )

    public init( R:Unit, G:Unit, B:Unit, A:Unit ) {
        self.R = R
        self.G = G
        self.B = B
        self.A = A
    }
}
/// NULL無しLLColorDポインタ型
public typealias LLColorDPtr = UnsafeMutablePointer<LLColorD>
/// NULL無しLLColorD 2次元マトリクス型
public typealias LLColorDMatrix = UnsafeMutablePointer<LLColorDPtr>

/// BGRA8bit色情報構造体
/// - 1チャンネルあたり8bitのBGRA色情報をもつ構造体
public struct LLBGRA8
{
    public typealias Unit = LLUInt8
    public var B:Unit  /// B値 (min:0 ~ max:255)
    public var G:Unit  /// G値 (min:0 ~ max:255)
    public var R:Unit  /// R値 (min:0 ~ max:255)
    public var A:Unit  /// A値 (min:0 ~ max:255)

    public init( B:Unit, G:Unit, R:Unit, A:Unit ) {
        self.R = R
        self.G = G
        self.B = B
        self.A = A
    }
}
/// NULL無しLLBGRA8ポインタ型
public typealias LLBGRA8Ptr = UnsafeMutablePointer<LLBGRA8>
/// NULL無しLLBGRA8 2次元マトリクス型
public typealias LLBGRA8Matrix = UnsafeMutablePointer<LLBGRA8Ptr>

/// BGRA16bit色情報構造体
/// - 1チャンネルあたり16bitのBGRA色情報をもつ構造体
public struct LLBGRA16
{
    public typealias Unit = LLUInt16
    public var B:Unit = 0 /// B値 (min:0 ~ max:65535)
    public var G:Unit = 0 /// G値 (min:0 ~ max:65535)
    public var R:Unit = 0 /// R値 (min:0 ~ max:65535)
    public var A:Unit = 0 /// A値 (min:0 ~ max:65535)

    public init( B:Unit, G:Unit, R:Unit, A:Unit ) {
        self.R = R
        self.G = G
        self.B = B
        self.A = A
    }
}
/// NULL無しLLBGRA16 ポインタ型
public typealias LLBGRA16Ptr = UnsafeMutablePointer<LLBGRA16>
/// NULL無しLLBGRA16 2次元マトリクス型
public typealias LLBGRA16Matrix = UnsafeMutablePointer<LLBGRA16Ptr>

/// BGRA float型色情報構造体
/// - 1チャンネルあたり32bitFloatのBGRA色情報をもつ構造体
public struct LLBGRAf
{
    public typealias Unit = LLFloat
    public var B:Unit = 0.0 /// B値 (min:0.0 ~ max:1.0)
    public var G:Unit = 0.0 /// G値 (min:0.0 ~ max:1.0)
    public var R:Unit = 0.0 /// R値 (min:0.0 ~ max:1.0)
    public var A:Unit = 0.0 /// A値 (min:0.0 ~ max:1.0)

    public init( B:Unit, G:Unit, R:Unit, A:Unit ) {
        self.R = R
        self.G = G
        self.B = B
        self.A = A
    }
}
/// NULL無しLLBGRAfポインタ型
public typealias LLBGRAfPtr = UnsafeMutablePointer<LLBGRAf>
/// NULL無しLLBGRAf 2次元マトリクス型
public typealias LLBGRAfMatrix = UnsafeMutablePointer<LLBGRAfPtr>


/// 整数型で構成されるHSV色情報構造体
/// - HがUInt16, SとVがUInt8で構成されるHSVの値を扱う構造体
public struct LLHSVi
{
    public typealias HUnit  = LLUInt16
    public typealias SVUnit = LLUInt8
    public var H:HUnit = 0 /// 色相値( 0 ~ 360 )
    public var S:SVUnit = 0  /// 彩度値( 0 ~ 255 )
    public var V:SVUnit = 0  /// 明度値( 0 ~ 255 )

    public init( H:HUnit, S:SVUnit, V:SVUnit ) {
        self.H = H
        self.S = S
        self.V = V
    }
}

/// NULL無しLLHSViポインタ型
public typealias LLHSViPtr = UnsafeMutablePointer<LLHSVi>
/// NULL無しLLHSVi 2次元マトリクス型
public typealias LLHSViMatrix = UnsafeMutablePointer<LLHSViPtr>


/// @struct LLHSVf
/// 小数で構成されるHSV色情報構造体
/// - Float型3チャンネルで値を扱うHSV値構造体
public struct LLHSVf
{
    public typealias HUnit  = LLFloat
    public typealias SVUnit = LLFloat
    public var H:HUnit = 0.0  /// 色相値( 0.0 ~ 360.0 )
    public var S:SVUnit = 0.0  /// 彩度値( 0.0 ~ 1.0 )
    public var V:SVUnit = 0.0  /// 明度値( 0.0 ~ 1.0 )

    public init( H:HUnit, S:SVUnit, V:SVUnit ) {
        self.H = H
        self.S = S
        self.V = V
    }
}
/// NULL無しLLHSVポインタ型
public typealias LLHSVfPtr = UnsafeMutablePointer<LLHSVf>
/// NULL無しLLHSV 2次元マトリクス型
public typealias LLHSVfMatrix = UnsafeMutablePointer<LLHSVfPtr>
