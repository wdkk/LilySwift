//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal
import simd

extension Lily.Stage.Playground.Billboard
{
    public static var Fs_SMetal:String { """
    //#import "Lily.Stage.Playground.Billboard.h"
    \(Lily.Stage.Playground.Billboard.h_SMetal)
    
    namespace Lily
    {
        namespace Stage 
        {
            namespace Playground
            {
                float4 drawPlane( BBVOut in ) {
                    return in.color;
                }
                
                float4 drawCircle( BBVOut in ) {
                    float x = in.xy.x;
                    float y = in.xy.y;
                    float r = x * x + y * y;
                    if( r > 1.0 ) { discard_fragment(); }
                    return in.color;
                } 
                
                float4 drawBlurryCircle( BBVOut in ) {
                    float x = in.xy.x;
                    float y = in.xy.y;
                    float r = sqrt( x * x + y * y );
                    if( r > 1.0 ) { discard_fragment(); }
                    
                    float4 c = in.color;
                    c[3] *= (1.0 + cos( r * M_PI_F )) * 0.5;

                    return c;
                } 
                
                float4 drawPicture( BBVOut in, texture2d<float> tex ) {
                    constexpr sampler sampler( mip_filter::nearest, mag_filter::nearest, min_filter::nearest );
                    
                    if( is_null_texture( tex ) ) { discard_fragment(); }
                    
                    float4 tex_c = tex.sample( sampler, in.texUV );
                    float4 c = in.color;
                    tex_c[3] *= c[3];
                    return tex_c;
                } 
                
                float4 drawMask( BBVOut in, texture2d<float> tex ) {
                    constexpr sampler sampler( mip_filter::nearest, mag_filter::nearest, min_filter::nearest );
                    
                    if( is_null_texture( tex ) ) { discard_fragment(); }
                    
                    float4 tex_c = tex.sample( sampler, in.texUV );
                    float4 c = in.color;
                    c[3] *= tex_c[0];
                    return c;
                } 
            }
        }
    }

    fragment BBResult Lily_Stage_Playground_Billboard_Fs(
        const BBVOut in [[ stage_in ]],
        texture2d<float> tex [[ texture(1) ]]
    )
    {
        ShapeType type = ShapeType( in.shapeType );
        float4 color = float4( 0 );
        switch( type ) {
            case rectangle:
                color = Lily::Stage::Playground::drawPlane( in );
                break;
            case triangle:
                color = Lily::Stage::Playground::drawPlane( in );
                break;
            case circle:
                color = Lily::Stage::Playground::drawCircle( in );
                break;
            case blurryCircle:
                color = Lily::Stage::Playground::drawBlurryCircle( in );
                break;
            case picture:
                color = Lily::Stage::Playground::drawPicture( in, tex );
                break;
            case mask:
                color = Lily::Stage::Playground::drawMask( in, tex );
                break;
            default:
                discard_fragment();
        }
        
        BBResult result;
        result.billboardTexture = color;
        result.backBuffer = color;
        return result;
    }
    
    """
    }
}
