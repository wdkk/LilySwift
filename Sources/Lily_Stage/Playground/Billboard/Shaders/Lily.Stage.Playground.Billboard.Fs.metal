//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#import "Lily.Stage.Playground.Billboard.h"

typedef float4 CustomFragmentShaderFunc( Billboard::CustomShaderParam );

namespace Lily
{
    namespace Stage 
    {
        namespace Playground
        {
            namespace Billboard
            {
                float4 drawPlane( Billboard::VOut in ) {
                    return in.color;
                }
                
                float4 drawCircle( Billboard::VOut in ) {
                    float x = in.xy.x;
                    float y = in.xy.y;
                    float r = x * x + y * y;
                    if( r > 1.0 ) { discard_fragment(); }
                    return in.color;
                } 
                
                float4 drawBlurryCircle( Billboard::VOut in ) {
                    float x = in.xy.x;
                    float y = in.xy.y;
                    float r = sqrt( x * x + y * y );
                    if( r > 1.0 ) { discard_fragment(); }
                    
                    float4 c = in.color;
                    c[3] *= (1.0 + cos( r * M_PI_F )) * 0.5;
                    
                    return c;
                } 
                
                float4 drawPicture( Billboard::VOut in, texture2d<float> tex ) {
                    constexpr sampler sampler( mip_filter::nearest, mag_filter::nearest, min_filter::nearest );
                    
                    if( is_null_texture( tex ) ) { discard_fragment(); }
                    
                    float4 tex_c = tex.sample( sampler, in.texUV );
                    float4 c = in.color;
                    tex_c[3] *= c[3];
                    return tex_c;
                } 
                
                float4 drawMask( Billboard::VOut in, texture2d<float> tex ) {
                    constexpr sampler sampler( mip_filter::nearest, mag_filter::nearest, min_filter::nearest );
                    
                    if( is_null_texture( tex ) ) { discard_fragment(); }
                    
                    float4 tex_c = tex.sample( sampler, in.texUV );
                    float4 c = in.color;
                    c[3] *= tex_c[0];
                    return c;
                } 
                
                //-apple6-earlier-comment-start
                float4 drawCustom( 
                    Billboard::VOut in, 
                    texture2d<float> tex,
                    visible_function_table<CustomFragmentShaderFunc> tableFunc
                )
                {
                    constexpr sampler nearest_sampler( mip_filter::nearest, mag_filter::nearest, min_filter::nearest ); 
                    float4 texColor = is_null_texture( tex ) ? float4( 0.0, 0.0, 0.0, 0.0 ) : tex.sample( nearest_sampler, in.texUV );
                    
                    CustomShaderParam param = {
                        in.life,
                        in.time,
                        in.xy,
                        in.uv,
                        in.color,
                        in.color2,
                        in.color3,
                        in.color4,
                        in.color.w,
                        in.color2.w,
                        in.color3.w,
                        in.color4.w,
                        in.texUV,
                        texColor,
                        texColor.w,
                        tex
                    };
                    
                    return tableFunc[in.shaderIndex]( param );
                }
                //-apple6-earlier-comment-end
            }
        }
    }
}

fragment Billboard::Result Lily_Stage_Playground_Billboard_Fs(
    const Billboard::VOut in [[ stage_in ]],
    texture2d<float> tex [[ texture(1) ]]
    //-apple6-earlier-comment-start
    ,visible_function_table<CustomFragmentShaderFunc> tableFunc
    //-apple6-earlier-comment-end
)
{
    auto type = Billboard::ShapeType( in.shapeType );
    float4 color = float4( 0 );
    switch( type ) {
        case Billboard::rectangle:
        case Billboard::triangle:
            color = Billboard::drawPlane( in );
            break;
        case Billboard::circle:
            color = Billboard::drawCircle( in );
            break;
        case Billboard::blurryCircle:
            color = Billboard::drawBlurryCircle( in );
            break;
        case Billboard::picture:
            color = Billboard::drawPicture( in, tex );
            break;
        case Billboard::mask:
            color = Billboard::drawMask( in, tex );
            break;
        case Billboard::shaderRectangle:
        case Billboard::shaderTriangle:
            //-apple6-earlier-comment-start
            color = Billboard::drawCustom( in, tex, tableFunc );
            //-apple6-earlier-comment-end
            //-apple6-earlier-active: color = Billboard::drawPlane( in );
            break;
        default:
            discard_fragment();
    }
    
    Billboard::Result result;
    result.billboardTexture = color;
    result.backBuffer = color;
    return result;
}
