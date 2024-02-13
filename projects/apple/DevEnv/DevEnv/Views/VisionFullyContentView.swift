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
    
    var device = MTLCreateSystemDefaultDevice()!
    
    @State var renderEngine:Lily.Stage.StandardRenderEngine?
    
    @State var renderFlow:Lily.Stage.Playground.Plane.PlaneRenderFlow?
    
    @State var mouseDrag = LLFloatv2()
        
    func changeCameraStatus() {
        renderEngine?.camera.rotate( on:LLFloatv3( 0, 1, 0 ), radians: mouseDrag.x * 0.02 )
        renderEngine?.camera.rotate( on:renderEngine!.camera.left, radians: mouseDrag.y * 0.02 )
        mouseDrag = .zero
    }
    
    var body: some View {
        let planeStorage:PlaneStorage = .init(
            device: device,
            capacity: 2000, 
            textures: ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"]
        )

        let bbStorage:BBStorage = .init(
            device: device,
            capacity: 2000,
            textures: ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"]
        )

        let modelStorage:ModelStorage = .init(
            device: device,
            modelCapacity: 500,
            modelAssets: [ "cottonwood1", "acacia1", "plane" ] 
        )
        
        VStack {
            Toggle( "イマーシブ空間を開く", isOn: $showImmersiveSpace )
            .toggleStyle( .button )
            .padding()
            
            PG.PGScreenView( 
                device:device,
                environment:.metallib,
                planeStorage:planeStorage,
                modelStorage:modelStorage, 
                billboardStorage:bbStorage,
                design: { screen in
                
                screen.clearColor = .darkGrey
                screen.cubeMap = "skyCubeMap"
                
                /*
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
                */
                
                for _ in 0 ..< 10 {
                    let size = (40.0 ... 80.0).randomize
                    let speed = size / 80.0
                    let c = LLColor( 1.0, 0.8, 0.25, Float( speed ) )
                    
                    PGAddMask( "mask-star" )
                    .color( c )
                    .position( 
                        cx:(screen.minX-200...screen.maxX+200).randomize,
                        cy:(screen.minY...screen.maxY).randomize
                    )
                    .deltaPosition( 
                        dx:(10.0 ... 12.0).randomize * speed,
                        dy:(-1.5 ... 3.5).randomize * speed
                    )
                    .scale( square:size )
                    .angle( .random )
                    .deltaAngle( degrees:-4.0 * speed )
                    .iterate {
                        $0.deltaPosition.y -= 0.05
                                    
                        if Float( screen.maxX + 200.0 ) <= $0.position.x {
                            $0
                            .position( 
                                cx:screen.minX-200,
                                cy:(screen.minY...screen.maxY).randomize
                            )
                            .deltaPosition( 
                                dx:(10.0 ... 12.0).randomize * speed,
                                dy:(-1.5 ... 3.5).randomize * speed
                            )
                        }
                    }    
                    .interval( sec:0.05 ) {
                        PGAddCircle()
                        .color( c )
                        .position( $0.position )
                        .scale( square:0 )
                        .deltaScale( dw:0.5 * speed, dh:0.5 * speed )
                        .alpha( 0 )
                        .deltaLife( -0.02 )
                        .iterate {
                            $0.alpha( sin( $0.life * Float.pi ) * 0.5 )
                        }
                    }
                }
                
                PGAddCircle()
                .scale( square:50 )
                .position( cx: screen.minX + 50, cy: screen.minY + 50 ) 
                .color( .red )
                .zIndex( 1 )

                PGAddCircle()
                .scale( square:50 )
                .position( cx: screen.maxX - 50, cy: screen.minY + 50 ) 
                .color( .blue )
                .zIndex( 2 )

                PGCircle()
                .scale( square:50 )
                .position( cx: screen.minX + 50, cy: screen.maxY - 50 ) 
                .color( .red )

                PGCircle()
                .scale( square:50 )
                .position( cx: screen.maxX - 50, cy: screen.maxY - 50 ) 
                .color( .blue )
                
                // Playground
                
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
            },
            update: { screen in

            })
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
