//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
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
    
    func setVertexBuffer<T:LLMetalBufferAllocatable>( _ obj:T, offset:Int=0, index idx:Int ) {
        self.setVertexBuffer( obj.metalBuffer, offset: offset, index: idx )
    }

    // MARK: - fragment buffer functions
    func setFragmentBuffer( _ buffer:MTLBuffer, index idx:Int ) {
        self.setFragmentBuffer( buffer, offset: 0, index: idx )
    }
    
    func setFragmentBuffer<T:LLMetalBufferAllocatable>( _ obj:T, offset:Int=0, index idx:Int ) {
        self.setFragmentBuffer( obj.metalBuffer, offset: offset, index: idx )
    }
        
    func setDepthStencilDescriptor( _ desc:MTLDepthStencilDescriptor ) {
        let depth_stencil_state = LLMetalManager.shared.device?.makeDepthStencilState( descriptor: desc )
        self.setDepthStencilState( depth_stencil_state )
    }
}

public extension MTLRenderCommandEncoder
{
    func draw<T>( shape:LLMetalShape<T>, index idx:Int = 0, painter:LLMetalShapePainter<T> ) {
        painter.draw( with:self, index:idx, shape:shape )
    }
    
    // TODO: Meshにdrawを持たせたくない
    func draw( mesh:LLMetalMesh, index idx:Int = 0 ) {
        mesh.draw( with:self, index:idx )
    }
}
