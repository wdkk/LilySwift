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
import SwiftUI

extension Lily.Stage.Playground
{
    public struct PGScene
    {
        public var planeStorage:Plane.PlaneStorage?
        public var bbStorage:Billboard.BBStorage?
        public var modelStorage:Model.ModelStorage?

        public var design:(( PGScreen )->Void)?
        public var update:(( PGScreen )->Void)?
        public var resize:(( PGScreen )->Void)?
        
        public init(
            planeStorage: Plane.PlaneStorage? = nil,
            bbStorage: Billboard.BBStorage? = nil,
            modelStorage: Model.ModelStorage? = nil,
            design:((PGScreen) -> Void)? = nil,
            update:((PGScreen) -> Void)? = nil,
            resize:((PGScreen) -> Void)? = nil
        ) 
        {
            self.planeStorage = planeStorage
            self.bbStorage = bbStorage
            self.modelStorage = modelStorage
            self.design = design
            self.update = update
            self.resize = resize
        }
        
        public static func playgroundDefault(
            device:MTLDevice,
            design:((PGScreen) -> Void)? = nil,
            update:((PGScreen) -> Void)? = nil,
            resize:((PGScreen) -> Void)? = nil
        ) 
        -> PGScene 
        {
            return .init(
                planeStorage:.playgroundDefault( device:device ),
                bbStorage:.playgroundDefault( device:device ),
                modelStorage:.playgroundDefault( device:device ),
                design:design,
                update:update,
                resize:resize
            )
        }
    }
}
