//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

import MetalKit
import simd

extension Lily.Stage.Playground
{    
    open class StandardRenderEngine
    : BaseRenderEngine
    {        
        let maxBuffersInFlight:Int
        lazy var inFlightSemaphore = DispatchSemaphore( value:maxBuffersInFlight )
        
        var device:MTLDevice
        var commandQueue:MTLCommandQueue?
        var onFrame:UInt = 0
        
        var uniforms:Lily.Metal.RingBuffer<GlobalUniformArray>
        
        var renderFlows:[BaseRenderFlow?] = []
                
        public var camera:Camera = .init(
            perspectiveWith: .init( 0.0, 260, 500.0 ),
            direction: .init( 0.0, -0.5, -1.0 ), 
            up: LLFloatv3( 0, 1, 0 ), 
            viewAngle: Float.pi / 3.0, 
            aspectRatio: 320.0 / 240.0, 
            near: 0.1, 
            far: 6000.0
        )
        
        public var sunDirection:LLFloatv3 = .init( 1, -0.7, 0.5 )
        
        public init( device:MTLDevice, buffersInFlight:Int ) {
            self.device = device
            self.commandQueue = device.makeCommandQueue()
            self.maxBuffersInFlight = buffersInFlight
            
            self.uniforms = .init( device:device, ringSize:maxBuffersInFlight )
                        
            super.init()
        }
        
        public func updateGlobalUniform() {
            onFrame += 1
            
            let viewCount = 1
                               
            uniforms.update { uni in
                for view_idx in 0 ..< viewCount {
                    // ビューマトリックスの更新
                    let vM = self.camera.calcViewMatrix()
                    
                    let projM = self.camera.calcProjectionMatrix()
                    
                    let orientationM = self.camera.calcOrientationMatrix()
                    
                    let camera_uniform = CameraUniform(
                        viewMatrix:vM, 
                        projectionMatrix:projM,
                        orientationMatrix:orientationM,
                        position:self.camera.position,
                        up:normalize( self.camera.up ),
                        right:normalize( self.camera.right ),
                        direction:normalize( self.camera.direction )
                    )

                    uni[view_idx] = makeGlobalUniform(
                        onFrame:onFrame, 
                        cameraUniform:camera_uniform, 
                        sunDirection:sunDirection,
                        screenSize:screenSize
                    )
                    
                    let cascade_sizes:[Float] = [ 400.0, 1600.0, 6400.0 ]
                    let cascade_distances = makeCascadeDistances( sizes:cascade_sizes, viewAngle:camera.viewAngle )
                    
                    // カスケードシャドウのカメラユニフォームを作成
                    for c_idx in 0 ..< shadowCascadesCount {
                        let center = camera.position + camera.direction * cascade_distances[c_idx]
                        let size = cascade_sizes[c_idx]

                        var shadow_cam = Camera( 
                            parallelWith:center - uni[view_idx].sunDirection * size,
                            direction:uni[view_idx].sunDirection,
                            up: .init( 0, 1, 0 ),
                            width:size * 2.0,
                            height:size * 2.0,
                            near:0.0,
                            far:size * 2.0
                        )
                        
                        // Stepsizeはテクセルのサイズの倍数
                        let stepsize = size / 64.0
                        let stepsizes = LLFloatv3( repeating:stepsize )
                        shadow_cam.position -= fract( dot( center, shadow_cam.up ) / stepsizes ) * shadow_cam.up * stepsize
                        shadow_cam.position -= fract( dot( center, shadow_cam.right ) / stepsizes ) * shadow_cam.right * stepsize
                        
                        uni[view_idx].shadowCameraUniforms[c_idx] = shadow_cam.uniform
                    }
                }
            }
        }
        
        @MainActor
        public func changeScreenSize( size:CGSize ) {            
            screenSize = size.llSizeFloat
            renderFlows.forEach { $0?.changeSize( scaledSize:size ) }
            camera.aspect = (size.width / size.height).f
        }
        
        public func setRenderFlows( _ flows:[BaseRenderFlow?] ) {
            self.renderFlows = flows
        }

        @MainActor
        public func update( 
            with drawable:MTLDrawable,
            renderPassDescriptor:MTLRenderPassDescriptor,
            completion:(( MTLCommandBuffer? ) -> ())? = nil
        )
        {
            defer { uniforms.next() /* リングバッファを回す */ }
            
            guard let commandBuffer = commandQueue?.makeCommandBuffer() else { return }
            commandBuffer.label = "Frame Command Buffer"
            commandBuffer.addCompletedHandler { [weak self] _ in self?.inFlightSemaphore.signal() }
            
            // 今の画面サイズで再生成する
            changeScreenSize( size:screenSize.cgSize )
            
            _ = inFlightSemaphore.wait( timeout:.distantFuture )
            
            //-- 依存があるレンダリング定数設定 --//
            let rasterizationRateMap:Lily.Metal.RasterizationRateMap? = nil
            
            let viewports = [ MTLViewport(
                originX:0, 
                originY:0,
                width:screenSize.width.d,
                height:screenSize.height.d, 
                znear:0.0,
                zfar:1.0 
            )]
            
            let viewCount = 1
        
            let destinationTexture = renderPassDescriptor.colorAttachments[0].texture
            let depthTexture = renderPassDescriptor.depthAttachment.texture
            
            //-- 依存がある処理 --//
            // Uniformの更新
            self.updateGlobalUniform()
            
            // 共通処理
            renderFlows.forEach { 
                $0?.render(
                    commandBuffer:commandBuffer,
                    rasterizationRateMap:rasterizationRateMap,
                    viewports:viewports, 
                    viewCount:viewCount,
                    destinationTexture:destinationTexture, 
                    depthTexture:depthTexture,
                    uniforms:uniforms
                ) 
            }
            
            commandBuffer.present( drawable )
            commandBuffer.commit()
            
            completion?( commandBuffer )
        }
    }
}    

#endif
