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
typealias PGScreen = PG2D.PGScreen
typealias PGPool = PG2D.PGPool
typealias PGSctor = PG2D.PGActor
typealias PGRectangle = PG2D.PGRectangle
typealias PGAddRectangle = PG2D.PGAddRectangle
typealias PGSubRectangle = PG2D.PGSubRectangle
typealias PGTriangle = PG2D.PGTriangle
typealias PGAddTriangle = PG2D.PGAddTriangle
typealias PGSubTriangle = PG2D.PGSubTriangle
typealias PGCircle = PG2D.PGCircle
typealias PGAddCircle = PG2D.PGAddCircle
typealias PGSubCircle = PG2D.PGSubCircle
typealias PGBlurryCircle = PG2D.PGBlurryCircle
typealias PGAddBlurryCircle = PG2D.PGAddBlurryCircle
typealias PGSubBlurryCircle = PG2D.PGSubBlurryCircle
typealias PGPicture = PG2D.PGPicture
typealias PGAddPicture = PG2D.PGAddPicture
typealias PGSubPicture = PG2D.PGSubPicture
typealias PGMask = PG2D.PGMask
typealias PGAddMask = PG2D.PGAddMask
typealias PGSubMask = PG2D.PGSubMask

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
        buildupHandler = design
        loopHandler = update
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
