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
            particleCapacity:1000,
            modelCapacity:100,
            textures: ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"],
            modelAssets: [ "plane", "acacia1", "cottonwood1", "palmtree1" ]
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
    /*
    for iid in 0 ..< 81 * stage.modelRenderFlow.storage.cameraCount {
        let idx = iid / stage.modelRenderFlow.storage.cameraCount
        let x = idx / 9
        let z = idx % 9
        
        ModelObj( assetName:"acacia1" )
        .position( cx:40.0 - 10.0 * x.f, cy:2.0, cz:40.0 - 10.0 * z.f )
        .scale( equal:8.0 )
    }
    
    for _ in 0 ..< stage.modelRenderFlow.storage.cameraCount {
        ModelObj( assetName:"cottonwood1" )
        .position( cx:0.0, cy:2.0, cz:60.0 )
        .scale( equal:8.0 )
        
        ModelObj( assetName:"plane" ) 
        .position( cx:-25.0, cy:-10.0, cz:-25.0 )
        .scale( equal:100.0 )
    }
    */
    
    ModelObj( assetName:"cottonwood1" )
    .position( cx:-500.0, cy:0.0, cz:0.0 )
    .scale( x: 400, y: 400, z: 400 )
    
    ModelObj( assetName:"cottonwood1" )
    .position( cx:500.0, cy:0.0, cz:0.0 )
    .scale( x: 800, y: 800, z: 800 )
    
    ModelObj( assetName:"acacia1" )
    .position( cx:0.0, cy:0.0, cz:1000.0 )
    .scale( x: 300, y: 300, z:300 )
    
    ModelObj( assetName:"plane" ) 
    .position( cx:0.0, cy:0.0, cz:0.0 )
    .scale( equal:20000.0 )
    
    for _ in 0 ..< 160 {
        BBAddBlurryCircle()
        .color( LLColor( 0.25, 0.8, 1.0, 1.0 ) )
        .position(
            cx:(-2000.0 ... 2000.0).randomize,
            cy:(0.0 ... 0.0).randomize,
            cz:(-2000.0 ... 2000.0).randomize
        )
        .deltaPosition( 
            dx:(-1...1).randomize,
            dy:(5...10).randomize,
            dz:(-1...1).randomize
        )
        .scale( square: 100.0 )
        .life( .random )
        .deltaLife( -0.005 )
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
                cx:(-2000.0 ... 2000.0).randomize,
                cy:(0.0 ... 0.0).randomize,
                cz:(-2000.0 ... 2000.0).randomize
            )
            .scale( square: 100.0 )
            .life( 1.0 )
        }
    }
    
    /*
    for _ in 0 ..< 320 {
        BBAddMask( "mask-smoke" )
        .color( LLColor( 0.9, 0.34, 0.22, 1.0 ) )
        .position(
            cx:(-500.0 ... 500.0).randomize,
            cy:(0.0 ... 40.0).randomize,
            cz:(-500.0 ... 500.0).randomize
        )
        .deltaPosition( 
            dx:(-1...1).randomize,
            dy:(5...20).randomize,
            dz:(-1...1).randomize
        )
        .scale( square: 200.0 )
        .deltaScale( dw: 10.0, dh: 10.0 )
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
                cx:(-500.0 ... 500.0).randomize,
                cy:(0.0 ... 40.0).randomize,
                cz:(-500.0 ... 500.0).randomize
            )
            .scale( square: 200.0 )
            .life( 1.0 )
        }
    }
    */
}

func update( stage:PGStage ) {

}
