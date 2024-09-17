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

extension Lily.Stage.Playground.Plane
{   
    open class SMetal 
    {                
        public let comDeltaShader:Lily.Metal.Shader
        public let vertexShader:Lily.Metal.Shader
        public let fragmentShader:Lily.Metal.Shader
        
        nonisolated(unsafe) private static var instance:SMetal?
        public static func shared( device:MTLDevice ) -> SMetal {
            if instance == nil { instance = .init( device:device ) }
            return instance!
        }
        
        private static func convertFamily( device:MTLDevice, code:String ) -> String {
            if device.supportsFamily( .apple6 ) { return code }
            return code
            .replacingOccurrences( of:"//-apple6-earlier-comment-end", with:"*/" )
            .replacingOccurrences( of:"//-apple6-earlier-comment-start", with:"/*" )
            .replacingOccurrences( of:"//-apple6-earlier-active:", with:"" )
        }

        private init( device:MTLDevice ) {
            //LLLog( "文字列からシェーダを生成しています." )

            self.comDeltaShader = .init(
                device:device, 
                code:Self.convertFamily( device:device, code:Lily.Stage.Playground.Plane.ComDelta_SMetal ),
                shaderName:"Lily_Stage_Playground_Plane_Com_Delta" 
            )
            
            self.vertexShader = .init(
                device:device, 
                code:Self.convertFamily( device:device, code:Lily.Stage.Playground.Plane.Vs_SMetal ),
                shaderName:"Lily_Stage_Playground_Plane_Vs" 
            )
            
            self.fragmentShader = .init(
                device:device,
                code:Self.convertFamily( device:device, code:Lily.Stage.Playground.Plane.Fs_SMetal ),
                shaderName:"Lily_Stage_Playground_Plane_Fs" 
            )
        }
    }
}

#endif
