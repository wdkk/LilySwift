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

open class LBPanel : LBActor<LBPanelDecoration>
{
    public private(set) var index:Int
    private var _storage:LBPanelStorage
    
    public override init( decoration:LBPanelDecoration ) {
        // makeされていなかった場合を考慮してここでmakeする
        decoration.make()
        
        self.index = decoration.storage.request()
        self._storage = decoration.storage
        super.init( decoration:decoration )
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
    
    public var deltas:LBPanelDelta {
        get { return _storage.deltas[index] }
        set { withUnsafeMutablePointer(to: &(_storage.deltas[index]) ) { $0.pointee = newValue } }
    }
}

// MARK: -
public extension LBPanel
{
    var position:LLPointFloat { 
        get { return LLPointFloat( params.position.x, params.position.y ) }
        set { params.position = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    @discardableResult
    func position( _ p:LLPointFloat ) -> Self {
        params.position = LLFloatv2( p.x, p.y )
        return self
    }
    
    @discardableResult
    func position( cx:Float, cy:Float ) -> Self {
        params.position = LLFloatv2( cx, cy )
        return self
    }
    
    @discardableResult
    func position( cx:LLFloatConvertable, cy:LLFloatConvertable ) -> Self {
        return position( cx:cx.f, cy:cy.f )
    }
    
    @discardableResult
    func position( _ calc:( LBPanel )->LLPointFloat ) -> Self {
        let pos = calc( self )
        params.position = LLFloatv2( pos.x, pos.y )
        return self
    }
}

// MARK: -
public extension LBPanel
{
    var cx:LLFloat {
        get { return params.position.x }
        set { params.position.x = newValue }
    }
    
    @discardableResult
    func cx( _ p:Float ) -> Self {
        params.position.x = p
        return self
    }
    
    @discardableResult
    func cx( _ p:LLFloatConvertable ) -> Self {
        return cx( p.f )
    }

    @discardableResult
    func cx( _ calc:( LBPanel )->LLFloat ) -> Self {
        params.position.x = calc( self )
        return self
    }
}

// MARK: -
public extension LBPanel
{
    var cy:LLFloat {
        get { return params.position.y }
        set { params.position.y = newValue }
    }
    
    @discardableResult
    func cy( _ p:Float ) -> Self {
        params.position.y = p
        return self
    }
    
    @discardableResult
    func cy( _ p:LLFloatConvertable ) -> Self {
        return cy( p.f )
    }

    @discardableResult
    func cy( _ calc:( LBPanel )->LLFloat ) -> Self {
        params.position.y = calc( self )
        return self
    }
}

// MARK: -
public extension LBPanel
{
    var scale:LLSizeFloat {
        get { return LLSizeFloat( params.scale.x, params.scale.y ) }
        set { params.scale = LLFloatv2( newValue.width, newValue.height ) }
    }
    
    @discardableResult
    func scale( _ sz:LLSizeFloat ) -> Self {
        params.scale = LLFloatv2( sz.width, sz.height )
        return self
    }
    
    @discardableResult
    func scale( width:Float, height:Float ) -> Self {
        params.scale = LLFloatv2( width, height )
        return self
    }
    
    @discardableResult
    func scale( width:LLFloatConvertable, height:LLFloatConvertable ) -> Self {
        return scale( width:width.f, height:height.f )
    }
    
    @discardableResult
    func scale( _ calc:( LBPanel )->LLSizeFloat ) -> Self {
        let sz = calc( self )
        params.scale = LLFloatv2( sz.width, sz.height )
        return self
    }
}

// MARK: -
public extension LBPanel
{
    var width:Float {
        get { return params.scale.x }
        set { params.scale.x = newValue }
    }
    
    @discardableResult
    func width( _ v:Float ) -> Self {
        params.scale.x = v
        return self
    }
    
    @discardableResult
    func width( _ v:LLFloatConvertable ) -> Self {
        return width( v.f )
    }

    @discardableResult
    func width( _ calc:( LBPanel )->Float ) -> Self {
        params.scale.x = calc( self )
        return self
    }
}

// MARK: -
public extension LBPanel
{
    var height:Float {
        get { return params.scale.y }
        set { params.scale.y = newValue }
    }
    
    @discardableResult
    func height( _ v:Float ) -> Self {
        params.scale.y = v
        return self
    }
    
    @discardableResult
    func height( _ v:LLFloatConvertable ) -> Self {
        return height( v.f )
    }

    @discardableResult
    func height( _ calc:( LBPanel )->Float ) -> Self {
        params.scale.y = calc( self )
        return self
    }
}

// MARK: -
public extension LBPanel
{
    var angle:LLAngle {
        get { return LLAngle.radians( params.angle.d ) }
        set { params.angle = newValue.radians.f }
    }
    
    @discardableResult
    func angle( _ ang:LLAngle ) -> Self {
        angle = ang 
        return self
    }
    
    @discardableResult
    func angle( radians rad:LLFloatConvertable ) -> Self {
        return angle( LLAngle.radians( rad.f.d ) )
    }
    
    @discardableResult
    func angle( degrees deg:LLFloatConvertable ) -> Self {
        return angle( LLAngle.radians( deg.f.d ) )
    }
    
    @discardableResult
    func angle( _ calc:( LBPanel )->LLAngle ) -> Self {
        angle = calc( self )
        return self
    }
    
    @discardableResult
    func angle<T:BinaryInteger>( _ calc:( LBPanel )->T ) -> Self {
        angle = LLAngle( radians:Double( calc( self ) ) )
        return self
    }
    
    @discardableResult
    func angle<T:BinaryFloatingPoint>( _ calc:( LBPanel )->T ) -> Self {
        angle = LLAngle( radians:Double( calc( self ) ) )
        return self
    }
}

// MARK: -
public extension LBPanel
{
    var zIndex:LLFloat {
        get { return params.zindex }
        set { params.zindex = newValue }
    }
    
    @discardableResult
    func zIndex( _ index:Float ) -> Self {
        params.zindex = index
        return self
    }
    
    @discardableResult
    func zIndex( _ v:LLFloatConvertable ) -> Self {
        return zIndex( v.f )
    }
    
    @discardableResult
    func zIndex( _ calc:( LBPanel )->Float ) -> Self {
        params.zindex = calc( self )
        return self
    }
}

// MARK: -
public extension LBPanel
{
    var enabled:Bool { 
        get { return params.enabled }
        set { params.enabled = newValue }
    }
    
    @discardableResult
    func enabled( _ torf:Bool ) -> Self {
        params.enabled = torf
        return self
    }
    
    @discardableResult
    func enabled( _ calc:( LBPanel )->Bool ) -> Self {
        params.enabled = calc( self )
        return self
    }
}

// MARK: -
public extension LBPanel
{
    var life:Float { 
        get { return params.life }
        set { params.life = newValue }
    }
    
    @discardableResult
    func life( _ v:Float ) -> Self {
        params.life = v
        return self
    }
    
    @discardableResult
    func life( _ v:LLFloatConvertable ) -> Self {
        return life( v.f )
    }
    
    @discardableResult
    func life( _ calc:( LBPanel )->Float ) -> Self {
        params.life = calc( self )
        return self
    }
}

// MARK: -
public extension LBPanel
{
   var color:LLColor {
        get { return params.color.llColor }
        set { params.color = newValue.floatv4 }
    }
    
    @discardableResult
    func color( _ c:LLColor ) -> Self {
        params.color = c.floatv4
        return self
    }
    
    @discardableResult
    func color( red:Float, green:Float, blue:Float, alpha:Float = 1.0 ) -> Self {
        params.color = LLFloatv4( red, green, blue, alpha )
        return self
    }
    
    @discardableResult
    func color( red:LLFloatConvertable, green:LLFloatConvertable,
                blue:LLFloatConvertable, alpha:LLFloatConvertable = 1.0 ) -> Self {
        return color( red:red.f, green:green.f, blue:blue.f, alpha:alpha.f )
    }
    
    @discardableResult
    func color( _ calc:( LBPanel )->LLColor ) -> Self {
        params.color = calc( self ).floatv4
        return self
    }
}

// MARK: -
public extension LBPanel
{
   var alpha:Float {
        get { return params.color.w }
        set { params.color.w = newValue }
    }
    
    @discardableResult
    func alpha( _ c:Float ) -> Self {
        params.color.w = c
        return self
    }
    
    @discardableResult
    func alpha( _ v:LLFloatConvertable ) -> Self {
        return alpha( v.f )
    }
    
    @discardableResult
    func alpha( _ calc:( LBPanel )->Float ) -> Self {
        params.color.w = calc( self )
        return self
    }
}

// MARK: -
public extension LBPanel
{
    var matrix:LLMatrix4x4 { 
        get { return params.matrix }
        set { params.matrix = newValue }
    }
    
    @discardableResult
    func matrix( _ mat:LLMatrix4x4 ) -> Self {
        params.matrix = mat
        return self
    }
}

// MARK: -
public extension LBPanel
{
    var deltaPosition:LLPointFloat { 
        get { return LLPointFloat( params.deltaPosition.x, params.deltaPosition.y ) }
        set { params.deltaPosition = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    @discardableResult
    func deltaPosition( _ p:LLPointFloat ) -> Self {
        params.deltaPosition = LLFloatv2( p.x, p.y )
        return self
    }
    
    @discardableResult
    func deltaPosition( dx:Float, dy:Float ) -> Self {
        params.deltaPosition = LLFloatv2( dx, dy )
        return self
    }
    
    @discardableResult
    func deltaPosition( dx:LLFloatConvertable, dy:LLFloatConvertable ) -> Self {
        return deltaPosition( dx:dx.f, dy:dy.f )
    }
    
    @discardableResult
    func deltaPosition( _ calc:( LBPanel )->LLPointFloat ) -> Self {
        let pos = calc( self )
        params.deltaPosition = LLFloatv2( pos.x, pos.y )
        return self
    }
    
    @discardableResult
    func deltaPosition<T:BinaryFloatingPoint>( _ calc:( LBPanel )->(T,T) ) -> Self {
        let pos = calc( self )
        params.deltaPosition = LLFloatv2( Float(pos.0), Float(pos.1) )
        return self
    }
    
    @discardableResult
    func deltaPositionStep( df:@escaping ( LBPanelParam )->LLFloatv2 ) -> Self {
        deltas.deltaPosition = df
        return self
    }
}

// MARK: -
public extension LBPanel
{
    var deltaScale:LLSizeFloat { 
        get { return LLSizeFloat( params.deltaScale.x, params.deltaScale.y ) }
        set { params.deltaScale = LLFloatv2( newValue.width, newValue.height ) }
    }
    
    @discardableResult
    func deltaScale( _ dsc:LLSizeFloat ) -> Self {
        params.deltaScale = LLFloatv2( dsc.width, dsc.height )
        return self
    }
    
    @discardableResult
    func deltaScale( dw:Float, dh:Float ) -> Self {
        params.deltaScale = LLFloatv2( dw, dh )
        return self
    }
    
    @discardableResult
    func deltaScale( dw:LLFloatConvertable, dh:LLFloatConvertable ) -> Self {
        return deltaScale( dw:dw.f, dh:dh.f )
    }
    
    @discardableResult
    func deltaScale( _ calc:( LBPanel )->LLSizeFloat ) -> Self {
        let sz = calc( self )
        params.deltaScale = LLFloatv2( sz.width, sz.height )
        return self
    }
}

// MARK: -
public extension LBPanel
{
    var deltaColor:LLColor { 
        get { return LLColor( 
                params.deltaColor.x,
                params.deltaColor.y,
                params.deltaColor.z,
                params.deltaColor.w )
        }
        set { params.deltaColor = LLFloatv4( newValue.R, newValue.G, newValue.B, newValue.A ) }
    }
    
    @discardableResult
    func deltaColor( _ c:LLColor ) -> Self {
        deltaColor = c
        return self
    }
        
    @discardableResult
    func deltaColor( red:Float, green:Float, blue:Float, alpha:Float = 1.0 ) -> Self {
        params.deltaColor = LLFloatv4( red, green, blue, alpha )
        return self
    }
    
    @discardableResult
    func deltaColor( red:LLFloatConvertable, green:LLFloatConvertable,
                     blue:LLFloatConvertable, alpha:LLFloatConvertable = 1.0 ) -> Self {
        return deltaColor( red:red.f, green:green.f, blue:blue.f, alpha:alpha.f )
    }
}

// MARK: -
public extension LBPanel
{
    var deltaAngle:LLAngle {
        get { return LLAngle.radians( params.deltaAngle.d ) }
        set { params.deltaAngle = newValue.radians.f }
    }
    
    @discardableResult
    func deltaAngle( _ ang:LLAngle ) -> Self {
        deltaAngle = ang 
        return self
    }
    
    @discardableResult
    func deltaAngle( radians rad:LLFloatConvertable ) -> Self {
        return deltaAngle( LLAngle.radians( rad.f.d ) )
    }
    
    @discardableResult
    func deltaAngle( degrees deg:LLFloatConvertable ) -> Self {
        return deltaAngle( LLAngle.degrees( deg.f.d ) )
    }
    
    @discardableResult
    func deltaAngle( _ calc:( LBPanel )->LLAngle ) -> Self {
        deltaAngle = calc( self )
        return self
    }
    
    @discardableResult
    func deltaAngle<T:BinaryInteger>( _ calc:( LBPanel )->T ) -> Self {
        deltaAngle = LLAngle( radians:Double( calc( self ) ) )
        return self
    }
    
    @discardableResult
    func deltaAngle<T:BinaryFloatingPoint>( _ calc:( LBPanel )->T ) -> Self {
        deltaAngle = LLAngle( radians:Double( calc( self ) ) )
        return self
    }
}

// MARK: -
public extension LBPanel
{
    @discardableResult
    func atlasParts( of key:String ) -> Self {
        guard let parts = _storage.atlas?.parts( key ),
              let reg = parts.region 
        else {
            LLLog( "アトラスが設定されていないか,指定が正しくないため無効です:\(key)" )
            vertice.p1.tex_uv = .zero
            vertice.p2.tex_uv = .zero
            vertice.p3.tex_uv = .zero
            vertice.p4.tex_uv = .zero
            return self
        }
        
        vertice.p1.tex_uv = LLFloatv2( reg.left.f, reg.top.f ) 
        vertice.p2.tex_uv = LLFloatv2( reg.right.f, reg.top.f ) 
        vertice.p3.tex_uv = LLFloatv2( reg.left.f, reg.bottom.f ) 
        vertice.p4.tex_uv = LLFloatv2( reg.right.f, reg.bottom.f ) 
        
        return self
    }    
}

// MARK: -
public extension LBPanel
{
    @discardableResult
    func texture( _ tex:MTLTexture? ) -> Self {
        guard let tex = tex else {
            self._storage.texture = nil
            vertice.p1.tex_uv = .zero
            vertice.p2.tex_uv = .zero
            vertice.p3.tex_uv = .zero
            vertice.p4.tex_uv = .zero
            return self
        }
        
        self._storage.texture = tex
        vertice.p1.tex_uv = LLFloatv2( 0.0, 0.0 ) 
        vertice.p2.tex_uv = LLFloatv2( 1.0, 0.0 ) 
        vertice.p3.tex_uv = LLFloatv2( 0.0, 1.0 ) 
        vertice.p4.tex_uv = LLFloatv2( 1.0, 1.0 ) 
        
        return self
    } 

    @discardableResult
    func texture( _ tex:LLMetalTexture? ) -> Self {
        return texture( tex?.metalTexture )
    } 
}

