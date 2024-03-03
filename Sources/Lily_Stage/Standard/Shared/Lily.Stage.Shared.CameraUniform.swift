//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import simd

extension Lily.Stage.Shared
{
    public struct CameraUniform
    {
        public var viewMatrix:LLMatrix4x4 = .identity
        public var projectionMatrix:LLMatrix4x4 = .identity
        public var viewProjectionMatrix:LLMatrix4x4 = .identity
        public var invOrientationProjectionMatrix:LLMatrix4x4 = .identity
        public var invViewProjectionMatrix:LLMatrix4x4 = .identity
        public var invProjectionMatrix:LLMatrix4x4 = .identity
        public var invViewMatrix:LLMatrix4x4 = .identity
        public var frustumPlanes: (LLFloatv4, LLFloatv4, LLFloatv4, LLFloatv4, LLFloatv4, LLFloatv4) = 
            ( .zero, .zero, .zero, .zero, .zero, .zero )
        public var position:LLFloatv3 = .zero
        public var up:LLFloatv3 = .zero
        public var right:LLFloatv3 = .zero
        public var direction:LLFloatv3 = .zero
        
        public init() {}
        
        public init( 
            viewMatrix:LLMatrix4x4,
            projectionMatrix:LLMatrix4x4,
            orientationMatrix:LLMatrix4x4,
            position:LLFloatv3,
            up:LLFloatv3,
            right:LLFloatv3,
            direction:LLFloatv3
        )
        {
            // ビュー行列(カメラの視点と視線)
            self.viewMatrix = viewMatrix
            // プロジェクション行列
            self.projectionMatrix = projectionMatrix
            // プロジェクション行列 x ビュー行列
            self.viewProjectionMatrix = projectionMatrix * viewMatrix
            // 各種逆行列の計算
            self.invOrientationProjectionMatrix = (projectionMatrix * orientationMatrix).inverse
            self.invViewProjectionMatrix = self.viewProjectionMatrix.inverse
            self.invProjectionMatrix = projectionMatrix.inverse
            self.invViewMatrix = viewMatrix.inverse
            
            let transp_vpm = self.viewProjectionMatrix.transpose
            self.frustumPlanes.0 = planeNormalize(transp_vpm.columns.3 - transp_vpm.columns.0)
            self.frustumPlanes.1 = planeNormalize(transp_vpm.columns.3 + transp_vpm.columns.0)
            self.frustumPlanes.2 = planeNormalize(transp_vpm.columns.3 - transp_vpm.columns.1)
            self.frustumPlanes.3 = planeNormalize(transp_vpm.columns.3 + transp_vpm.columns.1)
            self.frustumPlanes.4 = planeNormalize(transp_vpm.columns.3 - transp_vpm.columns.2)
            self.frustumPlanes.5 = planeNormalize(transp_vpm.columns.3 + transp_vpm.columns.2)
            
            self.position = position
            self.up = up
            self.right = right
            self.direction = direction
        }
        
        fileprivate func planeNormalize( _ inPlane:LLFloatv4 ) -> LLFloatv4 {
            return inPlane / simd_length( inPlane.xyz )
        }
    }
}
