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

public protocol LBActorAccessor
{
    // MARK: - p1
    var p1:LLPointFloat { get set }

    @discardableResult
    func p1( _ p:LLPointFloat ) -> Self
        
    @discardableResult
    func p1( _ p:LLPoint ) -> Self
    
    @discardableResult
    func p1( x:Float, y:Float ) -> Self
        
    @discardableResult
    func p1( x:LLFloatConvertable, y:LLFloatConvertable ) -> Self
        
    @discardableResult
    func p1( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self

    
    // MARK: - p2
    var p2:LLPointFloat { get set }
    
    @discardableResult
    func p2( _ p:LLPointFloat ) -> Self
        
    @discardableResult
    func p2( _ p:LLPoint ) -> Self

    @discardableResult
    func p2( x:Float, y:Float ) -> Self
        
    @discardableResult
    func p2( x:LLFloatConvertable, y:LLFloatConvertable ) -> Self
        
    @discardableResult
    func p2( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self
    
    
    // MARK: - p3
    var p3:LLPointFloat { get set }

    @discardableResult
    func p3( _ p:LLPointFloat ) -> Self
        
    @discardableResult
    func p3( _ p:LLPoint ) -> Self
        
    @discardableResult
    func p3( x:Float, y:Float ) -> Self
        
    @discardableResult
    func p3( x:LLFloatConvertable, y:LLFloatConvertable ) -> Self 
        
    @discardableResult
    func p3( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self

    
    // MARK: - p4
    var p4:LLPointFloat { get set }
        
    @discardableResult
    func p4( _ p:LLPointFloat ) -> Self
        
    @discardableResult
    func p4( _ p:LLPoint ) -> Self
        
    @discardableResult
    func p4( x:Float, y:Float ) -> Self 
        
    @discardableResult
    func p4( x:LLFloatConvertable, y:LLFloatConvertable ) -> Self 
        
    @discardableResult
    func p4( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self 

    
    // MARK: - uv1
    var uv1:LLPointFloat { get set }
        
    func uv1( _ uv:LLPointFloat ) -> Self 
        
    @discardableResult
    func uv1( u:Float, v:Float ) -> Self
        
    @discardableResult
    func uv1( u:LLFloatConvertable, v:LLFloatConvertable ) -> Self
        
    @discardableResult
    func uv1( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self 


    // MARK: - uv2
    var uv2:LLPointFloat { get set }
        
    @discardableResult
    func uv2( _ uv:LLPointFloat ) -> Self
        
    @discardableResult
    func uv2( u:Float, v:Float ) -> Self
        
    @discardableResult
    func uv2( u:LLFloatConvertable, v:LLFloatConvertable ) -> Self
        
    @discardableResult
    func uv2( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self

    
    // MARK: - uv3
    var uv3:LLPointFloat { get set } 
        
    @discardableResult
    func uv3( _ uv:LLPointFloat ) -> Self
        
    @discardableResult
    func uv3( u:Float, v:Float ) -> Self
        
    @discardableResult
    func uv3( u:LLFloatConvertable, v:LLFloatConvertable ) -> Self
        
    @discardableResult
    func uv3( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self

    
    // MARK: - uv4
    var uv4:LLPointFloat { get set }
    
    @discardableResult
    func uv4( _ uv:LLPointFloat ) -> Self 
        
    @discardableResult
    func uv4( u:Float, v:Float ) -> Self
        
    @discardableResult
    func uv4( u:LLFloatConvertable, v:LLFloatConvertable ) -> Self 
        
    @discardableResult
    func uv4( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self 
    
    
    // MARK: - position
    var position:LLPointFloat { get set }
    
    @discardableResult
    func position( _ p:LLPointFloat ) -> Self
    
    @discardableResult
    func position( _ p:LLPoint ) -> Self
    
    @discardableResult
    func position( cx:Float, cy:Float ) -> Self
    
    @discardableResult
    func position( cx:LLFloatConvertable, cy:LLFloatConvertable ) -> Self
    
    @discardableResult
    func position( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self

    // MARK: - cx
    var cx:LLFloat { get set }
    
    @discardableResult
    func cx( _ p:Float ) -> Self 
    
    @discardableResult
    func cx( _ p:LLFloatConvertable ) -> Self 

    @discardableResult
    func cx( _ calc:( LBActorAccessor )->LLFloat ) -> Self

    var cy:LLFloat { get set }
    
    @discardableResult
    func cy( _ p:Float ) -> Self
    
    @discardableResult
    func cy( _ p:LLFloatConvertable ) -> Self

    @discardableResult
    func cy( _ calc:( LBActorAccessor )->LLFloat ) -> Self

    // MARK: - scale
    var scale:LLSizeFloat { get set }
    
    @discardableResult
    func scale( _ sz:LLSizeFloat ) -> Self
        
    @discardableResult
    func scale( width:Float, height:Float ) -> Self
    
    @discardableResult
    func scale( width:LLFloatConvertable, height:LLFloatConvertable ) -> Self
    
    @discardableResult
    func scale( _ calc:( LBActorAccessor )->LLSizeFloat ) -> Self
    
    @discardableResult
    func scale( square sz:Float ) -> Self
    
    @discardableResult
    func scale( square sz:LLFloatConvertable ) -> Self

    // MARK: - width
    var width:Float { get set }
    
    @discardableResult
    func width( _ v:Float ) -> Self
    
    @discardableResult
    func width( _ v:LLFloatConvertable ) -> Self

    @discardableResult
    func width( _ calc:( LBActorAccessor )->Float ) -> Self

    // MARK: - height
    var height:Float { get set }
    
    @discardableResult
    func height( _ v:Float ) -> Self
    
    @discardableResult
    func height( _ v:LLFloatConvertable ) -> Self

    @discardableResult
    func height( _ calc:( LBActorAccessor )->Float ) -> Self 

    // MARK: - angle
    var angle:LLAngle { get set }
    
    @discardableResult
    func angle( _ ang:LLAngle ) -> Self
    
    @discardableResult
    func angle( radians rad:LLFloatConvertable ) -> Self
    
    @discardableResult
    func angle( degrees deg:LLFloatConvertable ) -> Self 
    
    @discardableResult
    func angle( _ calc:( LBActorAccessor )->LLAngle ) -> Self
    
    @discardableResult
    func angle<T:BinaryInteger>( _ calc:( LBActorAccessor )->T ) -> Self
    
    @discardableResult
    func angle<T:BinaryFloatingPoint>( _ calc:( LBActorAccessor )->T ) -> Self
    
    // MARK: - zIndex
    var zIndex:LLFloat { get set }
    
    @discardableResult
    func zIndex( _ index:Float ) -> Self
    
    @discardableResult
    func zIndex( _ v:LLFloatConvertable ) -> Self
    
    @discardableResult
    func zIndex( _ calc:( LBActorAccessor )->Float ) -> Self

    // MARK: - enabled
    var enabled:Bool { get set }
    
    @discardableResult
    func enabled( _ torf:Bool ) -> Self
    
    @discardableResult
    func enabled( _ calc:( LBActorAccessor )->Bool ) -> Self 

    // MARK: - life
    var life:Float { get set }
    
    @discardableResult
    func life( _ v:Float ) -> Self
    
    @discardableResult
    func life( _ v:LLFloatConvertable ) -> Self
    
    @discardableResult
    func life( _ calc:( LBActorAccessor )->Float ) -> Self

    // MARK: - color
    var color:LLColor { get set }
    
    @discardableResult
    func color( _ c:LLColor ) -> Self
    
    @discardableResult
    func color( red:Float, green:Float, blue:Float, alpha:Float ) -> Self
    
    @discardableResult
    func color( red:LLFloatConvertable, green:LLFloatConvertable,
                blue:LLFloatConvertable, alpha:LLFloatConvertable ) -> Self 
    
    @discardableResult
    func color( _ calc:( LBActorAccessor )->LLColor ) -> Self

    // MARK: - alpha
    var alpha:Float { get set }
    
    @discardableResult
    func alpha( _ c:Float ) -> Self
    
    @discardableResult
    func alpha( _ v:LLFloatConvertable ) -> Self
    
    @discardableResult
    func alpha( _ calc:( LBActorAccessor )->Float ) -> Self

    // MARK: - matrix
    var matrix:LLMatrix4x4 { get set }
    
    @discardableResult
    func matrix( _ mat:LLMatrix4x4 ) -> Self 


    // MARK: - deltaPosition
    var deltaPosition:LLPointFloat { get set }
    
    @discardableResult
    func deltaPosition( _ p:LLPointFloat ) -> Self
    
    @discardableResult
    func deltaPosition( dx:Float, dy:Float ) -> Self
    
    @discardableResult
    func deltaPosition( dx:LLFloatConvertable, dy:LLFloatConvertable ) -> Self
    
    @discardableResult
    func deltaPosition( _ calc:( LBActorAccessor )->LLPointFloat ) -> Self 
    
    @discardableResult
    func deltaPosition<T:BinaryFloatingPoint>( _ calc:( LBActorAccessor )->(T,T) ) -> Self

    // MARK: - deltaScale
    var deltaScale:LLSizeFloat { get set }
    
    @discardableResult
    func deltaScale( _ dsc:LLSizeFloat ) -> Self 
    
    @discardableResult
    func deltaScale( dw:Float, dh:Float ) -> Self
    
    @discardableResult
    func deltaScale( dw:LLFloatConvertable, dh:LLFloatConvertable ) -> Self
    
    @discardableResult
    func deltaScale( _ calc:( LBActorAccessor )->LLSizeFloat ) -> Self 

    // MARK: - deltaColor
    var deltaColor:LLColor { get set }
    
    @discardableResult
    func deltaColor( _ c:LLColor ) -> Self 
    
    @discardableResult
    func deltaColor( red:Float, green:Float, blue:Float, alpha:Float ) -> Self
    
    @discardableResult
    func deltaColor( red:LLFloatConvertable, green:LLFloatConvertable,
                     blue:LLFloatConvertable, alpha:LLFloatConvertable ) -> Self
    
    // MARK: - deltaAlpha
    var deltaAlpha:Float { get set }
    
    @discardableResult
    func deltaAlpha( _ v:Float ) -> Self 
    
    @discardableResult
    func deltaAlpha( _ v:LLFloatConvertable ) -> Self

    @discardableResult
    func deltaAlpha( _ calc:( LBActorAccessor )->Float ) -> Self

    // MARK: - deltaAngle
    var deltaAngle:LLAngle { get set }
    
    @discardableResult
    func deltaAngle( _ ang:LLAngle ) -> Self
    
    @discardableResult
    func deltaAngle( radians rad:LLFloatConvertable ) -> Self
    
    @discardableResult
    func deltaAngle( degrees deg:LLFloatConvertable ) -> Self 
    
    @discardableResult
    func deltaAngle( _ calc:( LBActorAccessor )->LLAngle ) -> Self 
    
    @discardableResult
    func deltaAngle<T:BinaryInteger>( _ calc:( LBActorAccessor )->T ) -> Self
    
    @discardableResult
    func deltaAngle<T:BinaryFloatingPoint>( _ calc:( LBActorAccessor )->T ) -> Self

    // MARK: - deltaLife
    var deltaLife:Float { get set }
    
    @discardableResult
    func deltaLife( _ v:Float ) -> Self
    
    @discardableResult
    func deltaLife( _ v:LLFloatConvertable ) -> Self

    @discardableResult
    func deltaLife( _ calc:( LBActorAccessor )->Float ) -> Self 

    // MARK: - atlasParts
    @discardableResult
    func atlasParts( of key:String ) -> Self

    // MARK: - texture
    @discardableResult
    func texture( _ tex:MTLTexture? ) -> Self 

    @discardableResult
    func texture( _ tex:LLMetalTexture? ) -> Self 
}
