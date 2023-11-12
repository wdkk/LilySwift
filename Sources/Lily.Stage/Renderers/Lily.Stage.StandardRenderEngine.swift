//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal
import MetalKit
import simd

extension Lily.Stage
{    
    open class StandardRenderEngine
    : BaseRenderEngine
    {        
        let maxBuffersInFlight:Int = 3
        lazy var inFlightSemaphore = DispatchSemaphore( value:maxBuffersInFlight )
        
        var device:MTLDevice
        var commandQueue:MTLCommandQueue?
        var onFrame:UInt = 0
        
        var uniforms:Lily.Metal.RingBuffer<Shared.GlobalUniformArray>

        var renderFlow:BaseRenderFlow
        
        public var camera = Lily.Stage.Camera(
            perspectiveWith:LLFloatv3( 61, 26, 56 ),
            direction: LLFloatv3( -0.76, -0.312, -0.715 ), 
            up: LLFloatv3( 0, 1, 0 ), 
            viewAngle: Float.pi / 3.0, 
            aspectRatio: 320.0 / 240.0, 
            near: 5.0, 
            far: 600.0
        )
    
        //var cursorPosition:LLFloatv2 = .zero
        
        public init( device:MTLDevice, size:CGSize, renderFlow:BaseRenderFlow ) {
            self.device = device
            self.commandQueue = device.makeCommandQueue()
            
            self.uniforms = .init( device:device, ringSize:maxBuffersInFlight )
            
            self.renderFlow = renderFlow
            
            super.init()
        }
        
        public func updateGlobalUniform() {
            onFrame += 1
            
            let viewCount = 1
                        
            uniforms.update { uni in
                for view_idx in 0 ..< viewCount {
                    // ビューマトリックスの更新0
                    let vM = camera.calcViewMatrix()
                    
                    let projM = camera.calcProjectionMatrix()
                    
                    let orientationM = camera.calcOrientationMatrix()
                    
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
                        
                        // Stepsizeはテクセルのサイズの倍数
                        let stepsize = size / 64.0
                        let stepsizes =  LLFloatv3( repeating:stepsize )
                        shadow_cam.position -= fract( dot( center, shadow_cam.up ) / stepsizes ) * shadow_cam.up * stepsize
                        shadow_cam.position -= fract( dot( center, shadow_cam.right ) / stepsizes ) * shadow_cam.right * stepsize
                        
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
        
        public func changeScreenSize( size:CGSize ) {
            screenSize = size.llSizeFloat
            renderFlow.updateBuffers( size:size )
            camera.aspect = (size.width / size.height).f    // カメラのアス比を更新
        }

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
            let rasterizationRateMap:MTLRasterizationRateMap? = nil
            
            let viewports = [ MTLViewport(
                originX:0, 
                originY:0,
                width:screenSize.width.d,
                height:screenSize.height.d, 
                znear:1.0,
                zfar:0.0 
            )]
            
            let viewCount = 1
        
            let destinationTexture = renderPassDescriptor.colorAttachments[0].texture
            let depthTexture = renderPassDescriptor.depthAttachment.texture
            
            //-- 依存がある処理 --//
            // Uniformの更新
            self.updateGlobalUniform()
            
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
            
            commandBuffer.present( drawable )
            commandBuffer.commit()
            
            completion?( commandBuffer )
        }
    }
}    
