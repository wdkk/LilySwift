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
import LilySwift

struct VisionContentView: View 
{
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var device = MTLCreateSystemDefaultDevice()
    
    @State var renderEngine:Lily.Stage.StageRenderEngine?
    
    @State var mouseDrag = LLFloatv2()
        
    func changeCameraStatus() {
        renderEngine?.camera.rotate( on:LLFloatv3( 0, 1, 0 ), radians: mouseDrag.x * 0.02 )
        renderEngine?.camera.rotate( on:renderEngine!.camera.left, radians: mouseDrag.y * 0.02 )
        mouseDrag = .zero
    }

    var body: some View {
        VStack {
            Toggle( "Show Immersive Space", isOn: $showImmersiveSpace )
            .toggleStyle( .button )
            .padding()
            
            Lily.UI.MetalView( 
                device:device,
                setup: { view in
                    renderEngine = .init( device:device!, size:CGSize( 320, 240 ) )
                },
                buildup: { view in
                    renderEngine?.changeScreenSize( size:view.scaledBounds.size )
                },
                draw: { view, drawable, renderPassDesc in
                    changeCameraStatus()
                    
                    renderEngine?.update(
                        with:drawable,
                        renderPassDescriptor:renderPassDesc,
                        completion: { commandBuffer in
                            //commandBuffer?.waitUntilCompleted() 
                        }
                    ) 
                }
            )
            .frame( width:800, height:600 )
            .padding()
        }
        .padding( 20.0 )
        .glassBackgroundEffect()
        .onChange( of:showImmersiveSpace ) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace( id:"LilyImmersiveSpace" ) {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } 
                else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
        }
    }
}