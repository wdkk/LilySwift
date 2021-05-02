//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

import Metal

public extension LLColor8
{
    init( _ r:LLUInt8, _ g:LLUInt8, _ b:LLUInt8, _ a:LLUInt8 = LLColor8_MaxValue ) { 
        self.init( R: r, G: g, B: b, A: a )
    }
    
    init( red r:LLUInt8, green g:LLUInt8, blue b:LLUInt8, alpha a:LLUInt8 = LLColor8_MaxValue ) { 
        self.init( R: r, G: g, B: b, A: a )
    }
    
    init( _ hex:String ) {
        let c = LLHextoColor8( hex.lcStr )
        self.init( R: c.R, G: c.G, B: c.B, A: c.A )
    }
    
    var rgba16:LLColor16 { return LLColor8to16( self ) }
    
    var rgbaf:LLColor { return LLColor8tof( self ) }
    
    var hsvf:LLHSVf { return LLColor8toHSVf( self ) }
    
    var hsvi:LLHSVi { return LLColor8toHSVi( self ) }
    
    var metalColor:MTLClearColor {
        return self.rgbaf.metalColor
    }
    
    var cgColor:CGColor {
        return self.rgbaf.cgColor
    }    

    var floatv4:LLFloatv4 { 
        let cf = self.rgbaf
        return LLFloatv4( cf.R, cf.G, cf.B, cf.A )
    }
    
    static var random:LLColor8 { 
        return LLColor.random.rgba8
    }
}

public func == ( left:LLColor8, right:LLColor8 ) -> Bool { return LLColor8Equal( left, right ) }

public func != ( left:LLColor8, right:LLColor8 ) -> Bool { return !LLColor8Equal( left, right ) }


public extension LLColor16
{
    init( _ r:LLUInt16, _ g:LLUInt16, _ b:LLUInt16, _ a:LLUInt16 = LLColor16_MaxValue ) {
        self.init( R: r, G: g, B: b, A: a ) 
    }
    
    init( red r:LLUInt16, green g:LLUInt16, blue b:LLUInt16, alpha a:LLUInt16 = LLColor16_MaxValue ) {
        self.init( R: r, G: g, B: b, A: a ) 
    }
    
    init( _ hex:String ) {
        let c = LLColor8to16( LLHextoColor8( hex.lcStr ) )
        self.init( R: c.R, G: c.G, B: c.B, A: c.A )
    }
    
    var rgba8:LLColor8 { return LLColor16to8( self ) }
    
    var rgbaf:LLColor { return LLColor16tof( self ) }
    
    var hsvf:LLHSVf { return LLColor16toHSVf( self ) }
    
    var hsvi:LLHSVi { return LLColor16toHSVi( self ) }
    
    var metalColor:MTLClearColor {
        return self.rgbaf.metalColor
    }
    
    var cgColor:CGColor {
        return self.rgbaf.cgColor
    }
    
    var floatv4:LLFloatv4 { 
        let cf = self.rgbaf
        return LLFloatv4( cf.R, cf.G, cf.B, cf.A )
    }
    
    static var random:LLColor16 { 
        return LLColor.random.rgba16
    }
}

public func == ( left:LLColor16, right:LLColor16 ) -> Bool { return LLColor16Equal( left, right ) }

public func != ( left:LLColor16, right:LLColor16 ) -> Bool { return !LLColor16Equal( left, right ) }


public extension LLColor
{    
    init( _ r:Float, _ g:Float, _ b:Float, _ a:Float = LLColor_MaxValue ) {
        self.init( R: r, G: g, B: b, A: a )
    }
    

    init( red r:Float, green g:Float, blue b:Float, alpha a:Float = LLColor_MaxValue ) {
        self.init( R: r, G: g, B: b, A: a )
    }

    init( _ hex:String ) {
        let c = LLColor8tof( LLHextoColor8( hex.lcStr ) )
        self.init( R: c.R, G: c.G, B: c.B, A: c.A )
    }
    
    var rgba8:LLColor8 { return LLColorfto8( self ) }
    
    var rgba16:LLColor16 { return LLColorfto16( self ) }
    
    var hsvf:LLHSVf { return LLColorftoHSVf( self ) }
    
    var hsvi:LLHSVi { return LLColorftoHSVi( self ) }
    
    var metalColor:MTLClearColor {
        return MTLClearColor(red: self.R.d, green: self.G.d, blue: self.B.d, alpha: self.A.d )
    }
    
    var cgColor:CGColor {
        #if os(iOS)
        return UIColor( self.R.cgf, self.G.cgf, self.B.cgf, self.A.cgf ).cgColor
        #elseif os(macOS)
        return NSColor( self.R.cgf, self.G.cgf, self.B.cgf, self.A.cgf ).cgColor
        #endif
    }
    
    var floatv4:LLFloatv4 { 
        return LLFloatv4( self.R, self.G, self.B, self.A )
    }
    
    static var random:LLColor { 
        return LLColor( LLRandom(), LLRandom(), LLRandom(), 1.0 )
    }
}

public func == ( left:LLColor, right:LLColor ) -> Bool { return LLColorEqual( left, right ) }

public func != ( left:LLColor, right:LLColor ) -> Bool { return !LLColorEqual( left, right ) }

public extension LLHSVf
{  
    init( _ h:Float, _ s:Float, _ v:Float ) {
        self.init( H:h, S:s, V:v )
    }
    
    init( hue h:Float, saturation s:Float, value v:Float ) {
        self.init( H:h, S:s, V:v )
    }
    
    init( _ hex:String ) {
        let hsv = LLColor8toHSVf( LLHextoColor8( hex.lcStr ) )
        self.init( hsv.H, hsv.S, hsv.V )
    }
    
    var rgba8:LLColor8 { return LLHSVftoColor8( self ) }
    
    var rgba16:LLColor16 { return LLHSVftoColor16( self ) }
    
    var rgbaf:LLColor { return LLHSVftoColorf( self ) }
    
    var hsvi:LLHSVi { return LLHSVftoi( self ) }

    var metalColor:MTLClearColor {
        return self.rgbaf.metalColor
    }
    
    var cgColor:CGColor {
        return self.rgbaf.cgColor
    }
    
    var floatv4:LLFloatv4 { 
        let cf = self.rgbaf
        return LLFloatv4( cf.R, cf.G, cf.B, cf.A )
    }
    
    static var random:LLHSVf { 
        return LLColor.random.hsvf
    }
}

public extension LLHSVi
{  
    init( _ h:LLUInt16, _ s:LLUInt8, _ v:LLUInt8 ) {
        self.init( H:h, S:s, V:v )
    }
    
    init( hue h:LLUInt16, saturation s:LLUInt8, value v:LLUInt8 ) {
        self.init( H:h, S:s, V:v )
    }
    
    init( _ hex:String ) {
        let hsv = LLColor8toHSVi( LLHextoColor8( hex.lcStr ) )
        self.init( hsv.H, hsv.S, hsv.V )
    }
    
    var rgba8:LLColor8 { return LLHSVitoColor8( self ) }
    
    var rgba16:LLColor16 { return LLHSVitoColor16( self ) }
    
    var rgbaf:LLColor { return LLHSVitoColorf( self ) }
    
    var hsvf:LLHSVf { return LLHSVitof( self ) }
    
    var metalColor:MTLClearColor {
        return self.rgbaf.metalColor
    }
    
    var cgColor:CGColor {
        return self.rgbaf.cgColor
    }
    
    var floatv4:LLFloatv4 { 
        let cf = self.rgbaf
        return LLFloatv4( cf.R, cf.G, cf.B, cf.A )
    }
    
    static var random:LLHSVi { 
        return LLColor.random.hsvi
    }
}

