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
    @Binding var scene:PG.PGScene
    
    var body: some View {
        PG.PGScreenView(
            device:device,
            environment:.metallib,
            scene:$scene
        )
        //.allowsHitTesting( false )
   }
}
