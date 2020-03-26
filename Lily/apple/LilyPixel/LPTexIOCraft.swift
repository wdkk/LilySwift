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

public final class LPTexIOCraft : LPCraft, LPCraftCustomizable
{    
    public typealias Me = LPTexIOCraft

    public var texio:LPTexIO?
    
    public static func custom() -> Me {
        return Me()
    }
    
    private override init() {
        super.init()
        
        // デフォルトのフィールドを用意
        self.fireField { obj in 
            // テクスチャがない場合スキップ
            guard let in_tex = obj.me.texio?.inTexture,
                  let out_tex = obj.me.texio?.outTexture,
                  var flex = obj.me.texio?.flex
            else {
                return
            }

            let encoder = obj.args
        
            encoder.setBytes( &flex, length: 64, index: 0 )
            encoder.setTexture( in_tex, index: 0 )
            encoder.setTexture( out_tex, index: 1 )
            encoder.dispatch2d( dataSize: LLSizev2( in_tex.width.i32!, in_tex.height.i32! ))
        }
    }
    
    @discardableResult
    public func texIO( _ tio:LPTexIO? ) -> Self {
        self.texio = tio
        return self
    }
    
    @discardableResult
    private func fireField( 
        _ f:@escaping (LLSoloField<Me, MTLComputeCommandEncoder>.Object)->Void )
    -> Self
    {
        self._fire_f = LLSoloField( by:self,
                                    argType:MTLComputeCommandEncoder.self, 
                                    field:f )
        return self
    }
}
