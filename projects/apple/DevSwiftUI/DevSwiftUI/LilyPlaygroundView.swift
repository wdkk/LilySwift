//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import LilySwift
import SwiftUI
import MetalKit

struct LilyPlaygroundView: View
{
    let device = MTLCreateSystemDefaultDevice()!
    
    var body: some View {
        PG.PGScreenView(
            device: device,
            environment: .metallib,
            planeStorage:.init( 
                device:device, 
                capacity:2000,
                textures:["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"]
            ),
            modelStorage:.init( 
                device:device, 
                modelCapacity:500,
                modelAssets:[ "cottonwood1", "acacia1", "plane" ]
            ),
            bbStorage:.init( 
                device:device, 
                capacity:2000,
                textures:["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"]
            ),
            design: { screen in
                screen.clearColor = .clear
                
                /*
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
                */
            
                for _ in 0 ..< 160 {
                    PGAddMask( "mask-smoke" )
                    .color( LLColor( 0.9, 0.34, 0.22, 1.0 ) )
                    .position(
                        cx:(-50 ... 50).randomize,
                        cy:(-120 ... -110).randomize
                    )
                    .deltaPosition( 
                        dx:(-1.0...1.0).randomize,
                        dy:(0.5...4.5).randomize 
                    )
                    .scale( square: 80.0 )
                    .deltaScale( dw: 0.5, dh: 0.5 )
                    .angle( .random )
                    .deltaAngle( degrees:(-2.0...2.0).randomize )
                    .life( .random )
                    .deltaLife( -0.01 )
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
                            cx:(-50 ... 50).randomize,
                            cy:(-120 ... -110).randomize 
                        )
                        .scale( square: 80.0 )
                        .life( 1.0 )
                    }
                }
                
                /*
                for _ in 0 ..< 80 {
                    PGAddBlurryCircle()
                    .color( .random )
                    .position( screen.randomPoint )
                    .scale( square: 50.0 )
                    .deltaScale( dw: 0.5, dh: 0.5 )
                    .alpha( 0 )
                    .life( .random )
                    .deltaLife( -0.003 )
                    .iterate {
                        $0.alpha( sin( $0.life * Float.pi ) * 0.2 )
                    }
                    .completion {
                        $0
                        .color( .random )
                        .position( screen.randomPoint )
                        .scale( square: 50.0 )
                        .life( 1.0 )
                        .alpha( 0 )
                    }
                }
                 */
            },
            update: { screen in
                
            }
        )
   }
}
