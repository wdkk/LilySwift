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
            design: { screen in
                screen.clearColor = .clear
                
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
            },
            update: { screen in
                
            }
        )
   }
}
