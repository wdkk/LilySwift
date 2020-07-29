//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

public final class LBTriangleDecoration : LBDecoration<LBTriangleStorage>
{
    public typealias Me = LBTriangleDecoration
    
    public static func custom( label:String ) -> Me {
        if let deco = LBDecorationManager.shared.decorations[label] as? Me { return deco }
        return LBDecorationManager.shared.add( deco:Me( label:label ) )
    }

    private override init( label:String ) {
        super.init( label: label )
        
        // デフォルトのコンピュータ
        self.computeField( with:self ) { obj in
            if obj.me.storage.isNoActive { return }
            
            let encoder = obj.args
        
            let threads_per_grid = MTLSizeMake( obj.me.storage.params.count, 1, 1 )
            let threads_per_group = MTLSizeMake( 4, 1, 1 )
            encoder.setBuffer( 
                LLMetalSharedBuffer( amemory:obj.me.storage.params ),
                offset: 0,
                index: 0 )
            encoder.dispatchThreads( threads_per_grid,
                                     threadsPerThreadgroup: threads_per_group )
        }
        
        // デフォルトのレンダー
        self.renderField( with:self ) { obj in 
            if obj.me.storage.isNoActive { return }
            
            let mtlbuf_params = LLMetalSharedBuffer( amemory:obj.me.storage.params )
            
            let encoder = obj.args
            
            encoder.setVertexBuffer( mtlbuf_params, index:1 )
            encoder.draw( shape:obj.me.storage.metalVertex, 
                          index:2, 
                          painter: LLMetalTrianglePainter<LBActorVertex>() )
        }
    }
        
    @discardableResult
    public func textureAtlas( _ atlas:LBTextureAtlas? ) -> Self {
        storage.atlas = atlas
        return self
    }
    
    @discardableResult
    public func computeFieldMySelf( 
        _ f:@escaping (LLPhysicalField<Me, Me, MTLComputeCommandEncoder>.Object)->Void )
    -> Self
    {
        self._compute_f = LLPhysicalField( by:self,
                                    target:self,
                                    argType:MTLComputeCommandEncoder.self, 
                                    field:f )
        return self
    }
    
    @discardableResult
    public func computeField<TCaller>( with caller:TCaller, 
        _ f:@escaping (LLPhysicalField<TCaller, Me, MTLComputeCommandEncoder>.Object)->Void )
    -> Self
    {
        self._compute_f = LLPhysicalField( by:caller,
                                    target:self,
                                    argType:MTLComputeCommandEncoder.self, 
                                    field:f )
        return self
    }

    @discardableResult
    public func renderFieldMySelf(
        _ f:@escaping (LLPhysicalField<Me, Me, MTLRenderCommandEncoder>.Object)->Void )
    -> Self
    {
        self._render_f = LLPhysicalField( by:self,
                                target:self,
                                argType:MTLRenderCommandEncoder.self, 
                                field:f )
        return self
    }
    
    @discardableResult
    public func renderField<TCaller>( with caller:TCaller,
        _ f:@escaping (LLPhysicalField<TCaller, Me, MTLRenderCommandEncoder>.Object)->Void )
    -> Self
    {
        self._render_f = LLPhysicalField( by:caller,
                                target:self,
                                argType:MTLRenderCommandEncoder.self, 
                                field:f )
        return self
    }
}
