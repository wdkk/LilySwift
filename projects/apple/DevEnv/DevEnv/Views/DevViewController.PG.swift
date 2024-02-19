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
import LilySwift

typealias PG = Lily.Stage.Playground
typealias PGScreen = PG.PGScreen

typealias PlaneStorage = PG.Plane.PlaneStorage
typealias PGSctor = PG.Plane.PGActor
typealias PGRectangle = PG.Plane.PGRectangle
typealias PGAddRectangle = PG.Plane.PGAddRectangle
typealias PGSubRectangle = PG.Plane.PGSubRectangle
typealias PGTriangle = PG.Plane.PGTriangle
typealias PGAddTriangle = PG.Plane.PGAddTriangle
typealias PGSubTriangle = PG.Plane.PGSubTriangle
typealias PGCircle = PG.Plane.PGCircle
typealias PGAddCircle = PG.Plane.PGAddCircle
typealias PGSubCircle = PG.Plane.PGSubCircle
typealias PGBlurryCircle = PG.Plane.PGBlurryCircle
typealias PGAddBlurryCircle = PG.Plane.PGAddBlurryCircle
typealias PGSubBlurryCircle = PG.Plane.PGSubBlurryCircle
typealias PGPicture = PG.Plane.PGPicture
typealias PGAddPicture = PG.Plane.PGAddPicture
typealias PGSubPicture = PG.Plane.PGSubPicture
typealias PGMask = PG.Plane.PGMask
typealias PGAddMask = PG.Plane.PGAddMask
typealias PGSubMask = PG.Plane.PGSubMask

typealias BBStorage = PG.Billboard.BBStorage
typealias BBPool = PG.Billboard.BBPool
typealias BBActor = PG.Billboard.BBActor
typealias BBRectangle = PG.Billboard.BBRectangle
typealias BBAddRectangle = PG.Billboard.BBAddRectangle
typealias BBSubRectangle = PG.Billboard.BBSubRectangle
typealias BBTriangle = PG.Billboard.BBTriangle
typealias BBAddTriangle = PG.Billboard.BBAddTriangle
typealias BBSubTriangle = PG.Billboard.BBSubTriangle
typealias BBCircle = PG.Billboard.BBCircle
typealias BBAddCircle = PG.Billboard.BBAddCircle
typealias BBSubCircle = PG.Billboard.BBSubCircle
typealias BBBlurryCircle = PG.Billboard.BBBlurryCircle
typealias BBAddBlurryCircle = PG.Billboard.BBAddBlurryCircle
typealias BBSubBlurryCircle = PG.Billboard.BBSubBlurryCircle
typealias BBPicture = PG.Billboard.BBPicture
typealias BBAddPicture = PG.Billboard.BBAddPicture
typealias BBSubPicture = PG.Billboard.BBSubPicture
typealias BBMask = PG.Billboard.BBMask
typealias BBAddMask = PG.Billboard.BBAddMask
typealias BBSubMask = PG.Billboard.BBSubMask

typealias ModelStorage = PG.Model.ModelStorage
typealias ModelObj = PG.Model.ModelObj

class DevViewController 
: Lily.View.ViewController
{
    lazy var device = MTLCreateSystemDefaultDevice()!

    var pgScreen:PGScreen?
        
    lazy var planeStorage:PlaneStorage = .init(
        device: device,
        capacity: 2000, 
        textures: ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star", "star" ]
    )

    lazy var bbStorage:BBStorage = .init(
        device: device,
        capacity: 2000,
        textures: ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"]
    )

    lazy var modelStorage:ModelStorage = .init(
        device: device,
        modelCapacity: 500,
        modelAssets: [ "cottonwood1", "acacia1", "plane" ] 
    )
    
    lazy var planeStorage2:PlaneStorage = .init(
        device: device,
        capacity: 2000, 
        textures: [ "mask-smoke" ]
    )
    
    override func setup() {
        super.setup()
        
        pgScreen = PGScreen(
            device:device,
            environment:.string,
            planeStorage:planeStorage,
            bbStorage:bbStorage,
            modelStorage:modelStorage
        )
        
        pgScreen?.pgDesignHandler = design
        pgScreen?.pgUpdateHandler = update
        
        self.addSubview( pgScreen!.view )
    }
    
    override func buildup() {
        super.buildup()
        pgScreen?.rect = self.rect
    }
    
    #if os(macOS)
    #else
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded( touches, with:event )
        
        pgScreen?.changeStorages(
            planeStorage:planeStorage2,
            design:design2(screen:),
            update:update2(screen:)
        )
    }
    #endif
}

func design( screen:PGScreen ) {
    screen.clearColor = .clear //.darkGrey

    screen.cubeMap = "skyCubeMap"
    
    for _ in 0 ..< 10 {
        let size = (40.0 ... 80.0).randomize
        let speed = size / 80.0
        let c = LLColor( 1.0, 0.8, 0.25, Float( speed ) )
        
        PGAddMask( "mask-star" )
        .color( c )
        .position( 
            cx:(screen.minX-200...screen.maxX+200).randomize,
            cy:(screen.minY...screen.maxY).randomize
        )
        .deltaPosition( 
            dx:(10.0 ... 12.0).randomize * speed,
            dy:(-1.5 ... 3.5).randomize * speed
        )
        .scale( square:size )
        .angle( .random )
        .deltaAngle( degrees:-4.0 * speed )
        .iterate {
            $0.deltaPosition.y -= 0.05
                        
            if Float( screen.maxX + 200.0 ) <= $0.position.x {
                $0
                .position( 
                    cx:screen.minX-200,
                    cy:(screen.minY...screen.maxY).randomize
                )
                .deltaPosition( 
                    dx:(10.0 ... 12.0).randomize * speed,
                    dy:(-1.5 ... 3.5).randomize * speed
                )
            }
        }    
        .interval( sec:0.05 ) {
            PGAddCircle()
            .color( c )
            .position( $0.position )
            .scale( square:0 )
            .deltaScale( dw:0.5 * speed, dh:0.5 * speed )
            .alpha( 0 )
            .deltaLife( -0.02 )
            .iterate {
                $0.alpha( sin( $0.life * Float.pi ) * 0.5 )
            }
        }
    }
    
    PGAddCircle()
    .scale( square:50 )
    .position( cx: screen.minX + 50, cy: screen.minY + 50 ) 
    .color( .red )
    .zIndex( 1 )

    PGAddCircle()
    .scale( square:50 )
    .position( cx: screen.maxX - 50, cy: screen.minY + 50 ) 
    .color( .blue )
    .zIndex( 2 )

    PGCircle()
    .scale( square:50 )
    .position( cx: screen.minX + 50, cy: screen.maxY - 50 ) 
    .color( .red )

    PGCircle()
    .scale( square:50 )
    .position( cx: screen.maxX - 50, cy: screen.maxY - 50 ) 
    .color( .blue )
    
    // Playground
    
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
}
 
func update( screen:PGScreen ) {
 
}

func design2( screen:PGScreen ) {
    screen.clearColor = .darkGray 
    
    for _ in 0 ..< 160 {
       PGAddMask( "mask-smoke" )
       .color( LLColor( 0.9, 0.34, 0.22, 1.0 ) )
       .position(
           cx:(-50 ... 50).randomize,
           cy:(-120 ... -110).randomize
       )
       .deltaPosition( 
           dx:(-1.0...1.0).randomize,
           dy:(0.5...4.5).randomize 
       )
       .scale( square: 80.0 )
       .deltaScale( dw: 0.5, dh: 0.5 )
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
               cx:(-50 ... 50).randomize,
               cy:(-120 ... -110).randomize 
           )
           .scale( square: 80.0 )
           .life( 1.0 )
       }
    }
}

func update2( screen:PGScreen ) {
    for touch in screen.touches {
        for _ in 0 ..< 8 {
            let speed = (2.0...4.0).randomize
            let rad  = (0.0...2.0 * Double.pi).randomize
            
            PGAddBlurryCircle()
            .color( LLColor( 0.4, 0.6, 0.95, 1.0 ) )
            .position( touch.xy )
            .deltaPosition( 
                dx: speed * cos( rad ),
                dy: speed * sin( rad ) 
            )
            .scale(
                width:(5.0...40.0).randomize,
                height:(5.0...40.0).randomize
            )
            .angle( .random )
            .deltaAngle( degrees: (-2.0...2.0).randomize )
            .life( 1.0 )
            .deltaLife( -0.016 )
            .alpha( 1.0 )
            .deltaAlpha( -0.016 )
        }
    }
}

/*
func design( screen:PGScreen ) {
    screen.clearColor = .darkGrey
}

func update( screen:PGScreen ) {
    for touch in screen.touches {
        for _ in 0 ..< 8 {
            let speed = (2.0...4.0).randomize
            let rad  = (0.0...2.0 * Double.pi).randomize
            
            PGAddBlurryCircle()
            .color( LLColor( 0.4, 0.6, 0.95, 1.0 ) )
            .position( touch.xy )
            .deltaPosition( 
                dx: speed * cos( rad ),
                dy: speed * sin( rad ) 
            )
            .scale(
                width:(5.0...40.0).randomize,
                height:(5.0...40.0).randomize
            )
            .angle( .random )
            .deltaAngle( degrees: (-2.0...2.0).randomize )
            .life( 1.0 )
            .deltaLife( -0.016 )
            .alpha( 1.0 )
            .deltaAlpha( -0.016 )
        }
    }    
}
*/
