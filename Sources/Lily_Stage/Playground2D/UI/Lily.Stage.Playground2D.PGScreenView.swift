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
        @State var pgScreen:PGScreen?
 
        public init( device:MTLDevice ) {
            self.device = device
        }
        
        public func makeUIViewController( context:Context ) -> PGScreen {
            pgScreen = PGScreen( device:device )
            return pgScreen!
        }
        
        public func updateUIViewController( _ uiViewController:PGScreen, context:Context ) {
            uiViewController.rebuild()
        }
        
        public func onDesign( f:@escaping ( PGScreen )->Void ) -> Self {
            pgScreen?.buildupHandler = f
            return self
        }
        
        public func onUpdate( f:@escaping ( PGScreen )->Void ) -> Self {
            pgScreen?.loopHandler = f
            return self
        }
    }
    #elseif os(macOS)
    public struct PGScreenView : NSViewControllerRepresentable
    {
        var device:MTLDevice
        
        public init( device:MTLDevice ) {
            self.device = device
        }
        
        public func makeNSViewController( context:Context ) -> PGScreen {
            return PGScreen( device:device )
        }
        
        public func updateNSViewController( _ nsViewController:PGScreen, context: Context ) {
            nsViewController.rebuild()
        }
    }
    #endif
}
