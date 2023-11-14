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
import simd
#if os(macOS)
import AppKit
#else
import UIKit
#endif

import LilySwift

extension DevEnv
{      
    open class ObjectRenderer
    : Lily.Stage.ObjectRenderer
    {          
        public override init( device:MTLDevice, viewCount:Int ) {
            super.init( device:device, viewCount:viewCount )
            
            loadAssets()
            
            instanceBuffer = .init( device:device, count:maxModelCount * models.count * cameraCount )
            
            instanceBuffer?.update { acc in
                for cam_idx in 0 ..< cameraCount {
                    for idx in 0 ..< models.count {
                        let b = idx + cam_idx
                        acc[b] = .identity
                    }
                }
            }
        }
        
        public func loadAssets() {
            let assets = [
                "cube"
            ]
            
            for asset_name in assets {
                guard let asset = NSDataAsset( name:asset_name ) else { continue }
                models.append( Lily.Stage.Model.Obj( device:device, data:asset.data ) )
            }
        }
        
        public func generateObject( with commandBuffer:MTLCommandBuffer? ) {
            instanceBuffer?.update { acc in
                for iid in 0 ..< maxModelCount * cameraCount {
                    // オブジェクトの位置
                    let world_pos = LLFloatv3( -10, -2.0, 5.0 + -2.5 * Float(iid) )
                    
                    let object_scale = LLFloatv3( 4.0, 4.0, 4.0 )
                    
                    let up = LLFloatv3( 0, 1, 0 )
                    let right = normalize( cross( up, LLFloatv3( 1.0, 0.0, 1.0 ) ) )
                    let fwd = cross( up, right )
                    
                    let world_matrix = float4x4(   
                        LLFloatv4( fwd * object_scale, 0 ),
                        LLFloatv4( up * object_scale, 0 ),
                        LLFloatv4( right * object_scale, 0 ),
                        LLFloatv4( world_pos, 1 )
                    )
                    
                    acc[iid] = world_matrix
                }
            }
        }
        
    }
}
