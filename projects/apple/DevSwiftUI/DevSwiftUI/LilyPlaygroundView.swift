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
            planeStorage: .playgroundDefault( device:device ),
            modelStorage: .playgroundDefault( device:device ),
            bbStorage: .playgroundDefault( device:device )
        )
        .onDesign { screen in
            screen.clearColor = .clear
        
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
        }
        .onUpdate { screen in
            
        }
        .onResize { screen in
            screen.redesign()
        }
        //.allowsHitTesting( false )
   }
}
