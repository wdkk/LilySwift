//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import Metal
import simd
import LilySwift

typealias PG3D = Lily.Stage.Playground3D
typealias PGStage = PG3D.PGStage

typealias Billboard = PG3D.Billboard
typealias BBPool = Billboard.BBPool
typealias BBSctor = Billboard.BBActor
typealias BBRectangle = Billboard.BBRectangle
typealias BBAddRectangle = Billboard.BBAddRectangle
typealias BBSubRectangle = Billboard.BBSubRectangle
typealias BBTriangle = Billboard.BBTriangle
typealias BBAddTriangle = Billboard.BBAddTriangle
typealias BBSubTriangle = Billboard.BBSubTriangle
typealias BBCircle = Billboard.BBCircle
typealias BBAddCircle = Billboard.BBAddCircle
typealias BBSubCircle = Billboard.BBSubCircle
typealias BBBlurryCircle = Billboard.BBBlurryCircle
typealias BBAddBlurryCircle = Billboard.BBAddBlurryCircle
typealias BBSubBlurryCircle = Billboard.BBSubBlurryCircle
typealias BBPicture = Billboard.BBPicture
typealias BBAddPicture = Billboard.BBAddPicture
typealias BBSubPicture = Billboard.BBSubPicture
typealias BBMask = Billboard.BBMask
typealias BBAddMask = Billboard.BBAddMask
typealias BBSubMask = Billboard.BBSubMask

typealias Model = PG3D.Model
typealias ModelObj = Model.ModelObj

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
        pgDesignHandler = design
        pgUpdateHandler = update
    }
}

func design( stage:PGStage ) {   
    for iid in 0 ..< 64 * stage.modelRenderFlow.storage.cameraCount {
        let idx = iid / stage.modelRenderFlow.storage.cameraCount
        let x = idx / 8
        let z = idx % 8
        
        ModelObj( assetName:"acacia1" )
        .position( cx:20.0 + -10.0 * x.f, cy:2.0, cz:20.0 + -10.0 * z.f )
        .scale( equal:8.0 )
        .angle( rx: 0, ry: 120.0 / 180.0 * Float.pi, rz: 0 )
        //.deltaAngle( rx:0, ry:0.01, rz:0 )
    }
    
    for _ in 0 ..< stage.modelRenderFlow.storage.cameraCount {
        ModelObj( assetName:"plane" ) 
        .position( cx:0.0, cy:-4.0, cz:0.0 )
        .scale( equal:100.0 )
    }
    
    /*
    for _ in 0 ..< 320 {
        BBAddMask( "mask-smoke" )
        .color( LLColor( 0.9, 0.34, 0.22, 1.0 ) )
        .position(
            cx:(-10.0 ... 10.0).randomize,
            cy:(0.0 ... 4.0).randomize,
            cz:(-10.0 ... 10.0).randomize
        )
        .deltaPosition( 
            dx:(-0.01...0.01).randomize,
            dy:(0.03...0.45).randomize,
            dz:(-0.01...0.01).randomize
        )
        .scale( square: 8.0 )
        .deltaScale( dw: 0.1, dh: 0.1 )
        .angle( .random )
        .deltaAngle( degrees:(0.0...4.0).randomize )
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
            .scale( square: 8.0 )
            .life( 1.0 )
        }
    }
    */
}

func update( stage:PGStage ) {

}

