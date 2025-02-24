//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

#if os(macOS)
import AppKit
#else
import UIKit
#endif

#if canImport(QuartzCore)
import QuartzCore
#endif

#if canImport(Metal)
import Metal
#endif

open class LLImage
{
    var _imgc:LCImageSmPtr
    
    public init( wid:Int, hgt:Int, type:LLImageType = .rgbaf ) async { 
        _imgc = await LCImageMake( wid, hgt, type )
    }
    
    @MainActor
    public init( _ path:LLString ) async { 
        _imgc = await LCImageMakeWithFile( path.lcStr )
    }
    
    public init( assetName:LLString ) async {
        _imgc = await LCImageMake( 0, 0, .rgbaf )
        #if os(macOS)
        guard let llimg = await NSImage( named:assetName )?.llImage() else { return }
        await LCImageCopy( llimg._imgc, self._imgc ) 
        #else
        guard let llimg = await UIImage( named:assetName )?.llImage() else { return }
        await LCImageCopy( llimg._imgc, self._imgc ) 
        #endif
    }
    
    public init( _ imgptr:LCImageSmPtr ) async {
        _imgc = await LCImageClone( imgptr ) 
    }

    public init( _ cgImage:CGImage ) async {
        _imgc = await CGImage2LCImage( cgImage )
    }
        
    open func available() async -> Bool { return await LCImageGetType( _imgc ) != .none }
    
    open func lcImage() async -> LCImageSmPtr { return self._imgc }
    
    open func cgImage() async -> CGImage? { return await LCImage2CGImage( self.lcImage() )?.takeUnretainedValue() }
    
    #if os(macOS)
    open func nsImage() async -> NSImage? { return await LCImage2NSImage( self._imgc ) }
    #else
    open func uiImage() async -> UIImage? { return await LCImage2UIImage( self._imgc ) }
    #endif
     
    open func rgba8Matrix() async -> LLColor8Matrix? { return await LCImageRGBA8Matrix( self._imgc ) }

    open func rgba16Matrix() async -> LLColor16Matrix? { return await LCImageRGBA16Matrix( self._imgc ) }

    open func rgbafMatrix() async -> LLColorMatrix? { return await LCImageRGBAfMatrix( self._imgc ) }
    
    open func grey8Matrix() async -> LLUInt8Matrix? { return await LCImageGrey8Matrix( self._imgc ) }
    
    open func grey16Matrix() async -> LLUInt16Matrix? { return await LCImageGrey16Matrix( self._imgc ) }
 
    open func greyfMatrix() async -> LLFloatMatrix? { return await LCImageGreyfMatrix( self._imgc ) }

    open func hsviMatrix() async -> LLHSViMatrix? { return await LCImageHSViMatrix( self._imgc ) }

    open func hsvfMatrix() async -> LLHSVfMatrix? { return await LCImageHSVfMatrix( self._imgc ) }
    
    open func memory() async -> LLBytePtr? { return await LCImageRawMemory( self._imgc ) }
    
    open func width() async -> Int { return await LCImageWidth( self._imgc ) }

    open func height() async -> Int { return await LCImageHeight( self._imgc ) }

    open func type() async -> LLImageType { return await LCImageGetType( self._imgc ) }
    
    open func scale() async -> LLFloat { return await LCImageScale( self._imgc ) }
    
    open func rowBytes() async -> Int { return await LCImageRowBytes( self._imgc ) }
    
    open func memoryLength() async -> Int { return await LCImageMemoryLength( self._imgc ) }
        
    open func clone() async -> LLImage { return await LLImage( self._imgc ) }
  
    open func copy( to dest:LLImage ) async { await LCImageCopy( self._imgc, dest._imgc ) }
    
    open func resize( wid:Int, hgt:Int ) async { await LCImageResize( self._imgc, wid, hgt ) }

    open func resize( wid:Int, hgt:Int, type:LLImageType ) async { await LCImageResizeWithType( self._imgc, wid, hgt, type ) }
    
    open func convertType( to type:LLImageType ) async { await LCImageConvertType( self._imgc, type ) }
    
    @discardableResult
    open func save( to path:String ) async -> Bool {
        return await LCImageSaveFile( self._imgc, path.lcStr )
    }
    
    @discardableResult
    open func save( to path:String, option:LLImageSaveOption ) async -> Bool {
        return await LCImageSaveFileWithOption( self._imgc, path.lcStr, option )
    }
}

#if canImport(QuartzCore)
public extension LLImage
{
    /// CoreVideo用バッファ
    func pixelBuffer() async -> CVPixelBuffer? {
        let dst_row_bytes = await self.width() * 4
        guard let dst_addr = await malloc( self.height() * dst_row_bytes ) else { return nil }
                
        var result_buffer:CVPixelBuffer?
        
        guard await CVPixelBufferCreateWithBytes( 
           kCFAllocatorDefault,
           self.width(), 
           self.height(),
           kCVPixelFormatType_32BGRA,
           dst_addr,
           dst_row_bytes,
           { 
               if let buf = $1 { free( UnsafeMutableRawPointer( mutating: buf ) ) }
           },
           nil, nil,
           &result_buffer 
        ) == kCVReturnSuccess 
        else {
            free( dst_addr )
            return nil
        }
        
        var src = self
        if await self.type() != .rgba8 {
            src = await self.clone()
            await src.convertType(to: .rgba8 )
        }
        
        let src_mat = await self.rgba8Matrix()!
        
        let dst_ptr = UnsafeMutablePointer<LLUInt8>( OpaquePointer( dst_addr ) )
        
        for j in await 0 ..< self.height() {
            for i in await 0 ..< self.width() {
                let ptr = dst_ptr.advanced(by: i * 4 + j * dst_row_bytes )
                (ptr + 2).pointee = src_mat[j][i].R
                (ptr + 1).pointee = src_mat[j][i].G
                (ptr).pointee = src_mat[j][i].B
                (ptr + 3).pointee = src_mat[j][i].A
            }
        }
        
        return result_buffer
    }
}
#endif

#if canImport(Metal)
extension LLImage 
{
    public convenience init?( _ texture:MTLTexture ) async {
        // TODO: もう少しテクスチャのパターンに対応したい
        if texture.pixelFormat == .rgba16Unorm {
            await self.init( wid: texture.width, hgt: texture.height, type: .rgba16 )
        }
        else if texture.pixelFormat == .rgba32Float {
            await self.init( wid: texture.width, hgt: texture.height, type: .rgbaf )
        }
        else if texture.pixelFormat == .rgba8Unorm {
            await self.init( wid: texture.width, hgt: texture.height, type: .rgba8 )
        }
        else if texture.pixelFormat == .rgba8Unorm_srgb {
            await self.init( wid: texture.width, hgt: texture.height, type: .rgba8 )
        }
        else { return nil }
        
        guard let nonnull_memory:LLBytePtr = await memory() else { return nil }
        guard let opaque_memory:OpaquePointer = OpaquePointer( nonnull_memory ) else { return nil }
        
        await texture.getBytes(
            UnsafeMutableRawPointer( opaque_memory ),
            bytesPerRow: rowBytes(),
            from: MTLRegionMake2D(0, 0, texture.width, texture.height),
            mipmapLevel: 0
        )
    }
    
    public convenience init?( _ metalBuffer:MTLBuffer, width:Int, height:Int, type:LLImageType ) async {
        // TODO: もう少しテクスチャのパターンに対応したい
        if type == .rgbaf {
            await self.init( wid:width, hgt:height, type: .rgbaf )
        }
        else { return nil }
        
        guard let nonnull_memory:LLBytePtr = await memory() else { return nil }
        
        memcpy( nonnull_memory, metalBuffer.contents(), Int( width * height * MemoryLayout<Float>.stride * 4 ) )
    }
    
    public func metalTexture( device:MTLDevice ) async -> MTLTexture? {
        guard let memory = await self.memory() else { return nil }
        
        // Metalテクスチャのフォーマットを決定
        let pixelFormat: MTLPixelFormat
        switch await self.type() {
            case .rgba8:  pixelFormat = .rgba8Unorm
            case .rgba16: pixelFormat = .rgba16Unorm
            case .rgbaf:  pixelFormat = .rgba32Float
            default:
                LLLog( "Unsupported image type." )
                return nil
        }
        
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = pixelFormat
        descriptor.width = await self.width()
        descriptor.height = await self.height()
        descriptor.usage = [.shaderRead, .shaderWrite]
        
        // テクスチャを生成
        guard let texture = device.makeTexture(descriptor: descriptor) else { return nil }
        
        // テクスチャにデータをコピー
        await texture.replace(
            region: MTLRegionMake2D(0, 0, width(), height() ),
            mipmapLevel: 0,
            withBytes: memory,
            bytesPerRow: self.rowBytes()
        )
        
        return texture
    }
    
    public func metalBuffer( device:MTLDevice ) async -> MTLBuffer? {
        guard let memory = await self.memory() else { return nil }
        
        // MTLBufferを生成
        guard let buffer = await device.makeBuffer(
            bytes: memory,
            length: self.memoryLength(),
            options: .storageModeShared
        ) 
        else {
            LLLog( "Failed to create Metal buffer." )
            return nil
        }
        
        return buffer
    }
    
    public func metalBufferNoCopy( device:MTLDevice ) async -> MTLBuffer? {
        guard let memory = await self.memory() else { return nil }
        
        // MTLBufferを生成
        guard let buffer = await device.makeBuffer(
            bytesNoCopy: memory,
            length: self.memoryLength(),
            options: .storageModeShared
        ) 
        else {
            LLLog( "Failed to create Metal buffer." )
            return nil
        }
        
        return buffer
    }
}
#endif


extension LLImage : @unchecked Sendable
{
    public func edit( 
        region:LLRegion? = nil,
        iterate:@escaping @Sendable ( LLPointInt, LLSizeInt, LLColor, (Int,Int) async -> LLColor ) -> LLColor
    ) 
    async
    -> LLImage
    {        
        let wid = await self.width()
        let hgt = await self.height()
        let sz  = LLSizeInt( wid, hgt ) 

        // 範囲指定
        let sx = LLWithin( min:0, region?.left.i ?? 0, max: wid )
        let ex = LLWithin( min:0, region?.right.i ?? wid, max: wid )
        let sy = LLWithin( min:0, region?.top.i ?? 0, max: hgt )
        let ey = LLWithin( min:0, region?.bottom.i ?? hgt, max: hgt )
        
        if ex - sx < 1 || ey - sy < 1 { return self }
        
        let xrange = sx ..< ex
        let yrange = sy ..< ey
        
        let dst_img = await self.clone()
        await dst_img.convertType( to:.rgbaf )
        let ref_img = await dst_img.clone()
        
        func refPixel( x:Int, y:Int ) async -> LLColor {
            if x < 0 || y < 0 || x >= wid || y >= hgt { return .init(0,0,0,0) }
            let ref_mat = await ref_img.rgbafMatrix()!
            return ref_mat[y][x]
        }
        
        await withTaskGroup(of: Void.self) { taskGroup in
            for y in yrange {
                taskGroup.addTask {
                    let dst_mat = await dst_img.rgbafMatrix()!
                    let dst_line = dst_mat[y]
                    
                    for x in xrange {
                        let color = dst_line[x]
                        dst_line[x] = iterate(.init(x, y), sz, color, refPixel)
                    }
                }
            }
        }
        
        // 元の型形式に変換し直す
        await dst_img.convertType( to:self.type() )
        
        return dst_img
    }
}
