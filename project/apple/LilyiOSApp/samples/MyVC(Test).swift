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
import LilySwift

class MyViewController : LBViewController
{    
    var panels = Set<LBPanel>()
    var panels_circle = Set<LBPanel>()
    var panel_solo:LBPanel?
    var particles = Set<LBParticle>()
    
    var texio = LPTexIO()
    var atlasio = LPAtlasIO()

    let atlas = LBTextureAtlas( label:"test" )
        .add( "key1", LLPath.bundle( "supportFiles/images/Lily.png" ) )
        .add( "key2", LLPath.bundle( "supportFiles/images/bit8.png" ) )
        .add( "key3", LLPath.bundle( "supportFiles/images/test1.png" ) )
        .add( "key4", LLPath.bundle( "supportFiles/images/Lily359x257.png" ) )
        .add( "key5", LLPath.bundle( "supportFiles/images/bit8alpha.png" ) )
        .commit()
        
    let tex_lily = LLMetalTexture( named: "supportFiles/images/Lily.png" )
    let tex_out = LLMetalTexture( named: "supportFiles/images/Lily.png" )

    lazy var deco_circle = LBPanelDecoration.circle()
        .layer( index:0 )
    
    lazy var deco_blur_circle = LBPanelDecoration.blurryCircle()
        .layer( index:1 )
        .blendType( .add )
    
    lazy var deco_rect = LBPanelDecoration.rectangle()
        .layer( index:2 )
        .blendType( .add )
    
    lazy var deco_atlas = LBPanelDecoration.texatlas( using: self.atlas )
        .layer( index:2 )
    
    lazy var deco_tex = LBPanelDecoration.texture()
        .layer( index:3 )
    
    lazy var atlascraft_grey = LPAtlasIOCraft.custom()
    .shader(
        LPAtlasIOIterateShader()
        .iteratorCode(
        """
            float grey = color[0] * 0.299 + color[1] * 0.587 + color[2] * 0.114;
            return float4( grey, grey, grey, color[3] );
        """ )
    )
    
    lazy var atlascraft_blur = LPAtlasIOCraft.custom()
    .shader(
        LPAtlasIOIterateShader()
        .iteratorCode(
        """
            float4 csum = 0.0;
            for( int ov = -1; ov <= 1; ov++ ) {
                for( int ou = -1; ou <= 1; ou++ ) {
                    csum += LPAtlasGetPixel( in_tex, u+ou, v+ov, in_region, in_frame );
                }
            }
            return csum / 9.0;
        """ )
    )
    
    lazy var texcraft_blur = LPTexIOCraft.custom()
    .shader(
        LPTexIOIterateShader()
        .iteratorCode(
        """
            float4 csum = 0.0;
            for( int ov = -1; ov <= 1; ov++ ) {
                for( int ou = -1; ou <= 1; ou++ ) {
                    csum += LPTexGetPixel( in_tex, u+ou, v+ov, frame ); 
                }
            }
            return csum / 9.0;
        """ )
    )
        
    override func setupBoard() {
        // 背景色の設定
        self.clearColor = .darkGrey
             
        atlasio
        .input(atlas: atlas, key: "key1" )
        .output(atlas: atlas, key: "key1" )
    }
    
    // 設計関数
    override func designBoard() {
        panels.removeAll()
                
        for _ in 0 ..< 100 {
            // パネルを円デコレーションで作成
            let p = LBPanel( decoration: deco_blur_circle )
            panels.insert( p )
        }

        // パネルの位置や色を設定
        for p in panels {
            let px = (coordMinX...coordMaxX).randomize
            let py = (coordMinY...coordMaxY).randomize
            let size = 40.0 + ( 120.0 ).randomize

            p
            .position( cx: px, cy: py )
            .scale( width:size, height:size )
            .angle( .random )
            .life( .random )
            .color( .random )
        }
        
        /*
        panel_solo = LBPanel( decoration: self.deco_tex )
                  .scale( width:256, height:256 )
                  .texture( tex_out )
        */
        
        panel_solo = LBPanel( decoration: self.deco_atlas )
        .scale( width:256, height:256 )
        .atlasParts(of: "key1" )
    }

    // 繰り返し処理関数
    override func updateBoard() {
        self.compute {
            atlascraft_blur.atlasIO( atlasio ).fire( using:$0 )
        }
        
        for p in panels {            
            p.life { $0.life - 0.005 }
            .width { 80.0 + (1.0 - $0.life) * 120.0 }
            .height { 80.0 + (1.0 - $0.life) * 120.0 }
            .angle { $0.angle + 0.005 * Double.pi }
            .alpha { sin( $0.life * Float.pi ) * 0.75 }
            
            if p.life <= 0.0 {
                let px = (coordMinX...coordMaxX).randomize
                let py = (coordMinY...coordMaxY).randomize
                
                p.position( cx: px, cy: py )
                .scale( .zero )
                .angle( .random )
                .life( 1.0 )
                .color( .random )
            }
        }
                
        for touch in self.touches {
            let p = LBPanel( decoration: deco_circle )
                .position( touch.xy )
                .scale( width:2.0, height:2.0 )
                .color( .random )
                .life( 1.0 )
            panels_circle.insert( p )
        }
        
        for p in panels_circle {            
            p.life { $0.life - 0.005 }
            .width { 20.0 + (1.0 - $0.life) * 120.0 }
            .height { 20.0 + (1.0 - $0.life) * 120.0 }
            .alpha { sin( $0.life * Float.pi ) }
            
            if p.life <= 0.0 {
                panels_circle.remove( p )
            }
        }
    }
}
