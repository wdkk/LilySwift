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

import Metal
import QuartzCore
 
open class LLMetalView : LLView
{
    /// Metalレイヤー
    @available(iOS 13.0, *)
    public private(set) lazy var metalLayer = CAMetalLayer()
    public private(set) var lastDrawable:CAMetalDrawable?

    open override var bounds:CGRect {
        didSet { 
            if #available(iOS 13.0, *) {
                metalLayer.frame = self.bounds
            } 
        }
    }
    
    open override var frame:CGRect { 
        didSet { 
            if #available(iOS 13.0, *) {
                metalLayer.frame = self.bounds
            }
        }
    }
    
    open override func preSetup() {
        // TODO: metalViewがまともに動かなくなるので.zeroに戻す
    }
    
    open override func postSetup() {
        super.postSetup()
        setupMetal()
    }

    /// Metalの初期化 / Metal Layerの準備
    private func setupMetal() {
        if #available(iOS 13.0, *) {
            metalLayer.device = LLMetalManager.shared.device
            metalLayer.pixelFormat = .bgra8Unorm
            metalLayer.framebufferOnly = false
            metalLayer.contentsScale = LLSystem.retinaScale.cgf
            metalLayer.frame = self.bounds
            self.layer.addSublayer( metalLayer )
        }
    }
    
    open var drawable:CAMetalDrawable? {
        if #available(iOS 13.0, *) {
            if metalLayer.bounds.width < 64 || metalLayer.bounds.height < 64 { return nil }
            lastDrawable = metalLayer.nextDrawable()
            return lastDrawable
        }
        else {
            return nil
        }
    }
}

#endif
