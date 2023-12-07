//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import Metal
import SwiftUI

extension Lily.Stage.Playground2D
{
    #if os(iOS) || os(visionOS)
    public struct PGScreenView : UIViewControllerRepresentable
    {
        var device:MTLDevice
        public var design:(( PGScreen )->Void)?
        public var update:(( PGScreen )->Void)?
        
        public init( 
            device:MTLDevice,
            design:(( PGScreen )->Void)? = nil,
            update:(( PGScreen )->Void)? = nil )
        {
            self.device = device
            self.design = design
            self.update = update
        }
        
        public func makeUIViewController( context:Context ) -> PGScreen {
            var screen = PGScreen( device:device )
            screen.buildupHandler = self.design
            screen.loopHandler = self.update
            return screen
        }
        
        public func updateUIViewController( _ uiViewController:PGScreen, context:Context ) {
            uiViewController.rebuild()
        }
    }
    #elseif os(macOS)
    public struct PGScreenView : NSViewControllerRepresentable
    {
        var device:MTLDevice
        public var design:(( PGScreen )->Void)?
        public var update:(( PGScreen )->Void)?
        
        public init( 
            device:MTLDevice,
            design:(( PGScreen )->Void)? = nil,
            update:(( PGScreen )->Void)? = nil )
        {
            self.device = device
            self.design = design
            self.update = update
        }
        
        public func makeNSViewController( context:Context ) -> PGScreen {
            var screen = PGScreen( device:device )
            screen.buildupHandler = self.design
            screen.loopHandler = self.update
            return screen
        }
        
        public func updateNSViewController( _ nsViewController:PGScreen, context: Context ) {
            nsViewController.rebuild()
        }
    }
    #endif
}
