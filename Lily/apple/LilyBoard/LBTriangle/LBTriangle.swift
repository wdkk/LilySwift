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

open class LBTriangle : LBActor<LBTriangleDecoration>, LBActorAccessor
{
    public private(set) var index:Int
    private var _storage:LBTriangleStorage
    
    public override init( decoration:LBTriangleDecoration ) {
        // makeされていなかった場合を考慮してここでmakeする
        decoration.make()
        
        self.index = decoration.storage.request()
        self._storage = decoration.storage
        super.init( decoration:decoration )
    }
    
    deinit {
        params.state = .trush
    }

    public var vertice:LLTriple<LBTriangleVertex> {
        get { return _storage.tris.vertice[index] }
        set { withUnsafeMutablePointer(to: &(_storage.tris.vertice[index]) ) { $0.pointee = newValue } }
    }
    
    public var params:LBTriangleParam {
        get { return _storage.params[index] }
        set { withUnsafeMutablePointer(to: &(_storage.params[index]) ) { $0.pointee = newValue } }
    }
}

// MARK: -
public extension LBTriangle
{
    var p1:LLPointFloat { 
        get { return LLPointFloat( vertice.p1.xy.x, vertice.p1.xy.y ) }
        set { vertice.p1.xy = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    @discardableResult
    func p1( _ p:LLPointFloat ) -> Self {
        p1 = p
        return self
    }
    
    @discardableResult
    func p1( _ p:LLPoint ) -> Self {
        p1 = p.llPointFloat
        return self
    }
    
    @discardableResult
    func p1( x:Float, y:Float ) -> Self {
        p1 = LLPointFloat( x, y )
        return self
    }
    
    @discardableResult
    func p1( x:LLFloatConvertable, y:LLFloatConvertable ) -> Self {
        return p1( x:x.f, y:y.f )
    }
    
    @discardableResult
    func p1( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self {
        p1 = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
{
    var p2:LLPointFloat { 
        get { return LLPointFloat( vertice.p2.xy.x, vertice.p2.xy.y ) }
        set { vertice.p2.xy = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    @discardableResult
    func p2( _ p:LLPointFloat ) -> Self {
        p2 = p
        return self
    }
    
    @discardableResult
    func p2( _ p:LLPoint ) -> Self {
        p2 = p.llPointFloat
        return self
    }
    
    @discardableResult
    func p2( x:Float, y:Float ) -> Self {
        p2 = LLPointFloat( x, y )
        return self
    }
    
    @discardableResult
    func p2( x:LLFloatConvertable, y:LLFloatConvertable ) -> Self {
        return p2( x:x.f, y:y.f )
    }
    
    @discardableResult
    func p2( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self {
        p2 = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
{
    var p3:LLPointFloat { 
        get { return LLPointFloat( vertice.p3.xy.x, vertice.p3.xy.y ) }
        set { vertice.p3.xy = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    @discardableResult
    func p3( _ p:LLPointFloat ) -> Self {
        p3 = p
        return self
    }
    
    @discardableResult
    func p3( _ p:LLPoint ) -> Self {
        p3 = p.llPointFloat
        return self
    }
    
    @discardableResult
    func p3( x:Float, y:Float ) -> Self {
        p3 = LLPointFloat( x, y )
        return self
    }
    
    @discardableResult
    func p3( x:LLFloatConvertable, y:LLFloatConvertable ) -> Self {
        return p3( x:x.f, y:y.f )
    }
    
    @discardableResult
    func p3( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self {
        p3 = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
{
    var p4:LLPointFloat { 
        get { return .zero }
        set { }
    }
    
    @discardableResult
    func p4( _ p:LLPointFloat ) -> Self {
        return self
    }
    
    @discardableResult
    func p4( _ p:LLPoint ) -> Self {
        return self
    }
    
    @discardableResult
    func p4( x:Float, y:Float ) -> Self {
        return self
    }
    
    @discardableResult
    func p4( x:LLFloatConvertable, y:LLFloatConvertable ) -> Self {
        return self
    }
    
    @discardableResult
    func p4( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self {
        return self
    }
}

// MARK: -
public extension LBTriangle
{
    var uv1:LLPointFloat { 
        get { return LLPointFloat( vertice.p1.tex_uv.u, vertice.p1.tex_uv.v ) }
        set { vertice.p1.tex_uv = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    @discardableResult
    func uv1( _ uv:LLPointFloat ) -> Self {
        uv1 = uv
        return self
    }
    
    @discardableResult
    func uv1( u:Float, v:Float ) -> Self {
        uv1 = LLPointFloat( u, v )
        return self
    }
    
    @discardableResult
    func uv1( u:LLFloatConvertable, v:LLFloatConvertable ) -> Self {
        return uv1( u:u.f, v:v.f )
    }
    
    @discardableResult
    func uv1( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self {
        uv1 = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
{
    var uv2:LLPointFloat { 
        get { return LLPointFloat( vertice.p2.tex_uv.u, vertice.p2.tex_uv.v ) }
        set { vertice.p2.tex_uv = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    @discardableResult
    func uv2( _ uv:LLPointFloat ) -> Self {
        uv2 = uv
        return self
    }
    
    @discardableResult
    func uv2( u:Float, v:Float ) -> Self {
        uv2 = LLPointFloat( u, v )
        return self
    }
    
    @discardableResult
    func uv2( u:LLFloatConvertable, v:LLFloatConvertable ) -> Self {
        return uv1( u:u.f, v:v.f )
    }
    
    @discardableResult
    func uv2( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self {
        uv2 = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
{
    var uv3:LLPointFloat { 
        get { return LLPointFloat( vertice.p3.tex_uv.u, vertice.p3.tex_uv.v ) }
        set { vertice.p3.tex_uv = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    @discardableResult
    func uv3( _ uv:LLPointFloat ) -> Self {
        uv3 = uv
        return self
    }
    
    @discardableResult
    func uv3( u:Float, v:Float ) -> Self {
        uv3 = LLPointFloat( u, v )
        return self
    }
    
    @discardableResult
    func uv3( u:LLFloatConvertable, v:LLFloatConvertable ) -> Self {
        return uv3( u:u.f, v:v.f )
    }
    
    @discardableResult
    func uv3( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self {
        uv3 = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
{
    var uv4:LLPointFloat { 
        get { return .zero }
        set { }
    }
    
    @discardableResult
    func uv4( _ uv:LLPointFloat ) -> Self {
        return self
    }
    
    @discardableResult
    func uv4( u:Float, v:Float ) -> Self {
        return self
    }
    
    @discardableResult
    func uv4( u:LLFloatConvertable, v:LLFloatConvertable ) -> Self {
        return self
    }
    
    @discardableResult
    func uv4( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self {
        return self
    }
}


// MARK: -
public extension LBTriangle
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
    func position( _ p:LLPoint ) -> Self {
        params.position = LLFloatv2( p.x.f, p.y.f )
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
    func position( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self {
        let pos = calc( self )
        params.position = LLFloatv2( pos.x, pos.y )
        return self
    }
}

// MARK: -
public extension LBTriangle
{
    var cx:LLFloat {
        get { return params.position.x }
        set { params.position.x = newValue }
    }
    
    @discardableResult
    func cx( _ p:LLFloat ) -> Self {
        params.position.x = p
        return self
    }
    
    @discardableResult
    func cx( _ p:LLFloatConvertable ) -> Self {
        return cx( p.f )
    }

    @discardableResult
    func cx( _ calc:( LBActorAccessor )->LLFloat ) -> Self {
        params.position.x = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
{
    var cy:LLFloat {
        get { return params.position.y }
        set { params.position.y = newValue }
    }
    
    @discardableResult
    func cy( _ p:LLFloat ) -> Self {
        params.position.y = p
        return self
    }
    
    @discardableResult
    func cy( _ p:LLFloatConvertable ) -> Self {
        return cy( p.f )
    }

    @discardableResult
    func cy( _ calc:( LBActorAccessor )->LLFloat ) -> Self {
        params.position.y = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
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
    func scale( _ calc:( LBActorAccessor )->LLSizeFloat ) -> Self {
        let sz = calc( self )
        params.scale = LLFloatv2( sz.width, sz.height )
        return self
    }
    
    @discardableResult
    func scale( square sz:Float ) -> Self {
        params.scale = LLFloatv2( sz, sz )
        return self
    }
    
    @discardableResult
    func scale( square sz:LLFloatConvertable ) -> Self {
        params.scale = LLFloatv2( sz.f, sz.f )
        return self
    }
}

// MARK: -
public extension LBTriangle
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
    func width( _ calc:( LBActorAccessor )->Float ) -> Self {
        params.scale.x = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
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
    func height( _ calc:( LBActorAccessor )->Float ) -> Self {
        params.scale.y = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
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
        return angle( LLAngle.degrees( deg.f.d ) )
    }
    
    @discardableResult
    func angle( _ calc:( LBActorAccessor )->LLAngle ) -> Self {
        angle = calc( self )
        return self
    }
    
    @discardableResult
    func angle<T:BinaryInteger>( _ calc:( LBActorAccessor )->T ) -> Self {
        angle = LLAngle( radians:Double( calc( self ) ) )
        return self
    }
    
    @discardableResult
    func angle<T:BinaryFloatingPoint>( _ calc:( LBActorAccessor )->T ) -> Self {
        angle = LLAngle( radians:Double( calc( self ) ) )
        return self
    }
}

// MARK: -
public extension LBTriangle
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
    func zIndex( _ calc:( LBActorAccessor )->Float ) -> Self {
        params.zindex = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
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
    func enabled( _ calc:( LBActorAccessor )->Bool ) -> Self {
        params.enabled = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
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
    func life( _ calc:( LBActorAccessor )->Float ) -> Self {
        params.life = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
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
    func color( _ calc:( LBActorAccessor )->LLColor ) -> Self {
        params.color = calc( self ).floatv4
        return self
    }
}

// MARK: -
public extension LBTriangle
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
    func alpha( _ calc:( LBActorAccessor )->Float ) -> Self {
        params.color.w = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
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
public extension LBTriangle
{
    var deltaPosition:LLPointFloat { 
        get { return LLPointFloat( params.deltaPosition.x, params.deltaPosition.y ) }
        set { params.deltaPosition = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    @discardableResult
    func deltaPosition( _ dp:LLPointFloat ) -> Self {
        params.deltaPosition = LLFloatv2( dp.x, dp.y )
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
    func deltaPosition( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self {
        let pos = calc( self )
        params.deltaPosition = LLFloatv2( pos.x, pos.y )
        return self
    }
    
    @discardableResult
    func deltaPosition<T:BinaryFloatingPoint>( _ calc:( LBActorAccessor )->(T,T) ) -> Self {
        let pos = calc( self )
        params.deltaPosition = LLFloatv2( Float(pos.0), Float(pos.1) )
        return self
    }
}

// MARK: -
public extension LBTriangle
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
    func deltaScale( _ calc:( LBActorAccessor )->LLSizeFloat ) -> Self {
        let sz = calc( self )
        params.deltaScale = LLFloatv2( sz.width, sz.height )
        return self
    }
}

// MARK: -
public extension LBTriangle
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
public extension LBTriangle
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
    func deltaAngle( _ calc:( LBActorAccessor )->LLAngle ) -> Self {
        deltaAngle = calc( self )
        return self
    }
    
    @discardableResult
    func deltaAngle<T:BinaryInteger>( _ calc:( LBActorAccessor )->T ) -> Self {
        deltaAngle = LLAngle( radians:Double( calc( self ) ) )
        return self
    }
    
    @discardableResult
    func deltaAngle<T:BinaryFloatingPoint>( _ calc:( LBActorAccessor )->T ) -> Self {
        deltaAngle = LLAngle( radians:Double( calc( self ) ) )
        return self
    }
}

// MARK: -
public extension LBTriangle
{
    var deltaLife:Float {
        get { return params.deltaLife }
        set { params.deltaLife = newValue }
    }
    
    @discardableResult
    func deltaLife( _ v:Float ) -> Self {
        params.deltaLife = v
        return self
    }
    
    @discardableResult
    func deltaLife( _ v:LLFloatConvertable ) -> Self {
        params.deltaLife = v.f
        return self
    }

    @discardableResult
    func deltaLife( _ calc:( LBActorAccessor )->Float ) -> Self {
        params.deltaLife = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
{
    var deltaAlpha:Float {
        get { return params.deltaColor.w }
        set { params.deltaColor.w = newValue }
    }
    
    @discardableResult
    func deltaAlpha( _ v:Float ) -> Self {
        params.deltaColor.w = v
        return self
    }
    
    @discardableResult
    func deltaAlpha( _ v:LLFloatConvertable ) -> Self {
        params.deltaColor.w = v.f
        return self
    }

    @discardableResult
    func deltaAlpha( _ calc:( LBActorAccessor )->Float ) -> Self {
        params.deltaColor.w = calc( self )
        return self
    }
}

// MARK: -
public extension LBTriangle
{
    @discardableResult
    func atlasParts( of key:String ) -> Self {
        guard let parts = _storage.atlas?.parts( key ),
              let reg = parts.region 
        else {
            LLLog( "アトラスが設定されていないか,指定が正しくないため無効です:\(key)" )
            params.atlasUV = LLFloatv4( 0.0, 0.0, 1.0, 1.0 )
            vertice.p1.tex_uv = .zero
            vertice.p2.tex_uv = .zero
            vertice.p3.tex_uv = .zero
            return self
        }
        
        params.atlasUV = LLFloatv4( reg.left.f, reg.top.f, reg.right.f, reg.bottom.f )
        vertice.p1.tex_uv = LLFloatv2( 0.0, 0.0 ) 
        vertice.p2.tex_uv = LLFloatv2( 1.0, 0.0 ) 
        vertice.p3.tex_uv = LLFloatv2( 0.0, 1.0 ) 

        return self
    }    
}

// MARK: -
public extension LBTriangle
{
    @discardableResult
    func texture( _ tex:MTLTexture? ) -> Self {
        guard let tex = tex else {
            self._storage.texture = nil
            params.atlasUV = LLFloatv4( 0.0, 0.0, 1.0, 1.0 )
            vertice.p1.tex_uv = .zero
            vertice.p2.tex_uv = .zero
            vertice.p3.tex_uv = .zero
            return self
        }
        
        self._storage.texture = tex    
        params.atlasUV = LLFloatv4( 0.0, 0.0, 1.0, 1.0 )
        vertice.p1.tex_uv = LLFloatv2( 0.0, 0.0 ) 
        vertice.p2.tex_uv = LLFloatv2( 1.0, 0.0 ) 
        vertice.p3.tex_uv = LLFloatv2( 0.0, 1.0 ) 
        
        return self
    } 

    @discardableResult
    func texture( _ tex:LLMetalTexture? ) -> Self {
        return texture( tex?.metalTexture )
    } 
}
