//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

// 参考: https://blackpawn.com/texts/lightmaps/default.html
// 参考: https://tyfkda.github.io/blog/2013/10/05/texture-pakcer.html

import Metal
#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

extension Lily.Metal 
{    
    open class TextureTree
    {        
        public class ImagePosUnit
        {
            var image:LLImage?
            var label:String = ""
            var x:Int
            var y:Int
            var width:Int 
            var height:Int
            
            public init( x:Int, y:Int, width:Int, height:Int ) {
                self.x = x
                self.y = y
                self.width = width
                self.height = height
            }
        }
        
        public class Node
        {
            var unit:ImagePosUnit?
            var node_a:Node?
            var node_b:Node?
            
            public init( unit:ImagePosUnit? ) {
                self.unit = unit
            }
            
            public func insert( unit:ImagePosUnit ) -> Bool {
                if let self_unit = self.unit {
                    if unit.width > self_unit.width || unit.height > self_unit.height { return false }
                    
                    // ここで領域を埋め込む位置を上書きする(unitは参照なので、元データのx,y座標が書き変わる)
                    unit.x = self_unit.x
                    unit.y = self_unit.y
                    
                    let w = unit.width
                    let h = unit.height
                    let dw = self_unit.width - w
                    let dh = self_unit.height - h
                    
                    if dw > dh {
                        self.node_a = Node( unit: ImagePosUnit(x: self_unit.x,
                                                               y: self_unit.y + h,
                                                               width: w,
                                                               height: dh ) )
                        
                        self.node_b = Node( unit: ImagePosUnit(x: self_unit.x + w,
                                                               y: self_unit.y,
                                                               width: dw, 
                                                               height: self_unit.height ) )
                    }
                    else {
                        self.node_a = Node( unit: ImagePosUnit(x: self_unit.x + w,
                                                               y: self_unit.y,
                                                               width: dw,
                                                               height: h ) )
                        
                        self.node_b = Node( unit: ImagePosUnit(x: self_unit.x,
                                                               y: self_unit.y + h,
                                                               width: self_unit.width,
                                                               height: dh ) )   
                    }
                    self.unit = nil
                    return true
                }
                else {
                    if node_a!.insert( unit:unit ) { return true }
                    return node_b!.insert( unit:unit )
                }
            }        
        }
        
        @discardableResult
        public func pack( imageUnits:[ImagePosUnit] ) -> LLSizeInt {
            var size = calcInitialRect( imageUnits: imageUnits )
            while true {
                let root = Node( unit: ImagePosUnit( x: 0, y: 0, width: size.width, height: size.height ) )
                if insertImageToRoot( imageUnits:imageUnits, root:root ) {
                    return size
                }
                if size.width > size.height { size.height *= 2 } else { size.width *= 2 }
            }
        }
        
        private func insertImageToRoot( imageUnits:[ImagePosUnit], root:Node ) -> Bool {
            for unit in imageUnits {
                if !root.insert( unit:unit ) { return false }
            }
            return true
        }
        
        private func calcInitialRect( imageUnits:[ImagePosUnit] ) -> LLSizeInt {
            let total_pixel = calcTotalPixel( imageUnits: imageUnits )
            var w = pow2(x: sqrt( total_pixel.d ).i! ) / 2
            var h = w
            while w * h < total_pixel {
                if w > h { h *= 2 } else { w *= 2 }
            }
            return LLSizeIntMake( w, h )
        }
        
        private func calcTotalPixel( imageUnits:[ImagePosUnit] ) -> Int {
            var count:Int = 0
            for rc in imageUnits { count += (rc.image!.width * rc.image!.height) }
            return count
        }
        
        private func pow2( x:Int ) -> Int {
            var xpow2:Int = 1
            while xpow2 <= x { xpow2 *= 2 }
            return xpow2
        }
    }
    
    open class TextureAtlas
    {
        var device:MTLDevice?
        private var _dictionaries:[String:Any?] = [:]
        private var _label_positions:[String:LLRegion] = [:]
        public var metalTexture:MTLTexture?
        public private(set) var label:String
        public private(set) var width:Int32 = 0
        public private(set) var height:Int32 = 0
        
        public init( device:MTLDevice?, label:String ) {
            self.device = device
            self.label = label
        }
        
        @discardableResult
        public func add( _ label:String, _ path:String ) -> Self {
            _dictionaries[label] = path
            return self
        }
        
        @discardableResult
        public func add( _ label:String, _ img:LLImage ) -> Self {
            _dictionaries[label] = img
            return self
        }
        
#if os(iOS) || os(visionOS)
        @discardableResult
        public func add( _ label:String, _ img:UIImage ) -> Self {
            _dictionaries[label] = img
            return self
        }
#endif
        
#if os(macOS)
        @discardableResult
        public func add( _ label:String, _ img:NSImage ) -> Self {
            _dictionaries[label] = img
            return self
        }
#endif
        
        @discardableResult
        public func commit() -> Self { 
            typealias ImagePosUnit = Lily.Metal.TextureTree.ImagePosUnit
            
            var image_rects:[ImagePosUnit] = []
            
            for (key, v) in self._dictionaries {
                // nullの場合処理しない
                guard let nnv = v else { continue }
                
                // nnvの中身の種類によって登録方法を変えていく
                if nnv is String {
                    let path = nnv as! String
                    let img = LLImage( path )
                    if !img.available { continue }
                    
                    let rc = ImagePosUnit( x:0, y:0, width:img.width, height:img.height )
                    rc.image = img
                    rc.label = key
                    
                    image_rects.append( rc )
                    continue
                }
                if nnv is LLImage {
                    let img = nnv as! LLImage
                    if !img.available { continue }
                    
                    let rc = ImagePosUnit( x:0, y:0, width:img.width, height:img.height )
                    rc.image = img
                    rc.label = key
                    
                    image_rects.append( rc )
                    continue
                }
#if os(iOS) || os(visionOS)
                if nnv is UIImage {
                    let uiimg = nnv as! UIImage
                    let img = uiimg.llImage
                    if !img.available { continue }
                    
                    let rc = ImagePosUnit( x:0, y:0, width:img.width, height:img.height )
                    rc.image = img
                    rc.label = key
                    
                    image_rects.append( rc )
                    continue
                }
                // TODO: macOS向けNSImage対応
#endif
            }
            
            // ソート
            do {
                try image_rects.sort { (rc1, rc2) throws -> Bool in
                    return LLMax( rc1.width, rc1.height ) > LLMax( rc2.width, rc2.height ) 
                }
            }
            catch {
                LLLog( "ソートに失敗しました, ソートなしで処理を継続します." )
                return self
            }
            
            let tree = TextureTree()
            let all_size = tree.pack( imageUnits: image_rects )
            
            if all_size.width > 16384 || all_size.height > 16384 {
                LLLog( "テクスチャのサイズが許容量を超えました." )
            }
            
            // 全体画像
            let img_atlas = LLImage( wid:all_size.width, hgt:all_size.height, type:.rgba8 )
            
            _label_positions.removeAll()
            _dictionaries.removeAll()
            
            for imgrc in image_rects {
                guard let img = imgrc.image else { continue }
                
                let imgf = img.clone()
                imgf.convertType(to: .rgba8 )
                
                let label = imgrc.label
                let px = imgrc.x
                let py = imgrc.y
                let wid = imgf.width
                let hgt = imgf.height
                let mat = imgf.rgba8Matrix!
                let mat_atlas = img_atlas.rgba8Matrix!
                
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        mat_atlas[y + py][x + px] = mat[y][x]
                    }
                }
                
                let left  = px.d / all_size.width.d
                let top   = py.d / all_size.height.d
                let right = (px + wid).d / all_size.width.d
                let bottom = (py + hgt).d / all_size.height.d            
                
                _label_positions[label] = LLRegionMake( left, top, right, bottom )
            }
            
            self.metalTexture = Texture( device:device, llImage:img_atlas ).metalTexture
            self.width = all_size.width.i32!
            self.height = all_size.height.i32!
            
            return self
        }
        
        public func parts( _ key:String ) -> TextureAtlasParts {
            return TextureAtlasParts( 
                metalTexture: self.metalTexture,
                region: self._label_positions[key] )
        }
    }
    
    public struct TextureAtlasParts {
        var metalTexture:MTLTexture?
        var region:LLRegion?
    }
}
