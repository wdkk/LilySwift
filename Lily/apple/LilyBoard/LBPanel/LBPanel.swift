//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

open class LBPanel : LBActor
{
    public typealias TDecoration = LBPanelDecoration
    public weak var decoration:TDecoration?
    
    public private(set) var index:Int
    private var _storage:LBPanelStorage
    
    public init( decoration deco:TDecoration ) {
        // makeされていなかった場合を考慮してここでmakeする
        deco.make()
        
        self.index = deco.storage.request()
        self._storage = deco.storage
        decoration = deco
    }
    
    deinit {
        params.state = .trush
    }

    public var vertice:LLQuad<LBPanelVertex> {
        get { return _storage.quads.vertice[index] }
        set { withUnsafeMutablePointer(to: &(_storage.quads.vertice[index]) ) { $0.pointee = newValue } }
    }
    
    public var params:LBPanelParam {
        get { return _storage.params[index] }
        set { withUnsafeMutablePointer(to: &(_storage.params[index]) ) { $0.pointee = newValue } }
    }
    
    public override var p1:LLPointFloat { 
        get { return LLPointFloat( vertice.p1.xy.x, vertice.p1.xy.y ) }
        set { vertice.p1.xy = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var p2:LLPointFloat { 
        get { return LLPointFloat( vertice.p2.xy.x, vertice.p2.xy.y ) }
        set { vertice.p2.xy = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    public override var p3:LLPointFloat { 
        get { return LLPointFloat( vertice.p3.xy.x, vertice.p3.xy.y ) }
        set { vertice.p3.xy = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var p4:LLPointFloat { 
        get { return LLPointFloat( vertice.p4.xy.x, vertice.p4.xy.y ) }
        set { vertice.p4.xy = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var uv1:LLPointFloat { 
        get { return LLPointFloat( vertice.p1.tex_uv.u, vertice.p1.tex_uv.v ) }
        set { vertice.p1.tex_uv = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var uv2:LLPointFloat { 
        get { return LLPointFloat( vertice.p2.tex_uv.u, vertice.p2.tex_uv.v ) }
        set { vertice.p2.tex_uv = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var uv3:LLPointFloat { 
        get { return LLPointFloat( vertice.p3.tex_uv.u, vertice.p3.tex_uv.v ) }
        set { vertice.p3.tex_uv = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var uv4:LLPointFloat { 
        get { return LLPointFloat( vertice.p4.tex_uv.u, vertice.p4.tex_uv.v ) }
        set { vertice.p4.tex_uv = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var position:LLPointFloat { 
        get { return LLPointFloat( params.position.x, params.position.y ) }
        set { params.position = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var cx:LLFloat {
        get { return params.position.x }
        set { params.position.x = newValue }
    }

    public override var cy:LLFloat {
        get { return params.position.y }
        set { params.position.y = newValue }
    }
    
    public override var scale:LLSizeFloat {
        get { return LLSizeFloat( params.scale.x, params.scale.y ) }
        set { params.scale = LLFloatv2( newValue.width, newValue.height ) }
    }

    public override var width:Float {
        get { return params.scale.x }
        set { params.scale.x = newValue }
    }
    
    public override var height:Float {
        get { return params.scale.y }
        set { params.scale.y = newValue }
    }
    
    public override var angle:LLAngle {
        get { return LLAngle.radians( params.angle.d ) }
        set { params.angle = newValue.radians.f }
    }
    
    public override var zIndex:LLFloat {
        get { return params.zindex }
        set { params.zindex = newValue }
    }

    public override var enabled:Bool { 
        get { return params.enabled }
        set { params.enabled = newValue }
    }

    public override var life:Float { 
        get { return params.life }
        set { params.life = newValue }
    }

    public override var color:LLColor {
        get { return params.color.llColor }
        set { params.color = newValue.floatv4 }
    }

   public override var alpha:Float {
        get { return params.color.w }
        set { params.color.w = newValue }
    }

    public override var matrix:LLMatrix4x4 { 
        get { return params.matrix }
        set { params.matrix = newValue }
    }
    
    public override var deltaPosition:LLPointFloat { 
        get { return LLPointFloat( params.deltaPosition.x, params.deltaPosition.y ) }
        set { params.deltaPosition = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    public override var deltaScale:LLSizeFloat { 
        get { return LLSizeFloat( params.deltaScale.x, params.deltaScale.y ) }
        set { params.deltaScale = LLFloatv2( newValue.width, newValue.height ) }
    }

    public override var deltaColor:LLColor { 
        get { return LLColor( 
                params.deltaColor.x,
                params.deltaColor.y,
                params.deltaColor.z,
                params.deltaColor.w )
        }
        set { params.deltaColor = LLFloatv4( newValue.R, newValue.G, newValue.B, newValue.A ) }
    }

    public override var deltaAlpha:Float {
        get { return params.deltaColor.w }
        set { params.deltaColor.w = newValue }
    }

    public override var deltaAngle:LLAngle {
        get { return LLAngle.radians( params.deltaAngle.d ) }
        set { params.deltaAngle = newValue.radians.f }
    }

    public override var deltaLife:Float {
        get { return params.deltaLife }
        set { params.deltaLife = newValue }
    }

    @discardableResult
    public override func atlasParts( of key:String ) -> Self {
        guard let parts = _storage.atlas?.parts( key ),
              let reg = parts.region 
        else {
            LLLog( "アトラスが設定されていないか,指定が正しくないため無効です:\(key)" )
            params.atlasUV = LLFloatv4( 0.0, 0.0, 1.0, 1.0 )
            vertice.p1.tex_uv = .zero
            vertice.p2.tex_uv = .zero
            vertice.p3.tex_uv = .zero
            vertice.p4.tex_uv = .zero
            return self
        }
        
        params.atlasUV = LLFloatv4( reg.left.f, reg.top.f, reg.right.f, reg.bottom.f )
        vertice.p1.tex_uv = LLFloatv2( 0.0, 0.0 ) 
        vertice.p2.tex_uv = LLFloatv2( 1.0, 0.0 ) 
        vertice.p3.tex_uv = LLFloatv2( 0.0, 1.0 ) 
        vertice.p4.tex_uv = LLFloatv2( 1.0, 1.0 ) 
            
        return self
    }    

    @discardableResult
    public override func texture( _ tex:MTLTexture? ) -> Self {
        guard let tex = tex else {
            self._storage.texture = nil
            params.atlasUV = LLFloatv4( 0.0, 0.0, 1.0, 1.0 );
            vertice.p1.tex_uv = .zero
            vertice.p2.tex_uv = .zero
            vertice.p3.tex_uv = .zero
            vertice.p4.tex_uv = .zero
            return self
        }
        
        self._storage.texture = tex
        params.atlasUV = LLFloatv4( 0.0, 0.0, 1.0, 1.0 );
        vertice.p1.tex_uv = LLFloatv2( 0.0, 0.0 ) 
        vertice.p2.tex_uv = LLFloatv2( 1.0, 0.0 ) 
        vertice.p3.tex_uv = LLFloatv2( 0.0, 1.0 ) 
        vertice.p4.tex_uv = LLFloatv2( 1.0, 1.0 ) 
        
        return self
    } 

    @discardableResult
    public override func texture( _ tex:LLMetalTexture? ) -> Self {
        return texture( tex?.metalTexture )
    } 
}
