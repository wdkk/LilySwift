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

open class LBParticle : LBActor<LBParticleDecoration>
{
    public private(set) var index:Int
    private var _storage:LBParticleStorage
    
    public override init( decoration:LBParticleDecoration ) {
        // makeされていなかった場合を考慮してここでmakeする
        decoration.make()
        
        self.index = decoration.storage.request()
        self._storage = decoration.storage
        super.init( decoration:decoration )
    }
    
    deinit {
        params.state = .trush
    }

    public var vertice:LBParticleVertex {
        get { return _storage.points.vertex[index] }
        set { withUnsafeMutablePointer(to: &(_storage.points.vertex[index]) ) { $0.pointee = newValue } }
    }
    
    public var params:LBParticleParam {
        get { return _storage.params[index] }
        set { withUnsafeMutablePointer(to: &(_storage.params[index]) ) { $0.pointee = newValue } }
    }
}

// MARK: -
public extension LBParticle
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
    func position( _ calc:( LBParticle )->LLPointFloat ) -> Self {
        let pos = calc( self )
        params.position = LLFloatv2( pos.x, pos.y )
        return self
    }
}

// MARK: -
public extension LBParticle
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
    func cx( _ calc:( LBParticle )->LLFloat ) -> Self {
        params.position.x = calc( self )
        return self
    }
}

// MARK: -
public extension LBParticle
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
    func cy( _ calc:( LBParticle )->LLFloat ) -> Self {
        params.position.y = calc( self )
        return self
    }
}


// MARK: -
public extension LBParticle
{
    var scale:LLFloat {
        get { return params.scale }
        set { params.scale = newValue }
    }
    
    @discardableResult
    func scale( _ sz:LLFloat ) -> Self {
        params.scale = sz
        return self
    }
    
    
    @discardableResult
    func scale( _ fc:LLFloatConvertable ) -> Self {
        params.scale = fc.f
        return self
    }
    
    @discardableResult
    func scale( _ calc:( LBParticle )->LLFloat ) -> Self {
        let sz = calc( self )
        params.scale = sz
        return self
    }
}

// MARK: -
public extension LBParticle
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
    func enabled( _ calc:( LBParticle )->Bool ) -> Self {
        params.enabled = calc( self )
        return self
    }
}

// MARK: -
public extension LBParticle
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
    func life( _ calc:( LBParticle )->Float ) -> Self {
        params.life = calc( self )
        return self
    }
}

// MARK: -
public extension LBParticle
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
    func color( _ calc:( LBParticle )->LLColor ) -> Self {
        params.color = calc( self ).floatv4
        return self
    }
}

// MARK: -
public extension LBParticle
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
    func alpha( _ calc:( LBParticle )->Float ) -> Self {
        params.color.w = calc( self )
        return self
    }
}

// MARK: -
public extension LBParticle
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
public extension LBParticle
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
    func deltaPosition( _ calc:( LBParticle )->LLPointFloat ) -> Self {
        let pos = calc( self )
        params.deltaPosition = LLFloatv2( pos.x, pos.y )
        return self
    }
    
    @discardableResult
    func deltaPosition<T:BinaryFloatingPoint>( _ calc:( LBParticle )->(T,T) ) -> Self {
        let pos = calc( self )
        params.deltaPosition = LLFloatv2( Float(pos.0), Float(pos.1) )
        return self
    }
}

// MARK: -
public extension LBParticle
{
    var deltaScale:LLFloat { 
        get { return params.deltaScale }
        set { params.deltaScale = newValue }
    }
    
    @discardableResult
    func deltaScale( _ dsc:LLFloat ) -> Self {
        params.deltaScale = dsc
        return self
    }
    
    @discardableResult
    func deltaScale( dsc:LLFloatConvertable ) -> Self {
        return deltaScale( dsc.f )
    }
    
    @discardableResult
    func deltaScale( _ calc:( LBParticle )->LLFloat ) -> Self {
        params.deltaScale = calc( self )
        return self
    }
}

// MARK: -
public extension LBParticle
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
public extension LBParticle
{
    @discardableResult
    func texture( _ tex:MTLTexture? ) -> Self {
        guard let tex = tex else {
            self._storage.texture = nil
            return self
        }
        
        self._storage.texture = tex        
        return self
    } 

    @discardableResult
    func texture( _ tex:LLMetalTexture? ) -> Self {
        return texture( tex?.metalTexture )
    } 
}
