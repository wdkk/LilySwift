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
            textures: ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"]
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        buildupHandler = design
        //loopHandler = update
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

/*
class DevViewController 
: Lily.Stage.Playground2D.PGScreen
{
    public let pg2d = Lily.Stage.Playground2D()
    override func setup() {
        super.setup()
        buildupHandler = pg2d.design
        loopHandler = pg2d.update
    }
}

extension Lily.Stage.Playground2D
{
    /// パーティクルのセットアップ
    /*
    func design() {
        PGScreen.clearColor = .darkGrey
        
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
    */
    
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
}
*/

/*
class DevViewController
: Lily.View.ViewController
{
    lazy var device:MTLDevice? = MTLCreateSystemDefaultDevice()
    
    /// Views    
    lazy var mv = Lily.View.MetalView( device:device! )
    .setup( caller:self ) { me, vc in
            
    }
    .buildup( caller:self ) { me, vc in
        CATransaction.stop {
            me.rect( vc.rect )
            vc.renderEngine?.changeScreenSize( size:me.scaledBounds.size )
        }
    }
    .draw( caller:self ) { me, vc, status in
        vc.changeCameraStatus()
        
        vc.renderEngine?.update(
            with:status.drawable,
            renderPassDescriptor:status.renderPassDesc,
            completion: { commandBuffer in
                //commandBuffer?.waitUntilCompleted() 
            }
        ) 
    }

    var renderEngine:Lily.Stage.StandardRenderEngine?
    
    //var renderFlow:DevEnv.RenderFlow?
    var renderFlow:Lily.Stage.Playground2D.RenderFlow?
    
    var mouseDrag = LLFloatv2()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        addSubview( mv )
        
        setupKeyInput()
        
        renderFlow = .init( device:device!, viewCount:1 )
        
        renderEngine = .init( 
            device:device!,
            size:CGSize( 320, 240 ),
            renderFlow:renderFlow!,
            buffersInFlight:3
        )

        startLooping()
    }
    
    override func loop() {
        super.loop()
        mv.drawMetal()
    }
    
    override func teardown() {
        endLooping()
    }
 
    func setupKeyInput() {
        #if os(macOS)
        let options:NSTrackingArea.Options = [.activeAlways, .inVisibleRect, .mouseEnteredAndExited, .mouseMoved]
        let area = NSTrackingArea( rect:mv.bounds, options:options, owner: self, userInfo: nil )
        self.view.addTrackingArea( area )
        #endif
    }
 
    #if os(macOS)
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        mouseDrag.x = event.deltaX.f
        mouseDrag.y = event.deltaY.f
    }
    
    override func rightMouseDragged(with event: NSEvent) {
        super.rightMouseDragged(with: event)
        mouseDrag.x = event.deltaX.f
        mouseDrag.y = event.deltaY.f
    }

    /*    
    override func mouseExited(with event: NSEvent) { renderEngine?.cursorPosition = LLFloatv2( -1, -1 ) }
    
    override func rightMouseDown(with event: NSEvent) { renderEngine?.mouseButtonMask |= 0x2 }
    
    override func rightMouseUp(with event: NSEvent) { renderEngine?.mouseButtonMask &= ~0x2 }
    
    override func mouseDown(with event: NSEvent) { renderEngine?.mouseButtonMask |= 0x1 }
    
    override func mouseUp(with event: NSEvent) { renderEngine?.mouseButtonMask &= ~0x1 }
    */
    
    override func mouseMoved(with event: NSEvent) {
        //let pos_x = event.locationInWindow.x.f
        //let pos_y = mv.rect.height.f - event.locationInWindow.y.f
        //renderEngine?.cursorPosition = LLFloatv2( pos_x, pos_y )
    }
    
    #else    
    override func touchesMoved( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesMoved( touches, with:event )
        let l0 = touches.first!.previousLocation( in:mv )
        let l1 = touches.first!.location( in:mv )
        mouseDrag = LLFloatv2( (l1.x - l0.x).f, (l1.y - l0.y).f )
    }
    #endif
    
    func changeCameraStatus() {
        renderEngine?.camera.rotate( on:LLFloatv3( 0, 1, 0 ), radians: mouseDrag.x * 0.02 )
        renderEngine?.camera.rotate( on:renderEngine!.camera.left, radians: mouseDrag.y * 0.02 )
        mouseDrag = .zero
    }
}
 
*/
