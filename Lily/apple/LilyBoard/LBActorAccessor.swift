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
    @discardableResult
    func p1( _ p:LLPointFloat ) -> Self
    
    @discardableResult
    func p1( _ p:LLPoint ) -> Self
    
    @discardableResult
    func p1( x:Float, y:Float ) -> Self
        
    @discardableResult
    func p1( x:LLFloatConvertable, y:LLFloatConvertable ) -> Self
        
    //@discardableResult
    //func p1( _ calc:( Self )->LLPointFloat ) -> Self

    
    // MARK: - p2 
    @discardableResult
    func p2( _ p:LLPointFloat ) -> Self
        
    @discardableResult
    func p2( _ p:LLPoint ) -> Self

    @discardableResult
    func p2( x:Float, y:Float ) -> Self
        
    @discardableResult
    func p2( x:LLFloatConvertable, y:LLFloatConvertable ) -> Self
        
    //@discardableResult
    //func p2( _ calc:( Self )->LLPointFloat ) -> Self
    
    
    // MARK: - p3
    @discardableResult
    func p3( _ p:LLPointFloat ) -> Self
        
    @discardableResult
    func p3( _ p:LLPoint ) -> Self
        
    @discardableResult
    func p3( x:Float, y:Float ) -> Self
        
    @discardableResult
    func p3( x:LLFloatConvertable, y:LLFloatConvertable ) -> Self 
        
    //@discardableResult
    //func p3( _ calc:( Self )->LLPointFloat ) -> Self

    
    // MARK: - p4      
    @discardableResult
    func p4( _ p:LLPointFloat ) -> Self
        
    @discardableResult
    func p4( _ p:LLPoint ) -> Self
        
    @discardableResult
    func p4( x:Float, y:Float ) -> Self 
        
    @discardableResult
    func p4( x:LLFloatConvertable, y:LLFloatConvertable ) -> Self 
        
    //@discardableResult
    //func p4( _ calc:( Self )->LLPointFloat ) -> Self 

    
    // MARK: - uv1    
    func uv1( _ uv:LLPointFloat ) -> Self 
        
    @discardableResult
    func uv1( u:Float, v:Float ) -> Self
        
    @discardableResult
    func uv1( u:LLFloatConvertable, v:LLFloatConvertable ) -> Self
        
    //@discardableResult
    //func uv1( _ calc:( Self )->LLPointFloat ) -> Self 


    // MARK: - uv2      
    @discardableResult
    func uv2( _ uv:LLPointFloat ) -> Self
        
    @discardableResult
    func uv2( u:Float, v:Float ) -> Self
        
    @discardableResult
    func uv2( u:LLFloatConvertable, v:LLFloatConvertable ) -> Self
        
    //@discardableResult
    //func uv2( _ calc:( Self )->LLPointFloat ) -> Self

    
    // MARK: - uv3     
    @discardableResult
    func uv3( _ uv:LLPointFloat ) -> Self
        
    @discardableResult
    func uv3( u:Float, v:Float ) -> Self
        
    @discardableResult
    func uv3( u:LLFloatConvertable, v:LLFloatConvertable ) -> Self
        
    //@discardableResult
    //func uv3( _ calc:( Self )->LLPointFloat ) -> Self

    
    // MARK: - uv4  
    @discardableResult
    func uv4( _ uv:LLPointFloat ) -> Self 
        
    @discardableResult
    func uv4( u:Float, v:Float ) -> Self
        
    @discardableResult
    func uv4( u:LLFloatConvertable, v:LLFloatConvertable ) -> Self 
        
    //@discardableResult
    //func uv4( _ calc:( Self )->LLPointFloat ) -> Self 
    
    
    // MARK: - position 
    @discardableResult
    func position( _ p:LLPointFloat ) -> Self
    
    @discardableResult
    func position( _ p:LLPoint ) -> Self
    
    @discardableResult
    func position( cx:Float, cy:Float ) -> Self
    
    @discardableResult
    func position( cx:LLFloatConvertable, cy:LLFloatConvertable ) -> Self
    
    //@discardableResult
    //func position( _ calc:( Self )->LLPointFloat ) -> Self

    // MARK: - cx
    @discardableResult
    func cx( _ p:Float ) -> Self 
    
    @discardableResult
    func cx( _ p:LLFloatConvertable ) -> Self 

    //@discardableResult
    //func cx( _ calc:( Self )->LLFloat ) -> Self

    // MARK: - cy   
    @discardableResult
    func cy( _ p:Float ) -> Self
    
    @discardableResult
    func cy( _ p:LLFloatConvertable ) -> Self

    //@discardableResult
    //func cy( _ calc:( Self )->LLFloat ) -> Self

    // MARK: - scale
    @discardableResult
    func scale( _ sz:LLSizeFloat ) -> Self
        
    @discardableResult
    func scale( width:Float, height:Float ) -> Self
    
    @discardableResult
    func scale( width:LLFloatConvertable, height:LLFloatConvertable ) -> Self
    
    //@discardableResult
    //func scale( _ calc:( Self )->LLSizeFloat ) -> Self
    
    @discardableResult
    func scale( square sz:Float ) -> Self
    
    @discardableResult
    func scale( square sz:LLFloatConvertable ) -> Self

    // MARK: - width
    @discardableResult
    func width( _ v:Float ) -> Self
    
    @discardableResult
    func width( _ v:LLFloatConvertable ) -> Self

    //@discardableResult
    //func width( _ calc:( Self )->Float ) -> Self

    // MARK: - height
    @discardableResult
    func height( _ v:Float ) -> Self
    
    @discardableResult
    func height( _ v:LLFloatConvertable ) -> Self

    //@discardableResult
    //func height( _ calc:( Self )->Float ) -> Self 

    // MARK: - angle  
    @discardableResult
    func angle( _ ang:LLAngle ) -> Self
    
    @discardableResult
    func angle( radians rad:LLFloatConvertable ) -> Self
    
    @discardableResult
    func angle( degrees deg:LLFloatConvertable ) -> Self 
    
    //@discardableResult
    //func angle( _ calc:( Self )->LLAngle ) -> Self
    
    //@discardableResult
    //func angle<T:BinaryInteger>( _ calc:( Self )->T ) -> Self
    
    //@discardableResult
    //func angle<T:BinaryFloatingPoint>( _ calc:( Self )->T ) -> Self
    
    // MARK: - zIndex
    @discardableResult
    func zIndex( _ index:Float ) -> Self
    
    @discardableResult
    func zIndex( _ v:LLFloatConvertable ) -> Self
    
    //@discardableResult
    //func zIndex( _ calc:( Self )->Float ) -> Self

    // MARK: - enabled
    @discardableResult
    func enabled( _ torf:Bool ) -> Self
    
    //@discardableResult
    //func enabled( _ calc:( Self )->Bool ) -> Self 

    // MARK: - life
    @discardableResult
    func life( _ v:Float ) -> Self
    
    @discardableResult
    func life( _ v:LLFloatConvertable ) -> Self
    
    //@discardableResult
    //func life( _ calc:( Self )->Float ) -> Self

    // MARK: - color 
    @discardableResult
    func color( _ c:LLColor ) -> Self
    
    @discardableResult
    func color( red:Float, green:Float, blue:Float, alpha:Float ) -> Self
    
    @discardableResult
    func color( red:LLFloatConvertable, green:LLFloatConvertable,
                blue:LLFloatConvertable, alpha:LLFloatConvertable ) -> Self 
    
    //@discardableResult
    //func color( _ calc:( Self )->LLColor ) -> Self

    // MARK: - alpha
    @discardableResult
    func alpha( _ c:Float ) -> Self
    
    @discardableResult
    func alpha( _ v:LLFloatConvertable ) -> Self
    
    //@discardableResult
    //func alpha( _ calc:( Self )->Float ) -> Self

    // MARK: - matrix
    @discardableResult
    func matrix( _ mat:LLMatrix4x4 ) -> Self 


    // MARK: - deltaPosition
    @discardableResult
    func deltaPosition( _ p:LLPointFloat ) -> Self
    
    @discardableResult
    func deltaPosition( dx:Float, dy:Float ) -> Self
    
    @discardableResult
    func deltaPosition( dx:LLFloatConvertable, dy:LLFloatConvertable ) -> Self
    
    //@discardableResult
    //func deltaPosition( _ calc:( Self )->LLPointFloat ) -> Self 
    
    //@discardableResult
    //func deltaPosition<T:BinaryFloatingPoint>( _ calc:( Self )->(T,T) ) -> Self

    // MARK: - deltaScale  
    @discardableResult
    func deltaScale( _ dsc:LLSizeFloat ) -> Self 
    
    @discardableResult
    func deltaScale( dw:Float, dh:Float ) -> Self
    
    @discardableResult
    func deltaScale( dw:LLFloatConvertable, dh:LLFloatConvertable ) -> Self
    
    //@discardableResult
    //func deltaScale( _ calc:( Self )->LLSizeFloat ) -> Self 

    // MARK: - deltaColor 
    @discardableResult
    func deltaColor( _ c:LLColor ) -> Self 
    
    @discardableResult
    func deltaColor( red:Float, green:Float, blue:Float, alpha:Float ) -> Self
    
    @discardableResult
    func deltaColor( red:LLFloatConvertable, green:LLFloatConvertable,
                     blue:LLFloatConvertable, alpha:LLFloatConvertable ) -> Self
    
    // MARK: - deltaAlpha
    @discardableResult
    func deltaAlpha( _ v:Float ) -> Self 
    
    @discardableResult
    func deltaAlpha( _ v:LLFloatConvertable ) -> Self

    //@discardableResult
    //func deltaAlpha( _ calc:( Self )->Float ) -> Self

    // MARK: - deltaAngle
    @discardableResult
    func deltaAngle( _ ang:LLAngle ) -> Self
    
    @discardableResult
    func deltaAngle( radians rad:LLFloatConvertable ) -> Self
    
    @discardableResult
    func deltaAngle( degrees deg:LLFloatConvertable ) -> Self 
    
    //@discardableResult
    //func deltaAngle( _ calc:( Self )->LLAngle ) -> Self 
    
    //@discardableResult
    //func deltaAngle<T:BinaryInteger>( _ calc:( Self )->T ) -> Self
    
    //@discardableResult
    //func deltaAngle<T:BinaryFloatingPoint>( _ calc:( Self )->T ) -> Self

    // MARK: - deltaLife  
    @discardableResult
    func deltaLife( _ v:Float ) -> Self
    
    @discardableResult
    func deltaLife( _ v:LLFloatConvertable ) -> Self

    //@discardableResult
    //func deltaLife( _ calc:( Self )->Float ) -> Self 

    // MARK: - atlasParts
    @discardableResult
    func atlasParts( of key:String ) -> Self

    // MARK: - texture
    @discardableResult
    func texture( _ tex:MTLTexture? ) -> Self 

    @discardableResult
    func texture( _ tex:LLMetalTexture? ) -> Self
}
