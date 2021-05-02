//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

public final class LBPanelPipeline : LBObjectPipeline<LBPanelStorage>
{
    public typealias Me = LBPanelPipeline
    
    public static func custom( label:String ) -> Me {
        if let objpl = LBObjectPipelineManager.shared.pipelines[label] as? Me { return objpl }
        return LBObjectPipelineManager.shared.add( objpl:Me( label:label ) )
    }

    private override init( label:String ) {
        super.init( label: label )
        
        // デフォルトのコンピュータ
        self.computeField( with:self ) { caller, me, args in
            if me.storage.isNoActive { return }

            // TODO: コンピュートシェーダがiPad Pro(2017)以前に対応が難しいため、直接コピーに戻す
            let p = me.storage.params.accessor!
            for i in 0 ..< me.storage.params.count {
                p[i].position += p[i].deltaPosition
                p[i].color += p[i].deltaColor
                p[i].scale += p[i].deltaScale
                p[i].angle += p[i].deltaAngle
                p[i].life += p[i].deltaLife
            }
            
            /*
            // TODO: コンピュートシェーダにまとめたい
            #if targetEnvironment(simulator)
            let p = me.storage.params.accessor!
            for i in 0 ..< me.storage.params.count {
                p[i].position += p[i].deltaPosition
                p[i].color += p[i].deltaColor
                p[i].scale += p[i].deltaScale
                p[i].angle += p[i].deltaAngle
                p[i].life += p[i].deltaLife
            }
            #else
            let encoder = args

            let mtlbuf = LLMetalStandardBuffer( amemory:me.storage.params )
            encoder.setBuffer( mtlbuf, index: 0 )

            let threads_per_grid = MTLSizeMake( me.storage.params.count, 1, 1 )
            let threads_per_group = MTLSizeMake( 4, 1, 1 )
            encoder.dispatchThreads( threads_per_grid, threadsPerThreadgroup: threads_per_group )
            #endif
            */
        }
        
        // デフォルトのレンダー
        self.renderField( with:self ) { caller, me, args in 
            if me.storage.isNoActive { return }
            
            let mtlbuf_params = LLMetalStandardBuffer( amemory:me.storage.params )
           
            let encoder = args
 
            encoder.setVertexBuffer( mtlbuf_params, index:1 )
            encoder.draw( shape:me.storage.metalVertex,
                          index:2, 
                          painter:LLMetalQuadranglePainter<LBActorVertex>() )
        }
    }
    
    @discardableResult
    public func textureAtlas( _ atlas:LLMetalTextureAtlas? ) -> Self {
        storage.atlas = atlas
        return self
    }

    @discardableResult
    public func computeFieldMySelf( 
        _ f:@escaping (Me, Me, MTLComputeCommandEncoder)->Void )
    -> Self
    {
        self._compute_f = LLTalkingField( by:self,
                                       me:self,
                                       objType:MTLComputeCommandEncoder.self, 
                                       action:f )
        return self
    }
    
    @discardableResult
    public func computeField<TCaller:AnyObject>( with caller:TCaller, 
        _ f:@escaping (TCaller, Me, MTLComputeCommandEncoder)->Void )
    -> Self
    {
        self._compute_f = LLTalkingField( by:caller,
                                       me:self,
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
