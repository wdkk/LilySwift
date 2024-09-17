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

import Metal
import simd

extension Lily.Stage.Playground.sRGB
{   
    open class SMetal
    {
        public let vertexShader:Lily.Metal.Shader
        public let fragmentShader:Lily.Metal.Shader

        nonisolated(unsafe) private static var instance:SMetal?        
        public static func shared( device:MTLDevice ) -> SMetal {
            if instance == nil { instance = .init( device:device ) }
            return instance!
        }
        
        private init( device:MTLDevice ) {
            //LLLog( "文字列からシェーダを生成しています." )
            
            self.vertexShader = .init(
                device:device, 
                code: Lily.Stage.Playground.sRGB.Vs_SMetal,
                shaderName:"Lily_Stage_Playground_SRGB_Vs" 
            )
            
            self.fragmentShader = .init(
                device:device,
                code: Lily.Stage.Playground.sRGB.Fs_SMetal,
                shaderName:"Lily_Stage_Playground_SRGB_Fs" 
            )
        }
    }
}

#endif
