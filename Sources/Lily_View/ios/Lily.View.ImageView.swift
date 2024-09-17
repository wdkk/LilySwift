//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS) || os(tvOS) || os(visionOS)

import UIKit

extension Lily.View
{
    open class ImageView 
    : BaseView
    {
        public enum DrawStyle
        {
            case stretchFull
            case stretchFixedRatio
            case centerOriginalSize
            case centerFixed
            case positionFixed
        }
        
        nonisolated(unsafe) private var _draw_layer = CALayer()
        
        open var image:Any? {
            didSet {
                if image is UIImage { blt() }
                else if image is LLImage { blt() }
                else if image == nil { blt() }
                else { LLLog("not supported \(type(of: image))") }
            }
        }
        
        open var imageFixPosition:CGPoint = .zero { didSet { blt() } }
        
        open var imageFixSize:CGSize = CGSize( width:40, height:40 ) { didSet { blt() } }
        
        open var imageOriginalSize:CGSize {
            get {
                if image is UIImage {
                    let uiimg:UIImage = image as! UIImage
                    return uiimg.size
                }
                else if image is LLImage {
                    let llimg:LLImage = image as! LLImage
                    return CGSize( llimg.width, llimg.height )
                }
                return .zero
            }
        }
        
        open var drawStyle:DrawStyle = .stretchFull {
            didSet { blt() }
        }
        
        required public init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
        public override init() {
            super.init()
            
            _draw_layer.magnificationFilter = .trilinear
            _draw_layer.minificationFilter = .trilinear
            _draw_layer.contentsScale = LLSystem.retinaScale.cgf
            self.layer.addSublayer( _draw_layer )
        }
        
        deinit {
            _draw_layer.removeFromSuperlayer()
        }
        
        open override func buildup() {
            super.buildup()
            blt()
        }
        
        open override func draw(_ layer: CALayer, in ctx: CGContext) {
            super.draw(layer, in: ctx)
        }
        
        open func blt() {
            if image == nil {
                _draw_layer.contents = nil
            }
            else if image is UIImage {
                let uiimg:UIImage = self.image as! UIImage
                let cgimg:CGImage? = uiimg.cgImage
                
                // check CGImage
                guard let nn_cgimg = cgimg else {
                    _draw_layer.contents = nil
                    return
                }
                
                drawCGImage( nn_cgimg )
            }
            else if image is LLImage {
                let img = self.image as! LLImage
                
                // check LLImage
                if !img.available { _draw_layer.contents = nil; return }
                
                guard let nn_cgimg = img.cgImage else {
                    _draw_layer.contents = nil
                    return
                }
                
                drawCGImage( nn_cgimg )
            }
            else {
                _draw_layer.contents = nil
            }
        }
        
        private func drawCGImage(_ img:CGImage) {
            CATransaction.stop { [weak self] in
                guard let self = self else { return }
                
                // set image to layer
                self._draw_layer.contents = img
                
                if self.drawStyle == .stretchFull {
                    self._draw_layer.rect = LLRect( self.bounds )
                }
                else if self.drawStyle == .stretchFixedRatio {
                    let fr_wid = self.width.f
                    let fr_hgt = self.height.f
                    let wid = img.width.f
                    let hgt = img.height.f
                    
                    let scx = fr_wid / wid
                    let scy = fr_hgt / hgt
                    let sc = min(scx, scy)
                    
                    let swid = wid * sc
                    let shgt = hgt * sc
                    
                    let x = ((fr_wid - swid) / 2.0)
                    let y = ((fr_hgt - shgt) / 2.0)
                    
                    self._draw_layer.rect = LLRect(x, y, swid, shgt)
                }
                else if self.drawStyle == .centerOriginalSize {
                    let fr_wid = self.width.f
                    let fr_hgt = self.height.f
                    let wid = img.width.f
                    let hgt = img.height.f
                    let x = ((fr_wid - wid) / 2.0)
                    let y = ((fr_hgt - hgt) / 2.0)
                    
                    self._draw_layer.rect = LLRect(x, y, wid, hgt)
                }
                else if self.drawStyle == .centerFixed {
                    let fr_wid = self.width.f
                    let fr_hgt = self.height.f
                    let wid = self.imageFixSize.width.f
                    let hgt = self.imageFixSize.height.f
                    let x = ((fr_wid - wid) / 2.0)
                    let y = ((fr_hgt - hgt) / 2.0)
                    
                    self._draw_layer.rect = LLRect(x, y, wid, hgt)
                }
                else if self.drawStyle == .positionFixed {
                    let wid = self.imageFixSize.width.f
                    let hgt = self.imageFixSize.height.f
                    let x = self.imageFixPosition.x.f
                    let y = self.imageFixPosition.y.f
                    
                    self._draw_layer.rect = LLRect(x, y, wid, hgt)
                }
            }
        }
    }
}

#endif
