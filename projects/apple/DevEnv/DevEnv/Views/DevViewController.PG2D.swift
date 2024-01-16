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

typealias PG2D = Lily.Stage.Playground2D
typealias Plane = PG2D.Plane
typealias PGScreen = PG2D.PGScreen

typealias PGSctor = Plane.PGActor
typealias PGRectangle = Plane.PGRectangle
typealias PGAddRectangle = Plane.PGAddRectangle
typealias PGSubRectangle = Plane.PGSubRectangle
typealias PGTriangle = Plane.PGTriangle
typealias PGAddTriangle = Plane.PGAddTriangle
typealias PGSubTriangle = Plane.PGSubTriangle
typealias PGCircle = Plane.PGCircle
typealias PGAddCircle = Plane.PGAddCircle
typealias PGSubCircle = Plane.PGSubCircle
typealias PGBlurryCircle = Plane.PGBlurryCircle
typealias PGAddBlurryCircle = Plane.PGAddBlurryCircle
typealias PGSubBlurryCircle = Plane.PGSubBlurryCircle
typealias PGPicture = Plane.PGPicture
typealias PGAddPicture = Plane.PGAddPicture
typealias PGSubPicture = Plane.PGSubPicture
typealias PGMask = Plane.PGMask
typealias PGAddMask = Plane.PGAddMask
typealias PGSubMask = Plane.PGSubMask

class DevViewController 
: PGScreen
{
    var device:MTLDevice!
    
    init() {
        self.device = MTLCreateSystemDefaultDevice()
        super.init( 
            device:device,
            environment:.string,
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

func design( screen:PGScreen ) {
    screen.clearColor = .darkGrey
     
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
 
func update( screen:PGScreen ) {
 
}
*/

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
