//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(visionOS)
import Foundation
import LilySwift
import LilySwiftAlias

class VisionPlayground
{
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
        .position( cx:-5.0, cy:-1.5, cz:0.0 )
        .scale( x: 4, y: 4, z: 4 )
        
        MDObj( assetName:"cottonwood1" )
        .position( cx:5.0, cy:-1.5, cz:0.0 )
        .scale( x: 8, y: 8, z: 8 )
        
        MDObj( assetName:"acacia1" )
        .position( cx:0.0, cy:-1.5, cz:10.0 )
        .scale( x: 3, y: 3, z:3 )
        
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
}
#endif
