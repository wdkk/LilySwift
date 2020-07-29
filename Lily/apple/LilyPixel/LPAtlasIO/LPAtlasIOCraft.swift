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

public final class LPAtlasIOCraft : LPCraft, LPCraftCustomizable
{    
    public typealias Me = LPAtlasIOCraft

    public var atlasio:LPAtlasIO?
    
    public static func custom() -> Me {
        return Me()
    }
    
    private override init() {
        super.init()
        
        // デフォルトのフィールドを用意
        self.fireField( with:self ) { obj in 
            // テクスチャがない場合スキップ
            guard let in_atlas = obj.me.atlasio?.inAtlas,
                  let in_parts = obj.me.atlasio?.inParts,
                  let out_atlas = obj.me.atlasio?.outAtlas,
                  let out_parts = obj.me.atlasio?.outParts,
                  var flex = obj.me.atlasio?.flex
            else {
                return
            }
                        
            var in_atlas_size = LLSizev2( in_atlas.width, in_atlas.height )
            var out_atlas_size = LLSizev2( out_atlas.width, out_atlas.height )

            var in_parts_size = LLSizev2(
                ((in_parts.region!.right - in_parts.region!.left) * in_atlas.width.d).i32!,
                ((in_parts.region!.bottom - in_parts.region!.top) * in_atlas.height.d).i32! 
            )

            var out_parts_size = LLSizev2(
                ((out_parts.region!.right - out_parts.region!.left) * out_atlas.width.d).i32!,
                ((out_parts.region!.bottom - out_parts.region!.top) * out_atlas.height.d).i32!
            )
            
            var in_parts_reg = LLIntv4(
                (in_parts.region!.left * in_atlas.width.d).i32!,
                (in_parts.region!.top * in_atlas.width.d).i32!,
                (in_parts.region!.right * in_atlas.height.d).i32!,
                (in_parts.region!.bottom * in_atlas.height.d).i32!
            )

            var out_parts_reg = LLIntv4(
                (out_parts.region!.left * out_atlas.width.d).i32!, 
                (out_parts.region!.top * out_atlas.width.d).i32!,
                (out_parts.region!.right * out_atlas.height.d).i32!,
                (out_parts.region!.bottom * out_atlas.height.d).i32! 
            )
            
            let encoder = obj.args
        
            encoder.setBytes( &flex, length: 64, index: 0 )
            encoder.setBytes( &in_atlas_size, length: 8, index: 1 )
            encoder.setBytes( &out_atlas_size, length: 8, index: 2 )
            encoder.setBytes( &in_parts_size, length: 8, index: 3 )
            encoder.setBytes( &out_parts_size, length: 8, index: 4 )
            encoder.setBytes( &in_parts_reg, length: 16, index: 5 )
            encoder.setBytes( &out_parts_reg, length: 16, index: 6 )
            encoder.setTexture( in_parts.metalTexture, index: 0 )
            encoder.setTexture( out_parts.metalTexture, index: 1 )
            encoder.dispatch2d( dataSize: out_parts_size )
        }
    }
    
    @discardableResult
    public func atlasIO( _ atlio:LPAtlasIO? ) -> Self {
        self.atlasio = atlio
        return self
    }
    
    @discardableResult
    private func fireField<TCaller>( with caller:TCaller,  
        _ f:@escaping (LLPhysicalField<TCaller, Me, MTLComputeCommandEncoder>.Object)->Void )
    -> Self
    {
        self._fire_f = LLPhysicalField( by:caller,
                                    target:self,
                                    argType:MTLComputeCommandEncoder.self, 
                                    field:f )
        return self
    }
}
