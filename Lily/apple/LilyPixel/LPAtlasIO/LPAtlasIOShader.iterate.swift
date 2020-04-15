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

open class LPAtlasIOIterateShader : LPShader
{       
    public private(set) var iterator_func_name:String
 
    public convenience init() {
        let uid = UUID().labelString
        self.init( computeFuncName: "LPTexKernel_" + uid )
    }
    
    public override init( computeFuncName: String ) {
        iterator_func_name = computeFuncName + "_iterate"
        super.init( computeFuncName: computeFuncName )
        
        // 自由に使いたいパラメータ
        self.addStruct {
            $0
            .name( "LPFlexibleFloat16" )
            .add( "float", "a" )
            .add( "float", "b" )
            .add( "float", "c" )
            .add( "float", "d" )
            .add( "float", "e" )
            .add( "float", "f" )
            .add( "float", "g" )
            .add( "float", "h" )
            .add( "float", "i" )
            .add( "float", "j" )
            .add( "float", "k" )
            .add( "float", "l" )
            .add( "float", "m" )
            .add( "float", "n" )
            .add( "float", "o" )
            .add( "float", "p" )
        }
        
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
            .name( "LPAtlasGetPixel" )
            .addArgument( "texture2d<float, access::sample>", "tex" )
            .addArgument( "uint", "u" )
            .addArgument( "uint", "v" )
            .addArgument( "uint4", "region" )
            .addArgument( "float2", "frame" )
            .code( """
                // サンプラ
                constexpr sampler smpl( coord::normalized, address::clamp_to_edge, filter::nearest );
                
                // はみ出し防止(clamp_to_edgeにならうようにする)
                uint uu = max( region[0], min( u, region[2] ) );
                uint vv = max( region[1], min( v, region[3] ) );

                // テクスチャサンプル系座標
                float2 coordf = ( float2( uu, vv ) + float2(0.5) ) / frame;
                // 対象座標の色を取得
                return tex.sample( smpl, coordf );
            """ )
        }
        
        self.addFunction {
            $0
            .returnType( "float4" )
            .name( self.iterator_func_name )
            .addArgument( "LPFlexibleFloat16", "flex" )
            .addArgument( "texture2d<float, access::sample>", "in_tex" )
            .addArgument( "uint2", "in_coord" )
            .addArgument( "uint4", "in_region" )
            .addArgument( "float2", "in_frame" )
            .code( """
                // 整数uv座標系
                uint u = in_coord.x;
                uint v = in_coord.y;
                // 画像の大きさ
                uint width = uint( in_frame.x );
                uint height = uint( in_frame.y );
                
                // ターゲット座標の色は自動で取得
                float4 color = LPAtlasGetPixel( in_tex, u, v, in_region, in_frame );
                
                // 入力されるコード
                \(code)
            """ )
        }
        
        return self
    }

    public override var defaultComputeFunction:LLMetalShadingCode.Function {
        super.defaultComputeFunction
        .addArgument( "constant LPFlexibleFloat16", "&flex [[ buffer(0) ]]" )
        .addArgument( "constant int2", "&in_atlas_size [[ buffer(1) ]]" )
        .addArgument( "constant int2", "&out_atlas_size [[ buffer(2) ]]" )
        .addArgument( "constant int2", "&in_parts_size [[ buffer(3) ]]" )
        .addArgument( "constant int2", "&out_parts_size [[ buffer(4) ]]" )
        .addArgument( "constant int4", "&in_parts_region [[ buffer(5) ]]" )
        .addArgument( "constant int4", "&out_parts_region [[ buffer(6) ]]" )
        .addArgument( "texture2d<float, access::sample>", "in_tex [[ texture(0) ]]" )
        .addArgument( "texture2d<float, access::write>", "out_tex [[ texture(1) ]]" )
        .addArgument( "uint2", "group_pos_in_grid [[ threadgroup_position_in_grid ]]" )
        .addArgument( "uint2", "thread_pos_in_group [[ thread_position_in_threadgroup ]]" )
        .addArgument( "uint2", "group_size [[ threads_per_threadgroup ]]" )
        .code( """
            // 入力ピクセル左上位置
            uint2 in_o_uv = uint2( in_parts_region.x, in_parts_region.y ); 
            
            // 出力ピクセル左上位置
            uint2 out_o_uv = uint2( out_parts_region.x, out_parts_region.y ); 
            
            // 対象ピクセル座標
            uint2 coord = ( group_pos_in_grid * group_size ) + thread_pos_in_group;
            
            uint2 in_coord = coord + in_o_uv;
            uint2 out_coord = coord + out_o_uv;
            
            float2 in_atlas_frame = float2( in_atlas_size );
            float2 out_atlas_frame = float2( out_atlas_size );
            
            // イテレータ呼び出し
            float4 result = \(iterator_func_name)( flex, in_tex, in_coord, uint4( in_parts_region ), in_atlas_frame );
            
            // 対象座標の結果をテクスチャへ反映
            out_tex.write( result, out_coord );
        """ )
    }
}
