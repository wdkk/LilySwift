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

import Metal

public extension MTLRenderCommandEncoder
{
    func setVertexBuffer( _ buffer:MTLBuffer, index idx:Int ) {
        self.setVertexBuffer( buffer, offset: 0, index: idx )
    }
    
    func setVertexBuffer<T:MetalBufferAllocatable>( _ obj:T, offset:Int=0, index idx:Int ) {
        self.setVertexBuffer( obj.metalBuffer, offset: offset, index: idx )
    }

    // MARK: - fragment buffer functions
    func setFragmentBuffer( _ buffer:MTLBuffer, index idx:Int ) {
        self.setFragmentBuffer( buffer, offset: 0, index: idx )
    }
    
    func setFragmentBuffer<T:MetalBufferAllocatable>( _ obj:T, offset:Int=0, index idx:Int ) {
        self.setFragmentBuffer( obj.metalBuffer, offset: offset, index: idx )
    }
    
    // MARK: - メモリレスの処理わけ
    func setVertexMemoryLessTexture( _ tex:MTLTexture?, index idx:Int ) {
        #if targetEnvironment(simulator)
        self.setVertexTexture( tex, index: idx )
        #endif
    }
    
    func setFragmentMemoryLessTexture( _ tex:MTLTexture?, index idx:Int ) {
        #if targetEnvironment(simulator)
        self.setFragmentTexture( tex, index: idx )
        #endif
    }
}

public extension MTLRenderCommandEncoder
{
    @discardableResult
    func label( _ label:String ) -> Self {
        self.label = label
        return self
    }
    
    @discardableResult
    func cullMode( _ mode:MTLCullMode ) -> Self {
        self.setCullMode( mode )
        return self
    }

    @discardableResult
    func depthClipMode( _ mode:MTLDepthClipMode ) -> Self {
        #if !targetEnvironment(simulator)
        self.setDepthClipMode( mode )
        #endif
        return self
    }
    
    @discardableResult
    func depthStencilState( _ state:MTLDepthStencilState? ) -> Self {
        self.setDepthStencilState( state )
        return self
    }
    
    @discardableResult
    func frontFacing( _ face:MTLWinding ) -> Self {
        self.setFrontFacing( face )
        return self
    }
    
    @discardableResult
    func viewport( _ vp:MTLViewport ) -> Self {
        self.setViewport( vp )
        return self
    }
    
    @discardableResult
    func viewport( x:Double, y:Double, width:Double, height:Double, near:Double, far:Double ) -> Self {
        self.setViewport( MTLViewport( originX: x, originY: y, width: width, height: height, znear: near, zfar: far ) )
        return self
    }
    
    @discardableResult
    func viewports( _ vps:[MTLViewport] ) -> Self {
        self.setViewports( vps )
        return self
    }
    
    @discardableResult
    func scissor( _ rect:MTLScissorRect ) -> Self {
        self.setScissorRect( rect )
        return self
    }
    
    @discardableResult
    func scissor( x:Int, y:Int, width:Int, height:Int ) -> Self {
        self.setScissorRect( MTLScissorRect( x:x, y:y, width:width, height:height ) )
        return self
    }
    
    @discardableResult
    func vertexAmplification( count:Int, viewports:[MTLViewport] ) -> Self {
        #if os(visionOS)
        if count > 1 {
            var viewMappings = (0..<count).map {
                MTLVertexAmplificationViewMapping(
                    viewportArrayIndexOffset: UInt32($0),
                    renderTargetArrayIndexOffset: UInt32($0)
                )
            }
            self.setVertexAmplificationCount( viewports.count, viewMappings:&viewMappings )
        }
        #endif
        return self
    }
}
