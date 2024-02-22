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
    
    // Playground 2D
    
    PGCircle()
    .scale( square:100 )
    .position( cx: screen.minX + 100, cy: screen.minY + 100 ) 
    .color( .red )
    
    // Playground 3D
    
    ModelObj( assetName:"cottonwood1" )
    .position( cx:-50.0, cy:0.0, cz:0.0 )
    .scale( x: 40, y: 40, z: 40 )
    
    ModelObj( assetName:"cottonwood1" )
    .position( cx:50.0, cy:0.0, cz:0.0 )
    .scale( x: 80, y: 80, z: 80 )
    
    ModelObj( assetName:"acacia1" )
    .position( cx:0.0, cy:0.0, cz:100.0 )
    .scale( x: 30, y: 30, z:30 )
    
    ModelObj( assetName:"plane" ) 
    .position( cx:0.0, cy:0.0, cz:0.0 )
    .scale( equal:1000.0 )
    
    for _ in 0 ..< 160 {
        BBAddBlurryCircle()
        .color( LLColor( 0.25, 0.8, 1.0, 1.0 ) )
        .position(
            cx:(-1000.0 ... 1000.0).randomize,
            cy:(0.0 ... 0.0).randomize,
            cz:(-1000.0 ... 1000.0).randomize
        )
        .deltaPosition( 
            dx:(-0.1...0.1).randomize,
            dy:(0.5...1.0).randomize,
            dz:(-0.1...0.1).randomize
        )
        .scale( square: 10.0 )
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
                cx:(-200.0 ... 200.0).randomize,
                cy:(0.0 ... 0.0).randomize,
                cz:(-200.0 ... 200.0).randomize
            )
            .scale( square: 10.0 )
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
