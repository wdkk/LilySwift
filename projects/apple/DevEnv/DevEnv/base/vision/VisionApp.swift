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

struct ContentStageConfiguration
: CompositorLayerConfiguration 
{
    func makeConfiguration(
        capabilities: LayerRenderer.Capabilities, 
        configuration: inout LayerRenderer.Configuration
    ) 
    {
        configuration.colorFormat = Lily.Stage.BufferFormats.backBuffer
        configuration.depthFormat = Lily.Stage.BufferFormats.depth
    
        let foveationEnabled = capabilities.supportsFoveation
        configuration.isFoveationEnabled = foveationEnabled
        
        let options: LayerRenderer.Capabilities.SupportedLayoutsOptions = foveationEnabled ? [.foveationEnabled] : []
        let supportedLayouts = capabilities.supportedLayouts(options: options)
        
        configuration.layout = supportedLayouts.contains( .layered ) ? .layered : .dedicated
    }
}

@main
struct VisionApp
: App 
{
    var body: some Scene {
        WindowGroup {
            VisionContentView()
        }
        .windowStyle( .plain )
        
        
        ImmersiveSpace( id:"LilyImmersiveSpace" ) {
            CompositorLayer( configuration:ContentStageConfiguration() ) { layerRenderer in
                let renderEngine = Lily.Stage.VisionRenderEngine( layerRenderer )
                renderEngine.startRenderLoop()
            }
        }
        .immersionStyle(
            selection: .constant(.full),
            in: .full
        )
    }
}
