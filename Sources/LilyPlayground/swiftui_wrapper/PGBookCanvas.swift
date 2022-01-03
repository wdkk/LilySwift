//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS)

import SwiftUI
import UIKit

public struct PGBookCanvas : UIViewControllerRepresentable {
    public typealias UIViewControllerType = PGViewController
    
    public var design:(()->Void)?
    public var update:(()->Void)?
    
    public init(
        design:(()->Void)? = nil,
        update:(()->Void)? = nil
    )
    {
        self.design = design
        self.update = update
    }
    
    public func makeUIViewController(context: Context) -> PGViewController {
        let vc = PGViewController()
        vc.buildupHandler = design
        vc.loopHandler = update
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: PGViewController, context: Context) {
        uiViewController.buildupBoard()
    }
}

#elseif os(macOS)

import SwiftUI
import AppKit

public struct PGBookCanvas : NSViewControllerRepresentable {
    public typealias UIViewControllerType = PGViewController
    
    public var design:(()->Void)?
    public var update:(()->Void)?
    
    public func makeNSViewController(context: Context) -> PGViewController {
        let vc = PGViewController()
        vc.buildupHandler = design
        vc.loopHandler = update
        return vc
    }
    
    public func updateNSViewController(_ nsViewController: PGViewController, context: Context) {
        nsViewController.buildupBoard()
    }
}

#endif
