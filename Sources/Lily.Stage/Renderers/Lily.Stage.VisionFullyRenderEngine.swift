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

import Metal
import MetalKit
import simd
import SwiftUI
import CompositorServices
import Spatial

extension Lily.Stage
{              
    public struct VisionFullyRenderConfiguration
    : CompositorLayerConfiguration 
    {
        public init() {}
        
        public func makeConfiguration(
            capabilities: LayerRenderer.Capabilities, 
            configuration: inout LayerRenderer.Configuration
        ) 
        {
            configuration.colorFormat = BufferFormats.backBuffer
            configuration.depthFormat = BufferFormats.depth
        
            let foveationEnabled = capabilities.supportsFoveation
            configuration.isFoveationEnabled = foveationEnabled
            
            let options: LayerRenderer.Capabilities.SupportedLayoutsOptions = foveationEnabled ? [.foveationEnabled] : []
            let supportedLayouts = capabilities.supportedLayouts(options: options)
            
            configuration.layout = supportedLayouts.contains( .layered ) ? .layered : .dedicated
        }
    }
    
    open class VisionFullyRenderEngine 
    : BaseRenderEngine
    {
        let maxBuffersInFlight = 3
        lazy var inFlightSemaphore = DispatchSemaphore( value:maxBuffersInFlight )
        
        let arSession: ARKitSession
        let worldTracking:WorldTrackingProvider
        let layerRenderer:LayerRenderer
        
        let device: MTLDevice
        let commandQueue: MTLCommandQueue
        var onFrame:UInt = 0
        
        var uniforms:Lily.Metal.RingBuffer<Shared.GlobalUniformArray>
        
        var renderFlow:BaseRenderFlow
        
        public var camera = Lily.Stage.Camera(
            perspectiveWith:LLFloatv3( 0, 0, 0 ),
            direction: LLFloatv3( 0.0, 0.0, 1.0 ), 
            up: LLFloatv3( 0, 1, 0 ), 
            viewAngle: Float.pi / 3.0, 
            aspectRatio: 320.0 / 240.0, 
            near: 1.0, 
            far: 600.0
        )
        
        public init( _ layerRenderer:LayerRenderer, renderFlow:BaseRenderFlow ) {
            self.layerRenderer = layerRenderer
            self.worldTracking = WorldTrackingProvider()
            self.arSession = ARKitSession()
            
            self.device = layerRenderer.device
            self.commandQueue = self.device.makeCommandQueue()!

            self.uniforms = .init( device:device, ringSize:maxBuffersInFlight )
            
            self.renderFlow = renderFlow
            
            super.init()
        }
        
        public func startRenderLoop() {
            Task {
                do {
                    try await arSession.run( [worldTracking] )
                } 
                catch {
                    fatalError("Failed to initialize ARSession")
                }
                
                let renderThread = Thread { self.renderLoop() }
                renderThread.name = "Render Thread"
                renderThread.start()
            }
        }
        
        public func renderLoop() {
            while true {
                if layerRenderer.state == .invalidated {
                    print( "Layer is invalidated" )
                    return
                } 
                else if layerRenderer.state == .paused {
                    layerRenderer.waitUntilRunning()
                    continue
                } 
                else {
                    autoreleasepool { 
                        self.renderFrame() 
                    }
                }
            }
        }
        
        public func changeScreenSize( size:CGSize ) {
            screenSize = size.llSizeFloat
            renderFlow.updateBuffers( size:size ) 
            camera.aspect = (size.width / size.height).f
        }
        
        public func calcViewMatrix( 
            drawable:LayerRenderer.Drawable,
            deviceAnchor:DeviceAnchor?,
            viewIndex:Int
        )
        -> LLMatrix4x4
        {
            let deviceAnchorMatrix = deviceAnchor?.originFromAnchorTransform ?? LLMatrix4x4.identity
            let view = drawable.views[viewIndex]
            return (deviceAnchorMatrix * view.transform).inverse
        }
        
        public func calcProjectionMatrix(
            drawable:LayerRenderer.Drawable,
            deviceAnchor:DeviceAnchor?,
            viewIndex:Int
        )
        -> LLMatrix4x4
        {
            let view = drawable.views[viewIndex]
            
            let projection = ProjectiveTransform3D(
                leftTangent: Double(view.tangents[0]),
                rightTangent: Double(view.tangents[1]),
                topTangent: Double(view.tangents[2]),
                bottomTangent: Double(view.tangents[3]),
                nearZ: Double(drawable.depthRange.y),
                farZ: Double(drawable.depthRange.x),
                reverseZ:true
            )
            
            return LLMatrix4x4( projection )
        }
        
        public func calcOrientationMatrix( 
            viewMatrix:LLMatrix4x4
        )
        -> LLMatrix4x4
        {
            var orientation_mat = viewMatrix
            orientation_mat.W = LLFloatv4( 0.0, 0.0, 0.0, 1.0 )
            return orientation_mat
        }
        
        public func updateGlobalUniform( 
            drawable:LayerRenderer.Drawable,
            deviceAnchor:DeviceAnchor?
        )
        {  
            onFrame += 1
            
            let viewCount = drawable.views.count
   
            uniforms.update { uni in
                for view_idx in 0 ..< viewCount {
                    // TODO: アンカーなどからマトリクスを得ているが、アンカーとdrawableからcameraをつくるべき
                    // ビューマトリックスの更新0
                    let vM = self.calcViewMatrix(
                        drawable:drawable,
                        deviceAnchor:deviceAnchor,
                        viewIndex:view_idx
                    )
                    
                    let projM = self.calcProjectionMatrix(
                        drawable:drawable,
                        deviceAnchor:deviceAnchor, 
                        viewIndex:view_idx
                    )
                    
                    let orientationM = self.calcOrientationMatrix( viewMatrix:vM )
                    
                    let camera_uniform = Shared.CameraUniform(
                        viewMatrix:vM, 
                        projectionMatrix:projM,
                        orientationMatrix:orientationM
                    )
                    
                    uni[view_idx] = makeGlobalUniform( 
                        onFrame:onFrame, 
                        cameraUniform:camera_uniform, 
                        screenSize:screenSize
                    )
                    
                    let cascade_sizes:[Float] = [ 4.0, 16.0, 64.0 ]
                    let cascade_distances = makeCascadeDistances( sizes:cascade_sizes, viewAngle:camera.viewAngle )
                    
                    // カスケードシャドウのカメラユニフォームを作成
                    for c_idx in 0 ..< Shared.Const.shadowCascadesCount {
                        // TODO: cameraの計算ができていないのでシャドウは正しくない
                        // sun cascade back-planeの中央を計算
                        let center = camera.position + camera.direction * cascade_distances[c_idx]
                        let size = cascade_sizes[c_idx]
                        
                        var shadow_cam = Camera( 
                            parallelWith:center - uni[view_idx].sunDirection * size,
                            direction:uni[view_idx].sunDirection,
                            up: LLFloatv3( 0, 1, 0 ),
                            width:size * 2.0,
                            height:size * 2.0,
                            near:0.0,
                            far:size * 2.0
                        )
                        
                        // Stepsizeはテクセルのサイズの倍数にする
                        let stepsize = size / 64.0
                        shadow_cam.position -= fract( dot( center, shadow_cam.up ) / LLFloatv3( repeating:stepsize ) ) * shadow_cam.up * stepsize
                        shadow_cam.position -= fract( dot( center, shadow_cam.right ) / LLFloatv3( repeating:stepsize ) ) * shadow_cam.right * stepsize
                        
                        let view_matrix = shadow_cam.calcViewMatrix()
                        let projection_matrix = shadow_cam.calcProjectionMatrix()
                        let orientation_matrix = shadow_cam.calcOrientationMatrix()
                        
                        uni[view_idx].shadowCameraUniforms[c_idx] = Shared.CameraUniform( 
                            viewMatrix:view_matrix,
                            projectionMatrix:projection_matrix,
                            orientationMatrix:orientation_matrix
                        )
                    }
                }
            }
        }
                
        public func renderFrame() {
            defer { uniforms.next() /* リングバッファを回す */ }
            
            guard let frame = layerRenderer.queryNextFrame() else { return }
            
            frame.startUpdate()
            frame.endUpdate()
            
            guard let timing = frame.predictTiming() else { return }
            LayerRenderer.Clock().wait( until:timing.optimalInputTime )
            
            guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
            commandBuffer.label = "Vision Command Buffer" 
            commandBuffer.addCompletedHandler { [weak self] _ in self?.inFlightSemaphore.signal() }
            
            guard let layerRenderDrawable = frame.queryDrawable() else { return }
            
            // 今の画面サイズで再生成する
            changeScreenSize( size:CGSize( layerRenderDrawable.colorTextures[0].width, layerRenderDrawable.colorTextures[0].height ) )
            
            _ = inFlightSemaphore.wait( timeout:DispatchTime.distantFuture )
            
            frame.startSubmission()
            
            let time = layerRendererTimeInterval( from:LayerRenderer.Clock.Instant.epoch.duration( to:layerRenderDrawable.frameTiming.presentationTime ) )
            let deviceAnchor = worldTracking.queryDeviceAnchor( atTimestamp:time )
            
            layerRenderDrawable.deviceAnchor = deviceAnchor
            
            //-- 依存があるレンダリング定数設定 --//
            let rasterizationRateMap:MTLRasterizationRateMap? = layerRenderDrawable.rasterizationRateMaps.first
            
            let viewports = layerRenderDrawable.views.map { $0.textureMap.viewport }
            let viewCount = layerRenderer.configuration.layout == .layered ? layerRenderDrawable.views.count : 1
            
            let destinationTexture = layerRenderDrawable.colorTextures[0]
            let depthTexture = layerRenderDrawable.depthTextures[0]
            
            //-- 依存がある処理 --//
            // Uniformの更新
            self.updateGlobalUniform(
                drawable:layerRenderDrawable, 
                deviceAnchor:deviceAnchor
            )
            
            // 共通処理
            renderFlow.render(
                commandBuffer:commandBuffer,
                rasterizationRateMap:rasterizationRateMap,
                viewports:viewports, 
                viewCount:viewCount,
                destinationTexture:destinationTexture, 
                depthTexture:depthTexture,
                uniforms:uniforms
            )
            
            layerRenderDrawable.encodePresent( commandBuffer:commandBuffer )
            
            commandBuffer.commit()
            
            frame.endSubmission()
        }
    }
    
    static func layerRendererTimeInterval( from duration:LayerRenderer.Clock.Instant.Duration ) -> TimeInterval {
        let nanoseconds = TimeInterval( duration.components.attoseconds / 1_000_000_000 )
        return TimeInterval( duration.components.seconds ) + ( nanoseconds / TimeInterval(NSEC_PER_SEC) )
    }
}

#endif
