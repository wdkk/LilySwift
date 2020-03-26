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

public final class LPImpIOCraft : LPCraft, LPCraftCustomizable
{    
    public typealias Me = LPImpIOCraft
    
    public var impio:LPImpIO?
    
    public static func custom() -> Me {
        return Me()
    }
    
    private override init() {
        super.init()
        
        // デフォルトのフィールドを用意
        self.fireField { obj in 
            guard let in_img = obj.me.impio?.inImage,
                  let out_img = obj.me.impio?.outImage,
                  let in_memory = in_img.memory,
                  let out_memory = out_img.memory,
                  var flex = obj.me.impio?.flex
            else {
                return
            }
           
            let encoder = obj.args
            
            var size = LLSizev2( in_img.width.i32!, in_img.height.i32! )
            
            encoder.setBytes( &flex, length: 64, index: 0 )
            encoder.setBytes( &size, length: MemoryLayout<LLSizev2>.stride, index: 1 )
            encoder.setBuffer( LLMetalSharedBuffer( in_memory, length: in_img.memoryLength ), index: 2 )
            encoder.setBuffer( LLMetalSharedBuffer( out_memory, length: out_img.memoryLength ), index: 3 )
            encoder.dispatch2d( dataSize: size )
        }
    }
    
    @discardableResult
    public func impIO( _ imio:LPImpIO? ) -> Self {
        self.impio = imio
        return self
    }
    
    @discardableResult
    public func fireField( 
        _ f:@escaping (LLSoloField<Me, MTLComputeCommandEncoder>.Object)->Void )
    -> Self
    {
        self._fire_f = LLSoloField( by:self,
                                    argType:MTLComputeCommandEncoder.self, 
                                    field:f )
        return self
    }
}
