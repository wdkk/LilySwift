//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import Metal
import QuartzCore

open class LLMetalView : LLView
{
    /// Metalレイヤー
    public private(set) lazy var metalLayer = CAMetalLayer()
    public private(set) var lastDrawable:CAMetalDrawable?
    public private(set) var ready:Bool = false

    open override var bounds:CGRect {
        didSet { 
            metalLayer.frame = self.bounds 
        }
    }
    
    open override var frame:CGRect { 
        didSet { 
            metalLayer.frame = self.bounds 
        }
    }
    
    open override func postSetup() {
        super.postSetup()
        setupMetal()
    }

    /// Metalの初期化 / Metal Layerの準備
    open func setupMetal() {
        self.addSublayer( metalLayer )
        metalLayer.device = LLMetalManager.shared.device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = false
        metalLayer.frame = self.bounds
        metalLayer.contentsScale = LLSystem.retinaScale.cgf
        self.ready = true
    }
    
    open var drawable:CAMetalDrawable? {
        if metalLayer.bounds.width < 1 || metalLayer.bounds.height < 1 { return nil }
        lastDrawable = metalLayer.nextDrawable()
        return lastDrawable
    }
}
#endif
