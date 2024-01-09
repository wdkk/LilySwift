//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/*
#if os(macOS)
import AppKit
#else
import UIKit
#endif
import Metal
import LilySwift

typealias PG3D = Lily.Stage.Playground3D
typealias PGStage = PG3D.PGStage
typealias BBPool = PG3D.BBPool
typealias BBSctor = PG3D.BBActor
typealias BBRectangle = PG3D.BBRectangle
typealias BBAddRectangle = PG3D.BBAddRectangle
typealias BBSubRectangle = PG3D.BBSubRectangle
typealias BBTriangle = PG3D.BBTriangle
typealias BBAddTriangle = PG3D.BBAddTriangle
typealias BBSubTriangle = PG3D.BBSubTriangle
typealias BBCircle = PG3D.BBCircle
typealias BBAddCircle = PG3D.BBAddCircle
typealias BBSubCircle = PG3D.BBSubCircle
typealias BBBlurryCircle = PG3D.BBBlurryCircle
typealias BBAddBlurryCircle = PG3D.BBAddBlurryCircle
typealias BBSubBlurryCircle = PG3D.BBSubBlurryCircle
typealias BBPicture = PG3D.BBPicture
typealias BBAddPicture = PG3D.BBAddPicture
typealias BBSubPicture = PG3D.BBSubPicture
typealias BBMask = PG3D.BBMask
typealias BBAddMask = PG3D.BBAddMask
typealias BBSubMask = PG3D.BBSubMask

class DevViewController 
: Lily.Stage.Playground3D.PGStage
{
    var device:MTLDevice!
    
    init() {
        self.device = MTLCreateSystemDefaultDevice()
        super.init( 
            device:device,
            environment:.metallib,
            particleCapacity:10000,
            textures: ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"]
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        buildupHandler = design
        loopHandler = update
    }
}

func design( stage:PGStage ) {
    /*
    for i in 0 ..< 256 {
        let x = (i / 16).f * 5.0 - 40.0
        let z = (i % 16).f * 5.0 - 40.0
            
        BBRectangle()
        .color( LLColor( 0.9, 0.55, 0.25, 1.0 ) )
        .position(
            cx:x, cy:0, cz:z
        )
        .scale( square:4.0 )
    }
    */
    
    for _ in 0 ..< 320 {
        BBAddMask( "mask-smoke" )
        .color( LLColor( 0.9, 0.34, 0.22, 1.0 ) )
        .position(
            cx:(-10.0 ... 10.0).randomize,
            cy:(-2.0 ... 2.0).randomize,
            cz:(-10.0 ... 10.0).randomize
        )
        .deltaPosition( 
            dx:(-0.01...0.01).randomize,
            dy:(0.03...0.45).randomize,
            dz:(-0.01...0.01).randomize
        )
        .scale( square: 10.0 )
        .deltaScale( dw: 0.1, dh: 0.1 )
        .angle( .random )
        .deltaAngle( degrees:(-2.0...2.0).randomize )
        .life( .random )
        .deltaLife( -0.01 )
        .iterate {
            if $0.life < 0.5 {
               $0.alpha( $0.life )
            }
            else {
               $0.alpha( (1.0 - $0.life) )
            }
        }
        .completion {
            $0
            .position( 
                cx:(-10.0 ... 10.0).randomize,
                cy:(-2.0 ... 2.0).randomize,
                cz:(-10.0 ... 10.0).randomize
            )
            .scale( square: 10.0 )
            .life( 1.0 )
        }
    }
}

func update( stage:PGStage ) {

}
*/
