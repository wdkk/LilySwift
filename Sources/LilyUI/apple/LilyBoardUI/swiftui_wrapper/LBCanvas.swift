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

public struct LBCanvas : UIViewControllerRepresentable {
    public typealias UIViewControllerType = LBViewController
    
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
    
    public func makeUIViewController(context: Context) -> LBViewController {
        let vc = LBViewController()
        vc.buildupHandler = design
        vc.loopHandler = update
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: LBViewController, context: Context) {
        uiViewController.buildupBoard()
    }
}

#elseif os(macOS)

import SwiftUI
import AppKit

public struct LBCanvas : NSViewControllerRepresentable {
    public typealias NSViewControllerType = LBViewController
    
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
    
    public func makeNSViewController(context: Context) -> LBViewController {
        let vc = LBViewController()
        vc.buildupHandler = design
        vc.loopHandler = update
        return vc
    }
    
    public func updateNSViewController(_ nsViewController: LBViewController, context: Context) {
        nsViewController.buildupBoard()
    }
}

#endif
