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

public final class LBPanelDecoration : LBDecoration<LBPanelStorage>, LBDecorationCustomizable
{
    public typealias Me = LBPanelDecoration
    
    public static func custom( label:String ) -> Me {
        if let deco = LBDecorationManager.shared.decorations[label] as? Me { return deco }
        return LBDecorationManager.shared.add( deco:Me( label:label ) )
    }

    private override init( label:String ) {
        super.init( label: label )
        
        // デフォルトのフィールドを用意
        self.drawField { obj in 
            if obj.me.storage.params.filter({ $0.state == .active }).count == 0 { return }
            
            // delta値の加算
            obj.me.updateDeltaParams( &(obj.me.storage.params),
                                      count:obj.me.storage.params.count )
            
            guard let mtlbuf_params = LLMetalManager.shared.device?.makeBuffer(
                bytes: &obj.me.storage.params,
                length: MemoryLayout<LBActorParam>.stride * obj.me.storage.params.count ) else { return }
            
            let encoder = obj.args
            
            encoder.setVertexBuffer( mtlbuf_params, index:1 )
            encoder.drawShape( obj.me.storage.metalVertex, index:2 )
        }
    }
    
    public func updateDeltaParams( _ params:UnsafeMutablePointer<LBActorParam>,
                                   count:Int ) 
    {
        // delta値の加算
        let ptr = params
        for idx in 0 ..< count {
            let p = ptr + idx
         
            p.pointee.position += p.pointee.deltaPosition
            p.pointee.scale += p.pointee.deltaScale
            p.pointee.angle += p.pointee.deltaAngle
            p.pointee.color += p.pointee.deltaColor
            p.pointee.life += p.pointee.deltaLife
        }
    }
    
    @discardableResult
    public func textureAtlas( _ atlas:LBTextureAtlas? ) -> Self {
        storage.atlas = atlas
        return self
    }
    
    @discardableResult
    public func drawField( 
        _ f:@escaping (LLSoloField<Me, MTLRenderCommandEncoder>.Object)->Void )
    -> Self
    {
        self._draw_f = LLSoloField( by:self,
                                    argType:MTLRenderCommandEncoder.self, 
                                    field:f )
        return self
    }
}
