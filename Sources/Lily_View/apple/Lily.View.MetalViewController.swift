//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import SwiftUI
import Metal

extension Lily.View
{
    open class MetalViewController : ViewController
    {
        var device:MTLDevice?
        public var setupHandler:(( Lily.View.MetalView, MetalViewController )->())?
        public var buildupHandler:(( Lily.View.MetalView, MetalViewController )->())?
        public var drawHandler:(( Lily.View.MetalView, MetalViewController, MTLDrawable, MTLRenderPassDescriptor )->())?
        
        /// Views    
        public lazy var mv = Lily.View.MetalView( device:device! )
        .setup( caller:self ) { me, vc in
            vc.setupHandler?( me, vc )
        }
        .buildup( caller:self ) { me, vc in
            CATransaction.stop {
                me.rect( vc.view.bounds )
                vc.buildupHandler?( me, vc )
            }
        }
        .draw( caller:self ) { me, vc, status in
            vc.drawHandler?( me, vc, status.drawable, status.renderPassDesc )
        }
        
        public init( device:MTLDevice? ) {
            self.device = device
            super.init()
        }
        
        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func setup() {
            super.setup()
            addSubview( mv )
            startLooping()
        }
        
        public override func loop() {
            super.loop()
            mv.drawMetal()
        }
        
        public override func teardown() {
            endLooping()
        }
    }
}
