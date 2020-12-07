//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

open class LBActor : Hashable
{        
    // Hashableの実装
    public static func == ( lhs:LBActor, rhs:LBActor ) -> Bool {
        lhs === rhs
    }
    // Hashableの実装
    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier( self ).hash( into: &hasher )
    }
    
    public var params:LBActorParam { get { LBActorParam() } set { } }
    
    // MARK: - 基本パラメータ群
    public var p1:LLPointFloat { get { .zero } set {} }
    public var p2:LLPointFloat { get { .zero } set {} }
    public var p3:LLPointFloat { get { .zero } set {} }
    public var p4:LLPointFloat { get { .zero } set {} }
    
    public var uv1:LLPointFloat { get { .zero } set {} }
    public var uv2:LLPointFloat { get { .zero } set {} }
    public var uv3:LLPointFloat { get { .zero } set {} }
    public var uv4:LLPointFloat { get { .zero } set {} }
    
    public func atlasParts(of key: String) -> Self { return self }
    
    public func texture(_ tex: MTLTexture?) -> Self { return self }
    
    public func texture(_ tex: LLMetalTexture?) -> Self { return self }

    public var position:LLPointFloat { 
        get { return LLPointFloat( params.position.x, params.position.y ) }
        set { params.position = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    public var cx:LLFloat {
        get { return params.position.x }
        set { params.position.x = newValue }
    }
    
    public var cy:LLFloat {
        get { return params.position.y }
        set { params.position.y = newValue }
    }
    
    public var scale:LLSizeFloat {
        get { return LLSizeFloat( params.scale.x, params.scale.y ) }
        set { params.scale = LLFloatv2( newValue.width, newValue.height ) }
    }
    
    public var width:Float {
        get { return params.scale.x }
        set { params.scale.x = newValue }
    }
    
    public var height:Float {
        get { return params.scale.y }
        set { params.scale.y = newValue }
    }
    
    public var angle:LLAngle {
        get { return LLAngle.radians( params.angle.d ) }
        set { params.angle = newValue.radians.f }
    }
    
    public var enabled:Bool { 
        get { return params.enabled }
        set { params.enabled = newValue }
    }
    
    public var life:Float { 
        get { return params.life }
        set { params.life = newValue }
    }
    
    public var color:LLColor {
        get { return params.color.llColor }
        set { params.color = newValue.floatv4 }
    }
    
    public var alpha:Float {
        get { return params.color.w }
        set { params.color.w = newValue }
    }
    
    public var matrix:LLMatrix4x4 { 
        get { return params.matrix }
        set { params.matrix = newValue }
    }
    
    public var deltaPosition:LLPointFloat { 
        get { return LLPointFloat( params.deltaPosition.x, params.deltaPosition.y ) }
        set { params.deltaPosition = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    public var deltaScale:LLSizeFloat { 
        get { return LLSizeFloat( params.deltaScale.x, params.deltaScale.y ) }
        set { params.deltaScale = LLFloatv2( newValue.width, newValue.height ) }
    }
    
    public var deltaColor:LLColor { 
        get { return LLColor( 
            params.deltaColor.x,
            params.deltaColor.y,
            params.deltaColor.z,
            params.deltaColor.w )
        }
        set { params.deltaColor = LLFloatv4( newValue.R, newValue.G, newValue.B, newValue.A ) }
    }
    
    public var deltaAlpha:Float {
        get { return params.deltaColor.w }
        set { params.deltaColor.w = newValue }
    }
    
    public var deltaAngle:LLAngle {
        get { return LLAngle.radians( params.deltaAngle.d ) }
        set { params.deltaAngle = newValue.radians.f }
    }
    
    public var deltaLife:Float {
        get { return params.deltaLife }
        set { params.deltaLife = newValue }
    }
}

// MARK: - 基本頂点情報の各種メソッドチェーンアクセサ
public extension LBActor
{
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
    func p1( _ calc:( LBActor )->LLPointFloat ) -> Self {
        p1 = calc( self )
        return self
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
    func p2( _ calc:( LBActor )->LLPointFloat ) -> Self {
        p2 = calc( self )
        return self
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
    func p3( _ calc:( LBActor )->LLPointFloat ) -> Self {
        p3 = calc( self )
        return self
    }

    
    @discardableResult
    func p4( _ p:LLPointFloat ) -> Self {
        p4 = p
        return self
    }
    
    @discardableResult
    func p4( _ p:LLPoint ) -> Self {
        p4 = p.llPointFloat
        return self
    }
    
    @discardableResult
    func p4( x:Float, y:Float ) -> Self {
        p4 = LLPointFloat( x, y )
        return self
    }
    
    @discardableResult
    func p4( x:LLFloatConvertable, y:LLFloatConvertable ) -> Self {
        return p4( x:x.f, y:y.f )
    }
    
    @discardableResult
    func p4( _ calc:( LBActor )->LLPointFloat ) -> Self {
        p4 = calc( self )
        return self
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
    func uv1( _ calc:( LBActor )->LLPointFloat ) -> Self {
        uv1 = calc( self )
        return self
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
    func uv2( _ calc:( LBActor )->LLPointFloat ) -> Self {
        uv2 = calc( self )
        return self
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
    func uv3( _ calc:( LBActor )->LLPointFloat ) -> Self {
        uv3 = calc( self )
        return self
    }

    
    @discardableResult
    func uv4( _ uv:LLPointFloat ) -> Self {
        uv4 = uv
        return self
    }
    
    @discardableResult
    func uv4( u:Float, v:Float ) -> Self {
        uv4 = LLPointFloat( u, v )
        return self
    }
    
    @discardableResult
    func uv4( u:LLFloatConvertable, v:LLFloatConvertable ) -> Self {
        return uv4( u:u.f, v:v.f )
    }
    
    @discardableResult
    func uv4( _ calc:( LBActor )->LLPointFloat ) -> Self {
        uv4 = calc( self )
        return self
    }
}

// MARK: - 基本パラメータ情報の各種メソッドチェーンアクセサ
public extension LBActor
{
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
        position = LLPointFloat( cx, cy )
        return self
    }
    
    @discardableResult
    func position( cx:LLFloatConvertable, cy:LLFloatConvertable ) -> Self {
        params.position = LLFloatv2( cx.f, cy.f )
        return self
    }
    
    @discardableResult
    func position( _ calc:( LBActor )->LLPointFloat ) -> Self {
        let pf = calc( self )
        params.position = LLFloatv2( pf.x, pf.y )
        return self
    }
    
    
    @discardableResult
    func cx( _ p:Float ) -> Self {
        params.position.x = p
        return self
    }
    
    @discardableResult
    func cx( _ p:LLFloatConvertable ) -> Self {
        params.position.x = p.f
        return self
    }

    @discardableResult
    func cx( _ calc:( LBActor )->LLFloat ) -> Self {
        params.position.x = calc( self )
        return self
    }

    
    @discardableResult
    func cy( _ p:Float ) -> Self {
        params.position.y = p
        return self
    }
    
    @discardableResult
    func cy( _ p:LLFloatConvertable ) -> Self {
        params.position.y = p.f
        return self
    }

    @discardableResult
    func cy( _ calc:( LBActor )->LLFloat ) -> Self {
        params.position.y = calc( self )
        return self
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
        params.scale = LLFloatv2( width.f, height.f )
        return self
    }
    
    @discardableResult
    func scale( _ calc:( LBActor )->LLSizeFloat ) -> Self {
        let sf = calc( self )
        params.scale = LLFloatv2( sf.width, sf.height )
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

    
    @discardableResult
    func width( _ v:Float ) -> Self {
        params.scale.x = v
        return self
    }
    
    @discardableResult
    func width( _ v:LLFloatConvertable ) -> Self {
        params.scale.x = v.f
        return self
    }

    @discardableResult
    func width( _ calc:( LBActor )->Float ) -> Self {
        params.scale.x = calc( self )
        return self
    }

    
    @discardableResult
    func height( _ v:Float ) -> Self {
        params.scale.y = v
        return self
    }
    
    @discardableResult
    func height( _ v:LLFloatConvertable ) -> Self {
        params.scale.y = v.f
        return self
    }

    @discardableResult
    func height( _ calc:( LBActor )->Float ) -> Self {
        params.scale.y = calc( self )
        return self
    }

    
    @discardableResult
    func angle( _ ang:LLAngle ) -> Self {
        params.angle = ang.radians.f
        return self
    }
    
    @discardableResult
    func angle( radians rad:LLFloatConvertable ) -> Self {
        params.angle = rad.f
        return self
    }
    
    @discardableResult
    func angle( degrees deg:LLFloatConvertable ) -> Self {
        params.angle = LLAngle( degrees: deg.f.d ).radians.f
        return self
    }
    
    @discardableResult
    func angle( _ calc:( LBActor )->LLAngle ) -> Self {
        let ang = calc( self )
        params.angle = ang.radians.f
        return self
    }
    
    @discardableResult
    func angle<T:BinaryInteger>( _ calc:( LBActor )->T ) -> Self {
        params.angle = Float( calc( self ) )
        return self
    }
    
    @discardableResult
    func angle<T:BinaryFloatingPoint>( _ calc:( LBActor )->T ) -> Self {
        params.angle = Float( calc( self ) )
        return self
    }
    
    @discardableResult
    func enabled( _ torf:Bool ) -> Self {
        params.enabled = torf
        return self
    }
    
    @discardableResult
    func enabled( _ calc:( LBActor )->Bool ) -> Self {
        params.enabled = calc( self )
        return self
    }

    
    @discardableResult
    func life( _ v:Float ) -> Self {
        params.life = v
        return self
    }
    
    @discardableResult
    func life( _ v:LLFloatConvertable ) -> Self {
        params.life = v.f
        return self
    }
    
    @discardableResult
    func life( _ calc:( LBActor )->Float ) -> Self {
        params.life = calc( self )
        return self
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
        params.color = LLFloatv4( red.f, green.f, blue.f, alpha.f )
        return self
    }
    
    @discardableResult
    func color( _ calc:( LBActor )->LLColor ) -> Self {
        params.color = calc( self ).floatv4
        return self
    }

    
    @discardableResult
    func alpha( _ c:Float ) -> Self {
        params.color.w = c
        return self
    }
    
    @discardableResult
    func alpha( _ v:LLFloatConvertable ) -> Self {
        params.color.w = v.f
        return self
    }
    
    @discardableResult
    func alpha( _ calc:( LBActor )->Float ) -> Self {
        params.color.w = calc( self )
        return self
    }
    

    @discardableResult
    func matrix( _ mat:LLMatrix4x4 ) -> Self {
        params.matrix = mat
        return self
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
        params.deltaPosition = LLFloatv2( dx.f, dy.f )
        return self
    }
    
    @discardableResult
    func deltaPosition( _ calc:( LBActor )->LLPointFloat ) -> Self {
        let pf = calc( self )
        params.deltaPosition = LLFloatv2( pf.x, pf.y )
        return self
    }
    
    @discardableResult
    func deltaPosition<T:BinaryFloatingPoint>( _ calc:( LBActor )->(T,T) ) -> Self {
        let pos = calc( self )
        params.deltaPosition = LLFloatv2( Float(pos.0), Float(pos.1) )
        return self
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
        params.deltaScale = LLFloatv2( dw.f, dh.f )
        return self
    }
    
    @discardableResult
    func deltaScale( _ calc:( LBActor )->LLSizeFloat ) -> Self {
        let sf = calc( self )
        params.deltaScale = LLFloatv2( sf.width, sf.height )
        return self
    }

    @discardableResult
    func deltaColor( _ c:LLColor ) -> Self {
        params.deltaColor = c.floatv4
        return self
    }
        
    @discardableResult
    func deltaColor( red:Float, green:Float, blue:Float, alpha:Float = 0.0 ) -> Self {
        params.deltaColor = LLFloatv4( red, green, blue, alpha )
        return self
    }
    
    @discardableResult
    func deltaColor( red:LLFloatConvertable, green:LLFloatConvertable,
                     blue:LLFloatConvertable, alpha:LLFloatConvertable = 0.0 ) -> Self {
        params.deltaColor = LLFloatv4( red.f, green.f, blue.f, alpha.f )
        return self
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
    func deltaAlpha( _ calc:( LBActor )->Float ) -> Self {
        params.deltaColor.w = calc( self )
        return self
    }

        
    @discardableResult
    func deltaAngle( _ ang:LLAngle ) -> Self {
        params.deltaAngle = ang.radians.f
        return self
    }
    
    @discardableResult
    func deltaAngle( radians rad:LLFloatConvertable ) -> Self {
        params.deltaAngle = rad.f
        return self
    }
    
    @discardableResult
    func deltaAngle( degrees deg:LLFloatConvertable ) -> Self {
        params.deltaAngle = LLAngle.degrees( deg.f.d ).radians.f
        return self
    }
    
    @discardableResult
    func deltaAngle( _ calc:( LBActor )->LLAngle ) -> Self {
        params.deltaAngle = calc( self ).radians.f
        return self
    }
    
    @discardableResult
    func deltaAngle<T:BinaryInteger>( _ calc:( LBActor )->T ) -> Self {
        params.deltaAngle = Float( calc( self ) )
        return self
    }
    
    @discardableResult
    func deltaAngle<T:BinaryFloatingPoint>( _ calc:( LBActor )->T ) -> Self {
        params.deltaAngle = Float( calc( self ) )
        return self
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
    func deltaLife( _ calc:( LBActor )->Float ) -> Self {
        params.deltaLife = calc( self )
        return self
    }
}
