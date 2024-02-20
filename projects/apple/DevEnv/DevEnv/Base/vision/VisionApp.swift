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

@main
struct VisionApp
: App 
{
    
    public private(set) var environment:Lily.Stage.ShaderEnvironment
    
    @State var modelRenderTextures:PG.Model.ModelRenderTextures?        
    @State var mediumTexture:PG.MediumTexture?
    // MARK: ストレージ
    @State var planeStorage:PG.Plane.PlaneStorage?
    @State var modelStorage:PG.Model.ModelStorage?
    @State var bbStorage:PG.Billboard.BBStorage?
    
    init() {
        self.environment = .string
    }
    
    var body: some Scene
    {
        WindowGroup {
            VisionContentView()
        }
        .windowStyle( .volumetric )
        
        ImmersiveSpace( id:"LilyImmersiveSpace" ) {
            CompositorLayer( configuration:Lily.Stage.VisionFullyRenderConfiguration() ) { layerRenderer in
                let device = layerRenderer.device
                
                modelRenderTextures = .init( device:device )
                modelRenderTextures?.updateBuffers(size:.init(2048, 1024), viewCount:1 )
                
                mediumTexture = .init( device:device )
                mediumTexture?.updateBuffers( size:.init(2048,1024), viewCount:1 )
                
                planeStorage = .playgroundDefault( device:device )
                modelStorage = .playgroundDefault( device:device )
                bbStorage = .playgroundDefault( device:device )
                
                // レンダーフローの生成
                let clearRenderFlow:PG.ClearRenderFlow = .init(
                    device:device,
                    viewCount:1,
                    mediumTextures:mediumTexture!,
                    environment:environment
                )
                
                clearRenderFlow.clearColor = .darkGray
                
                let modelRenderFlow:PG.Model.ModelRenderFlow = .init(
                    device:device,
                    environment:self.environment,
                    viewCount:1,
                    renderTextures:modelRenderTextures!,
                    mediumTexture:mediumTexture!,
                    storage:modelStorage
                )
                                        
                let bbRenderFlow:PG.Billboard.BBRenderFlow = .init( 
                    device:device,
                    environment:self.environment,
                    viewCount:1,
                    mediumTexture:mediumTexture!,
                    storage:bbStorage
                )
                
                let planeRenderFlow:PG.Plane.PlaneRenderFlow = .init( 
                    device:device,
                    environment:self.environment,
                    viewCount:1,
                    mediumTextures:mediumTexture!,
                    storage:planeStorage
                )
                
                let sRGBRenderFlow:PG.SRGBRenderFlow = .init(
                    device:device, 
                    environment:self.environment,
                    viewCount:1,
                    mediumTextures:mediumTexture!
                )
                
                let renderEngine = Lily.Stage.VisionFullyRenderEngine( 
                    layerRenderer,
                    renderFlows:[
                        clearRenderFlow,
                        modelRenderFlow,
                        bbRenderFlow, 
                        planeRenderFlow, 
                        sRGBRenderFlow
                    ],
                    buffersInFlight:3
                )
                
                PGCircle( storage:planeStorage )
                .color( .blue )
                
                renderEngine.startRenderLoop()
            }
        }
        .immersionStyle(
            selection: .constant(.full),
            in: .full
        )
    }
}
