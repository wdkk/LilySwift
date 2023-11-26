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
import MetalKit
import LilySwift

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
            me
            .rect( vc.rect )
            
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
            renderFlow:renderFlow!
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
