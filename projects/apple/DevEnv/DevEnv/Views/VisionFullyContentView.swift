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

struct VisionFullyContentView : View
{
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var device = MTLCreateSystemDefaultDevice()
    
    @State var renderEngine:Lily.Stage.StandardRenderEngine?
    
    @State var renderFlow:Lily.Stage.Playground2D.Plane.PlaneRenderFlow?
    
    @State var mouseDrag = LLFloatv2()
        
    func changeCameraStatus() {
        renderEngine?.camera.rotate( on:LLFloatv3( 0, 1, 0 ), radians: mouseDrag.x * 0.02 )
        renderEngine?.camera.rotate( on:renderEngine!.camera.left, radians: mouseDrag.y * 0.02 )
        mouseDrag = .zero
    }
    
    var body: some View {
        VStack {
            Toggle( "イマーシブ空間を開く", isOn: $showImmersiveSpace )
            .toggleStyle( .button )
            .padding()
            
            PG2D.PGScreenView( device:device!,
            environment:.metallib,
            design: { screen in
                screen.clearColor = .darkGrey
                
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
            },
            update: { screen in

            })
            
            /*
            Lily.UI.MetalView( 
                device:device,
                setup: { view in
                    renderFlow = .init( 
                        device:device!, 
                        viewCount:Lily.Stage.fullyViewCount,
                        textures: ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"]
                    )
                    
                    renderEngine = .init( 
                        device:device!,
                        size:CGSize( 320, 240 ),
                        renderFlow:renderFlow!,
                        buffersInFlight:3
                    )
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
            */
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
