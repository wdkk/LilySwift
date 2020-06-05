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

open class LBActor : Hashable
{        
    // Hashableの実装
    public static func == ( lhs:LBActor, rhs:LBActor ) -> Bool {
        lhs === rhs
    }
    // Hashableの実装
    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
    
    // MARK: - 基本パラメータ群
    public var p1:LLPointFloat { get { .zero } set {} }
    public var p2:LLPointFloat { get { .zero } set {} }
    public var p3:LLPointFloat { get { .zero } set {} }
    public var p4:LLPointFloat { get { .zero } set {} }
    
    public var uv1:LLPointFloat { get { .zero } set {} }
    public var uv2:LLPointFloat { get { .zero } set {} }
    public var uv3:LLPointFloat { get { .zero } set {} }
    public var uv4:LLPointFloat { get { .zero } set {} }

    public var position:LLPointFloat { get { .zero } set {} }
    public var cx:LLFloat { get { 0.0 } set {} }
    public var cy:LLFloat { get { 0.0 } set {} }
    
    public var scale:LLSizeFloat { get { .zero } set {} }
    public var width:Float { get { 0.0 } set {} }
    public var height:Float { get { 0.0 } set {} }
    
    public var angle:LLAngle { get { .zero } set {} }
    public var zIndex:LLFloat { get { 0.0 } set {} }
    public var enabled:Bool { get { false } set {} }
    public var life:Float { get { 0.0 } set {} }
    public var color:LLColor { get { .clear } set {} }
    public var alpha:Float { get { 0.0 } set {} }
    
    public var matrix:LLMatrix4x4 { get { .identity } set {} }
    
    public var deltaPosition:LLPointFloat { get { .zero } set {} }
    public var deltaScale:LLSizeFloat { get { .zero } set {} }
    public var deltaColor:LLColor { get { .clear } set {} }
    public var deltaAlpha:Float { get { 0.0 } set {} }
    public var deltaAngle:LLAngle { get { .zero } set {} }
    public var deltaLife:Float { get { 0.0 } set {} }
    
    public func atlasParts(of key: String) -> Self { return self }
    
    public func texture(_ tex: MTLTexture?) -> Self { return self }
    
    public func texture(_ tex: LLMetalTexture?) -> Self { return self }
}

// MARK: - 基本パラメータの各種メソッドチェーンアクセサ
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

    
    @discardableResult
    func position( _ p:LLPointFloat ) -> Self {
        position = LLPointFloat( p.x, p.y )
        return self
    }
    
    @discardableResult
    func position( _ p:LLPoint ) -> Self {
        position = LLPointFloat( p.x.f, p.y.f )
        return self
    }
    
    @discardableResult
    func position( cx:Float, cy:Float ) -> Self {
        position = LLPointFloat( cx, cy )
        return self
    }
    
    @discardableResult
    func position( cx:LLFloatConvertable, cy:LLFloatConvertable ) -> Self {
        return position( cx:cx.f, cy:cy.f )
    }
    
    @discardableResult
    func position( _ calc:( LBActor )->LLPointFloat ) -> Self {
        position = calc( self )
        return self
    }
    
    
    @discardableResult
    func cx( _ p:Float ) -> Self {
        position.x = p
        return self
    }
    
    @discardableResult
    func cx( _ p:LLFloatConvertable ) -> Self {
        return cx( p.f )
    }

    @discardableResult
    func cx( _ calc:( LBActor )->LLFloat ) -> Self {
        position.x = calc( self )
        return self
    }

    
    @discardableResult
    func cy( _ p:Float ) -> Self {
        position.y = p
        return self
    }
    
    @discardableResult
    func cy( _ p:LLFloatConvertable ) -> Self {
        return cy( p.f )
    }

    @discardableResult
    func cy( _ calc:( LBActor )->LLFloat ) -> Self {
        position.y = calc( self )
        return self
    }

    
    @discardableResult
    func scale( _ sz:LLSizeFloat ) -> Self {
        scale = LLSizeFloat( sz.width, sz.height )
        return self
    }
        
    @discardableResult
    func scale( width:Float, height:Float ) -> Self {
        scale = LLSizeFloat( width, height )
        return self
    }
    
    @discardableResult
    func scale( width:LLFloatConvertable, height:LLFloatConvertable ) -> Self {
        return scale( width:width.f, height:height.f )
    }
    
    @discardableResult
    func scale( _ calc:( LBActor )->LLSizeFloat ) -> Self {
        scale = calc( self )
        return self
    }
    
    @discardableResult
    func scale( square sz:Float ) -> Self {
        scale = LLSizeFloat( sz, sz )
        return self
    }
    
    @discardableResult
    func scale( square sz:LLFloatConvertable ) -> Self {
        scale = LLSizeFloat( sz.f, sz.f )
        return self
    }

    
    @discardableResult
    func width( _ v:Float ) -> Self {
        width = v
        return self
    }
    
    @discardableResult
    func width( _ v:LLFloatConvertable ) -> Self {
        return width( v.f )
    }

    @discardableResult
    func width( _ calc:( LBActor )->Float ) -> Self {
        width = calc( self )
        return self
    }

    
    @discardableResult
    func height( _ v:Float ) -> Self {
        height = v
        return self
    }
    
    @discardableResult
    func height( _ v:LLFloatConvertable ) -> Self {
        return height( v.f )
    }

    @discardableResult
    func height( _ calc:( LBActor )->Float ) -> Self {
        height = calc( self )
        return self
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
    func angle( _ calc:( LBActor )->LLAngle ) -> Self {
        angle = calc( self )
        return self
    }
    
    @discardableResult
    func angle<T:BinaryInteger>( _ calc:( LBActor )->T ) -> Self {
        angle = LLAngle( radians:Double( calc( self ) ) )
        return self
    }
    
    @discardableResult
    func angle<T:BinaryFloatingPoint>( _ calc:( LBActor )->T ) -> Self {
        angle = LLAngle( radians:Double( calc( self ) ) )
        return self
    }

    
    @discardableResult
    func zIndex( _ index:Float ) -> Self {
        zIndex = index
        return self
    }
    
    @discardableResult
    func zIndex( _ v:LLFloatConvertable ) -> Self {
        return zIndex( v.f )
    }
    
    @discardableResult
    func zIndex( _ calc:( LBActor )->Float ) -> Self {
        zIndex = calc( self )
        return self
    }

    
    @discardableResult
    func enabled( _ torf:Bool ) -> Self {
        enabled = torf
        return self
    }
    
    @discardableResult
    func enabled( _ calc:( LBActor )->Bool ) -> Self {
        enabled = calc( self )
        return self
    }

    
    @discardableResult
    func life( _ v:Float ) -> Self {
        life = v
        return self
    }
    
    @discardableResult
    func life( _ v:LLFloatConvertable ) -> Self {
        return life( v.f )
    }
    
    @discardableResult
    func life( _ calc:( LBActor )->Float ) -> Self {
        life = calc( self )
        return self
    }

    
    @discardableResult
    func color( _ c:LLColor ) -> Self {
        color = c
        return self
    }
    
    @discardableResult
    func color( red:Float, green:Float, blue:Float, alpha:Float = 1.0 ) -> Self {
        color = LLColor( red, green, blue, alpha )
        return self
    }
    
    @discardableResult
    func color( red:LLFloatConvertable, green:LLFloatConvertable,
                blue:LLFloatConvertable, alpha:LLFloatConvertable = 1.0 ) -> Self {
        return color( red:red.f, green:green.f, blue:blue.f, alpha:alpha.f )
    }
    
    @discardableResult
    func color( _ calc:( LBActor )->LLColor ) -> Self {
        color = calc( self )
        return self
    }

    
    @discardableResult
    func alpha( _ c:Float ) -> Self {
        alpha = c
        return self
    }
    
    @discardableResult
    func alpha( _ v:LLFloatConvertable ) -> Self {
        return alpha( v.f )
    }
    
    @discardableResult
    func alpha( _ calc:( LBActor )->Float ) -> Self {
        alpha = calc( self )
        return self
    }
    

    @discardableResult
    func matrix( _ mat:LLMatrix4x4 ) -> Self {
        matrix = mat
        return self
    }

    
    @discardableResult
    func deltaPosition( _ p:LLPointFloat ) -> Self {
        deltaPosition = LLPointFloat( p.x, p.y )
        return self
    }
    
    @discardableResult
    func deltaPosition( dx:Float, dy:Float ) -> Self {
        deltaPosition = LLPointFloat( dx, dy )
        return self
    }
    
    @discardableResult
    func deltaPosition( dx:LLFloatConvertable, dy:LLFloatConvertable ) -> Self {
        return deltaPosition( dx:dx.f, dy:dy.f )
    }
    
    @discardableResult
    func deltaPosition( _ calc:( LBActor )->LLPointFloat ) -> Self {
        deltaPosition = calc( self )
        return self
    }
    
    @discardableResult
    func deltaPosition<T:BinaryFloatingPoint>( _ calc:( LBActor )->(T,T) ) -> Self {
        let pos = calc( self )
        deltaPosition = LLPointFloat( Float(pos.0), Float(pos.1) )
        return self
    }

    
    @discardableResult
    func deltaScale( _ dsc:LLSizeFloat ) -> Self {
        deltaScale = LLSizeFloat( dsc.width, dsc.height )
        return self
    }
    
    @discardableResult
    func deltaScale( dw:Float, dh:Float ) -> Self {
        deltaScale = LLSizeFloat( dw, dh )
        return self
    }
    
    @discardableResult
    func deltaScale( dw:LLFloatConvertable, dh:LLFloatConvertable ) -> Self {
        return deltaScale( dw:dw.f, dh:dh.f )
    }
    
    @discardableResult
    func deltaScale( _ calc:( LBActor )->LLSizeFloat ) -> Self {
        deltaScale = calc( self )
        return self
    }

    @discardableResult
    func deltaColor( _ c:LLColor ) -> Self {
        deltaColor = c
        return self
    }
        
    @discardableResult
    func deltaColor( red:Float, green:Float, blue:Float, alpha:Float = 0.0 ) -> Self {
        deltaColor = LLColor( red, green, blue, alpha )
        return self
    }
    
    @discardableResult
    func deltaColor( red:LLFloatConvertable, green:LLFloatConvertable,
                     blue:LLFloatConvertable, alpha:LLFloatConvertable = 0.0 ) -> Self {
        return deltaColor( red:red.f, green:green.f, blue:blue.f, alpha:alpha.f )
    }

    
    @discardableResult
    func deltaAlpha( _ v:Float ) -> Self {
        deltaAlpha = v
        return self
    }
    
    @discardableResult
    func deltaAlpha( _ v:LLFloatConvertable ) -> Self {
        deltaAlpha = v.f
        return self
    }

    @discardableResult
    func deltaAlpha( _ calc:( LBActor )->Float ) -> Self {
        deltaAlpha = calc( self )
        return self
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
    func deltaAngle( _ calc:( LBActor )->LLAngle ) -> Self {
        deltaAngle = calc( self )
        return self
    }
    
    @discardableResult
    func deltaAngle<T:BinaryInteger>( _ calc:( LBActor )->T ) -> Self {
        deltaAngle = LLAngle( radians:Double( calc( self ) ) )
        return self
    }
    
    @discardableResult
    func deltaAngle<T:BinaryFloatingPoint>( _ calc:( LBActor )->T ) -> Self {
        deltaAngle = LLAngle( radians:Double( calc( self ) ) )
        return self
    }

    
    @discardableResult
    func deltaLife( _ v:Float ) -> Self {
        deltaLife = v
        return self
    }
    
    @discardableResult
    func deltaLife( _ v:LLFloatConvertable ) -> Self {
        deltaLife = v.f
        return self
    }

    @discardableResult
    func deltaLife( _ calc:( LBActor )->Float ) -> Self {
        deltaLife = calc( self )
        return self
    }
}
