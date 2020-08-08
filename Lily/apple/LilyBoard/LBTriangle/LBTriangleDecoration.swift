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
        self.computeField( with:self ) { caller, me, args in
            if me.storage.isNoActive { return }
            
            let encoder = args
        
            let threads_per_grid = MTLSizeMake( me.storage.params.count, 1, 1 )
            let threads_per_group = MTLSizeMake( 4, 1, 1 )
            encoder.setBuffer( 
                LLMetalSharedBuffer( amemory:me.storage.params ),
                offset: 0,
                index: 0 )
            encoder.dispatchThreads( threads_per_grid,
                                     threadsPerThreadgroup: threads_per_group )
        }
        
        // デフォルトのレンダー
        self.renderField( with:self ) { caller, me, args in 
            if me.storage.isNoActive { return }
            
            let mtlbuf_params = LLMetalSharedBuffer( amemory:me.storage.params )
            
            let encoder = args
            
            encoder.setVertexBuffer( mtlbuf_params, index:1 )
            encoder.draw( shape:me.storage.metalVertex, 
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
        _ f:@escaping (Me, Me, MTLComputeCommandEncoder)->Void )
    -> Self
    {
        self._compute_f = LLTalkingField( by:self, me:self,
                                    objType:MTLComputeCommandEncoder.self, 
                                    action:f )
        return self
    }
    
    @discardableResult
    public func computeField<TCaller:AnyObject>( with caller:TCaller, 
        _ f:@escaping (TCaller, Me, MTLComputeCommandEncoder)->Void )
    -> Self
    {
        self._compute_f = LLTalkingField( by:caller, me:self,
                                    objType:MTLComputeCommandEncoder.self, 
                                    action:f )
        return self
    }

    @discardableResult
    public func renderFieldMySelf(
        _ f:@escaping (Me, Me, MTLRenderCommandEncoder)->Void )
    -> Self
    {
        self._render_f = LLTalkingField( by:self,
                                me:self,
                                objType:MTLRenderCommandEncoder.self, 
                                action:f )
        return self
    }
    
    @discardableResult
    public func renderField<TCaller:AnyObject>( with caller:TCaller,
        _ f:@escaping (TCaller, Me, MTLRenderCommandEncoder)->Void )
    -> Self
    {
        self._render_f = LLTalkingField( by:caller,
                                me:self,
                                objType:MTLRenderCommandEncoder.self, 
                                action:f )
        return self
    }
}
