//
// CAIMMetalView.swift
// CAIM Project
//   https://kengolab.net/CreApp/wiki/
//
// Copyright (c) Watanabe-DENKI Inc.
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
        self.addSublayer( metalLayer )
    }
    
    open var drawable:CAMetalDrawable? {
        if metalLayer.bounds.width < 1 || metalLayer.bounds.height < 1 { return nil }
        return metalLayer.nextDrawable()
    }
}
#endif
