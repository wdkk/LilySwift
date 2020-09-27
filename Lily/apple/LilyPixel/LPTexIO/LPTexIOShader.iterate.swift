//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY_FULL

import Foundation
import Metal

open class LPTexIOIterateShader : LPShader
{       
    public private(set) var iterator_func_name:String
 
    public convenience init() {
        let uid = UUID().labelString
        self.init( computeFuncName: "LPTexKernel_" + uid )
    }
    
    public override init( computeFuncName: String ) {
        iterator_func_name = computeFuncName + "_iterate"
        super.init( computeFuncName: computeFuncName )
        
        // 初期のイテレーションコード
        self.iteratorCode( """
            return float4( 0, 0, 0, 1 );
        """ )
        
        // コンピュートシェーダ関数のコード
        self.computeFunction { $0 }
    }
    
    @discardableResult
    public func iteratorCode( _ code:String ) -> Self {
        // 一度ファンクションコードをクリアする
        self.func_codes.removeAll()
        
        self.addFunction {
            $0
            .returnType( "float4" )
            .name( "LPTexGetPixel" )
            .addArgument( "texture2d<float, access::sample>", "tex" )
            .addArgument( "uint", "u" )
            .addArgument( "uint", "v" )
            .addArgument( "float2", "frame" )
            .code( """
                // サンプラ
                constexpr sampler smpl( coord::normalized, address::clamp_to_edge, filter::nearest );
                // テクスチャサンプル系座標
                float2 coordf = ( float2( u, v ) + float2(0.5) ) / frame;
                // 対象座標の色を取得
                return tex.sample( smpl, coordf );
            """ )
        }
        
        self.addFunction {
            $0
            .returnType( "float4" )
            .name( self.iterator_func_name )
            .addArgument( "texture2d<float, access::sample>", "in_tex" )
            .addArgument( "uint2", "coord" )
            .addArgument( "float2", "frame" )
            .code( """
                // 整数uv座標系
                uint u = coord.x;
                uint v = coord.y;
                // 画像の大きさ
                uint width = uint( frame.x );
                uint height = uint( frame.y );
                // ターゲット座標の色は自動で取得
                float4 color = LPTexGetPixel( in_tex, u, v, frame );
                
                // 入力されるコード
                \(code)
            """ )
        }
        
        return self
    }

    public override var defaultComputeFunction:LLMetalShadingCode.Function {
        super.defaultComputeFunction
        .addArgument( "texture2d<float, access::sample>", "in_tex [[ texture(0) ]]" )
        .addArgument( "texture2d<float, access::write>", "out_tex [[ texture(1) ]]" )
        .addArgument( "uint2", "group_pos_in_grid [[ threadgroup_position_in_grid ]]" )
        .addArgument( "uint2", "thread_pos_in_group [[ thread_position_in_threadgroup ]]" )
        .addArgument( "uint2", "group_size [[ threads_per_threadgroup ]]" )
        .code( """
            // 画像のフレームサイズ
            float2 frame = float2( in_tex.get_width(), in_tex.get_height() );
            // 対象ピクセル座標
            uint2 coord = ( group_pos_in_grid * group_size ) + thread_pos_in_group;

            // イテレータ呼び出し
            float4 result = \(iterator_func_name)( flex, in_tex, coord, frame );
            // 対象座標の結果をテクスチャへ反映
            out_tex.write( result, coord );
        """ )
    }
}

#endif
