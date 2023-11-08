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
        var viewMatrix: float4x4 = .identity
        var projectionMatrix: float4x4 = .identity
        var viewProjectionMatrix: float4x4 = .identity
        var invOrientationProjectionMatrix: float4x4 = .identity
        var invViewProjectionMatrix: float4x4 = .identity
        var invProjectionMatrix: float4x4 = .identity
        var invViewMatrix: float4x4 = .identity
        
        public init() {}
        
        public init( 
            viewMatrix:LLMatrix4x4,
            projectionMatrix:LLMatrix4x4,
            orientationMatrix:LLMatrix4x4
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
        }
    }
}
