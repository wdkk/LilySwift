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
import LilySwiftAlias

func design( screen:PGVisionFullyScreen ) {
    screen.clearColor = .grey
    screen.cubeMap = "skyCubeMap"
    
    screen.sunDirection = .init( 0.5, -0.8, 0.5 )
    
    // Playground 2D
    
    PGCircle()
    .scale( square:100 )
    .position( cx: screen.minX + 100, cy: screen.minY + 100 ) 
    .color( .red )
    
    // Playground 3D
    
    MDObj( assetName:"cottonwood1" )
    .position( cx:-3.0, cy:-1.5, cz:0.0 )
    .scale( x: 3, y: 3, z: 3 )
    
    MDObj( assetName:"cottonwood1" )
    .position( cx:3.0, cy:-1.5, cz:0.0 )
    .scale( x: 5, y: 5, z: 5 )
    
    MDObj( assetName:"acacia1" )
    .position( cx:0.0, cy:-1.5, cz:4.0 )
    .scale( x: 2, y:2, z:2 )
    
    MDObj( assetName:"acacia1" )
    .position( cx:0.0, cy:-1.5, cz:-8.0 )
    .scale( x:2, y:2, z:2 )
    
    MDObj( assetName:"plane" ) 
    .position( cx:0.0, cy:-1.5, cz:0.0 )
    .scale( equal:100.0 )
    
    for _ in 0 ..< 160 {
        BBAddBlurryCircle()
        .color( LLColor( 0.25, 0.8, 1.0, 1.0 ) )
        .position(
            cx:(-10.0 ... 10.0).randomize,
            cy:(0.0 ... 0.0).randomize,
            cz:(-10.0 ... 10.0).randomize
        )
        .deltaPosition( 
            dx:(-0.01...0.01).randomize,
            dy:(0.05...0.1).randomize,
            dz:(-0.01...0.01).randomize
        )
        .scale( square: 1.0 )
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
                cx:(-10.0 ... 10.0).randomize,
                cy:(0.0 ... 0.0).randomize,
                cz:(-10.0 ... 10.0).randomize
            )
            .scale( square: 1.0 )
            .life( 1.0 )
        }
    }
}

func update( screen:PGVisionFullyScreen ) {
    
}

@main
struct VisionApp
: App 
{
    @State var fullyScreen:PGVisionFullyScreen?
    
    var body: some Scene
    {
        WindowGroup {
            VisionContentView()
        }
        .windowStyle( .volumetric )
        
        ImmersiveSpace( id:"LilyImmersiveSpace" ) {
            CompositorLayer( configuration:Lily.Stage.Playground.VisionFullyRenderConfiguration() ) { layerRenderer in
                let device = layerRenderer.device
                
                fullyScreen = PGVisionFullyScreen(
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
