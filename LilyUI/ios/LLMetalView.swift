//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS)

import Metal
import QuartzCore

open class LLMetalView : LLViewBase
{
    /// Metalレイヤー
    public private(set) lazy var metalLayer = CAMetalLayer()
    public private(set) var lastDrawable:CAMetalDrawable?

    open override var bounds:CGRect {
        didSet { metalLayer.frame = self.bounds }
    }
    
    open override var frame:CGRect { 
        didSet { metalLayer.frame = self.bounds }
    }
    
    open override func postSetup() {
        super.postSetup()
        setupMetal()
    }

    /// Metalの初期化 / Metal Layerの準備
    private func setupMetal() {
        metalLayer.device = LLMetalManager.device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = false
        metalLayer.frame = self.bounds
        metalLayer.contentsScale = LLSystem.retinaScale.cgf
        self.layer.addSublayer( metalLayer )
    }
    
    open var drawable:CAMetalDrawable? {
        if metalLayer.bounds.width < 1 || metalLayer.bounds.height < 1 { return nil }
        lastDrawable = metalLayer.nextDrawable()
        return lastDrawable
    }
}

#endif
