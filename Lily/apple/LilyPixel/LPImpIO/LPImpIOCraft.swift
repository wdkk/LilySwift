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
        self.fireField( with:self ) { caller, me, args in 
            guard let in_img:LLImage = me.impio?.inImage,
                  let out_img:LLImage = me.impio?.outImage,
                  let in_memory:LLBytePtr = in_img.memory,
                  let out_memory:LLBytePtr = out_img.memory
            else {
                return
            }
           
            let encoder:MTLComputeCommandEncoder = args
            
            var size:LLSizev2 = LLSizev2( in_img.width.i32!, in_img.height.i32! )
            
            encoder.setBytes( &size, length: MemoryLayout<LLSizev2>.stride, index: 1 )
            encoder.setBuffer( LLMetalStandardBuffer( in_memory, length: in_img.memoryLength ), index: 2 )
            encoder.setBuffer( LLMetalStandardBuffer( out_memory, length: out_img.memoryLength ), index: 3 )
            encoder.dispatch2d( dataSize: size )
        }
    }
    
    @discardableResult
    public func impIO( _ imio:LPImpIO? ) -> Self {
        self.impio = imio
        return self
    }
    
    @discardableResult
    public func fireField<TCaller:AnyObject>( with caller:TCaller, 
        _ f:@escaping (TCaller, Me, MTLComputeCommandEncoder)->Void )
    -> Self
    {
        self._fire_f = LLTalkingField( by:caller,
                                    me:self,
                                    objType:MTLComputeCommandEncoder.self, 
                                    action:f )
        return self
    }
}
