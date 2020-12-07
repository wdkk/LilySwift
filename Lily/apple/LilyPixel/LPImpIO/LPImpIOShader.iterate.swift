//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY_FULL

import Foundation
import Metal

open class LPImpIOIterateShader : LPShader
{       
    public private(set) var iterator_func_name:String
 
    public convenience init() {
        let uid:String = UUID().labelString
        self.init( computeFuncName: "LPImpKernel_" + uid )
    }
    
    public override init( computeFuncName: String ) {
        iterator_func_name = computeFuncName + "_iterate"
        super.init( computeFuncName: computeFuncName )
    
        self.iteratorCode( """
            return float4( 0, 0, 0, 1 );
        """ )
        
        self.computeFunction { $0 }
    }
    
    @discardableResult
    public func iteratorCode( _ code:String ) -> Self {
        self.func_codes.removeAll()
        
        self.addFunction {
            $0
            .returnType( "float4" )
            .name( self.iterator_func_name )
            .addArgument( "device float4", "*pixels" )
            .addArgument( "uint", "u" )
            .addArgument( "uint", "v" )
            .addArgument( "uint", "width" )
            .addArgument( "uint", "height" )
            .code( code )
        }
        
        return self
    }
        
    public override var defaultComputeFunction:LLMetalShadingCode.Function {
        super.defaultComputeFunction
        .addArgument( "constant int2", "&size [[ buffer(1) ]]" )
        .addArgument( "device float4", "*in_img [[ buffer(2) ]]" )
        .addArgument( "device float4", "*out_img [[ buffer(3) ]]" )
        .addArgument( "uint2", "group_pos_in_grid [[ threadgroup_position_in_grid ]]" )
        .addArgument( "uint2", "thread_pos_in_group [[ thread_position_in_threadgroup ]]" )
        .addArgument( "uint2", "group_size [[ threads_per_threadgroup ]]" )
        .code( """
            // フレームサイズ
            uint2 usize = uint2( size );
            // 対象ピクセル座標
            uint2 coord = ( group_pos_in_grid * group_size ) + thread_pos_in_group;
            
            uint wid = usize[0];
            uint hgt = usize[1];
            
            if( wid <= coord.x || hgt <= coord.y ) { return; }

            uint idx = coord.x + coord.y * wid;
            out_img[idx] = \(iterator_func_name)( flex, in_img, coord.x, coord.y, usize[0], usize[1] );
        """ )
    }
}

#endif
