//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import SwiftUI
import CompositorServices
import LilySwift

func design( screen:Lily.Stage.Playground.PGVisionFullyScreen ) {
    screen.clearColor = .grey
    screen.cubeMap = "skyCubeMap"
    
    PGCircle()
    .color( .blue )
    
    ModelObj( assetName:"cottonwood1" )
    .position( cx:-500.0, cy:0.0, cz:0.0 )
    .scale( x: 400, y: 400, z: 400 )
    
    ModelObj( assetName:"cottonwood1" )
    .position( cx:500.0, cy:0.0, cz:0.0 )
    .scale( x: 800, y: 800, z: 800 )
    
    ModelObj( assetName:"acacia1" )
    .position( cx:0.0, cy:0.0, cz:1000.0 )
    .scale( x: 300, y: 300, z:300 )
    
    ModelObj( assetName:"plane" ) 
    .position( cx:0.0, cy:0.0, cz:0.0 )
    .scale( equal:20000.0 )
    
    for _ in 0 ..< 160 {
        BBAddBlurryCircle()
        .color( LLColor( 0.25, 0.8, 1.0, 1.0 ) )
        .position(
            cx:(-2000.0 ... 2000.0).randomize,
            cy:(0.0 ... 0.0).randomize,
            cz:(-2000.0 ... 2000.0).randomize
        )
        .deltaPosition( 
            dx:(-1...1).randomize,
            dy:(5...10).randomize,
            dz:(-1...1).randomize
        )
        .scale( square: 100.0 )
        .life( .random )
        .deltaLife( -0.005 )
        .iterate {
            if $0.life < 0.5 {
               $0.alpha( $0.life )
            }
            else {
               $0.alpha( (1.0 - $0.life) )
            }
        }
        .completion {
            $0
            .position(
                cx:(-2000.0 ... 2000.0).randomize,
                cy:(0.0 ... 0.0).randomize,
                cz:(-2000.0 ... 2000.0).randomize
            )
            .scale( square: 100.0 )
            .life( 1.0 )
        }
    }
}

func update( screen:Lily.Stage.Playground.PGVisionFullyScreen ) {
    
}

@main
struct VisionApp
: App 
{
    @State var fullyScreen:Lily.Stage.Playground.PGVisionFullyScreen?
    
    var body: some Scene
    {
        WindowGroup {
            VisionContentView()
        }
        .windowStyle( .volumetric )
        
        ImmersiveSpace( id:"LilyImmersiveSpace" ) {
            CompositorLayer( configuration:Lily.Stage.VisionFullyRenderConfiguration() ) { layerRenderer in
                let device = layerRenderer.device
                
                fullyScreen = Lily.Stage.Playground.PGVisionFullyScreen(
                    layerRenderer:layerRenderer, 
                    environment:.metallib,
                    scene:.init(
                        planeStorage:.playgroundDefault( device:device ),
                        bbStorage:.playgroundDefault( device:device ),
                        modelStorage:.playgroundDefault( device:device ),
                        design:design,
                        update:update
                    )
                )
            }
        }
        .immersionStyle(
            selection: .constant(.full),
            in: .full
        )
    }
}
