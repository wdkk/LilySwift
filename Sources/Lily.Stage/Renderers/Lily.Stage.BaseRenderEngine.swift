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
    open class BaseRenderEngine
    {
        var screenSize:LLSizeFloat = .zero
        
        // グローバルUniformの基本情報を作る
        func makeGlobalUniform( 
            onFrame:UInt,
            cameraUniform:Shared.CameraUniform,
            screenSize:LLSizeFloat
        ) 
        -> Shared.GlobalUniform 
        {
            var guni = Shared.GlobalUniform()
            guni.cameraUniform = cameraUniform
            guni.frameTime = max( 0.001, onFrame.f * (1.0 / 60.0) )
            guni.invScreenSize = LLFloatv2( 1.0 / screenSize.width, 1.0 / screenSize.height )
            guni.aspect = screenSize.width / screenSize.height
            
            guni.sunDirection = normalize( LLFloatv3( -1, 0.7, 0.5 ) )
            guni.projectionYScale = 1.73205066
            guni.ambientOcclusionContrast = 3
            guni.ambientOcclusionScale = 0.800000011
            guni.ambientLightScale = 0.699999988
            
            return guni
        }
        
        // カスケードシャドウの距離を三段階作る
        func makeCascadeDistances( sizes:[Float], viewAngle:Float ) -> [Float] {
            let tan_half_angle = tanf( viewAngle * 0.5 ) * sqrtf( 2.0 )
            let half_angle = atanf( tan_half_angle )
            let sine_half_angle = sinf( half_angle )
            
            // カスケードシャドウマップの3つの距離を大きさから計算
            var dists = [Float]( repeating:0.0, count:Shared.Const.shadowCascadesCount )
            // シャドウ0(近距離)
            dists[0] = 2 * sizes[0] * (1.0 - sine_half_angle * sine_half_angle)
            // シャドウ1(中距離)
            dists[1] = sqrtf(
                sizes[1] * sizes[1] - 
                dists[0] * dists[0] * tan_half_angle * tan_half_angle 
            ) + dists[0]
            // シャドウ2(遠距離)
            dists[2] = sqrtf(
                sizes[2] * sizes[2] -
                dists[1] * dists[1] * tan_half_angle * tan_half_angle
            ) + dists[1]
            
            return dists
        }
    }
}
