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
import LilySwift

extension DevEnv
{   
    
    open class ParticleRenderer
    : Lily.Stage.ParticleRenderer
    { 
        public override init( device:MTLDevice, viewCount:Int ) {
            super.init( device:device, viewCount:viewCount )
            
            setupParticles()
            setupModelMatrix()
            setupStatus()
        }
        
        func setupParticles() {
            particles = .init( device:device, count:maxParticleCount )
            
            for i in 0 ..< maxParticleCount {
                let p = particles!.memory!.advanced( by: i )
                
                p.pointee.p1 = .init( pos:.init( -0.5, -0.5, 0.0, 1.0 ), texUV:.init( 0.0, 0.0 ) )
                p.pointee.p2 = .init( pos:.init(  0.5, -0.5, 0.0, 1.0 ), texUV:.init( 1.0, 0.0 ) )
                p.pointee.p3 = .init( pos:.init( -0.5,  0.5, 0.0, 1.0 ), texUV:.init( 0.0, 1.0 ) )
                p.pointee.p4 = .init( pos:.init(  0.5,  0.5, 0.0, 1.0 ), texUV:.init( 1.0, 1.0 ) )
            }
            
            particles?.update()
        }
        
        func setupStatus() {
            statuses = .init( device:device, count:maxParticleCount )
            
            statuses?.update { acc in
                for i in 0 ..< maxParticleCount {
                    acc[i] = .init( scale:.init( 4.0, 4.0 ), color:.init( 0.0, 0.0, 1.0, 0.5 ) )
                }
            }
        }
        
        func setupModelMatrix() {
            modelMatrices = .init( device:device, count:maxParticleCount )
            
            modelMatrices?.update { acc in
                for i in 0 ..< maxParticleCount {
                    let x = (i / 16).f * 5.0 - 40.0
                    let z = (i % 16).f * 5.0 - 40.0
                    
                    acc[i] = .translate( x, 0, z )
                }
            }
        }
        
    }
}
