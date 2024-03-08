//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import CoreGraphics
import Metal
import simd

// MARK: - 値セット
public struct LLDual<T> {
    public var p1:T, p2:T
    public init( _ p1:T, _ p2:T ) {
        self.p1 = p1; self.p2 = p2
    }
}

public struct LLTriple<T> {
    public var p1:T, p2:T, p3:T
    public init( _ p1:T, _ p2:T, _ p3:T ) {
        self.p1 = p1; self.p2 = p2; self.p3 = p3
    }
}

public struct LLQuad<T> {
    public var p1:T, p2:T, p3:T, p4:T
    public init( _ p1:T, _ p2:T, _ p3:T, _ p4:T ) {
        self.p1 = p1; self.p2 = p2; self.p3 = p3; self.p4 = p4
    }
}

// MARK: - SIMD
public typealias LLIntv2 = vector_int2
public extension LLIntv2 
{
    static var zero:Self { return Self() }
}

public typealias LLIntv3 = vector_int3
public extension LLIntv3 
{    
    static var zero:Self { return Self() }
}

public typealias LLIntv4 = vector_int4
public extension LLIntv4 
{
    static var zero:Self { return Self() }
}

public typealias LLSizev2 = vector_int2
public extension LLSizev2 
{
    var width:Int32 { get { return x } set { x = newValue } }
    var height:Int32 { get { return y } set { y = newValue } }
}

public typealias LLSizev3 = vector_int3
public extension LLSizev3 
{
    var width:Int32 { get { return x } set { x = newValue } }
    var height:Int32 { get { return y } set { y = newValue } }
    var depth:Int32 { get { return z } set { z = newValue } }
}

public typealias LLFloatv2 = vector_float2
public typealias LLCoordUV = vector_float2
extension LLFloatv2
{
    public static var zero:Self { return Self() }
    public var normalize:Self { return simd_normalize( self ) }
    
    // uvでのアクセサ
    public var u:Float { get { self.x } set { self.x = newValue } }
    public var v:Float { get { self.y } set { self.y = newValue } }
}

public typealias LLFloatv3 = vector_float3
public extension LLFloatv3
{
    static var zero:Self { return Self() }
    var normalize:Self { return simd_normalize( self ) }
}

public typealias LLFloatv4 = vector_float4
public extension LLFloatv4 
{    
    static var zero:LLFloatv4 { return LLFloatv4() }
    var normalize:LLFloatv4 { return simd_normalize( self ) }
    
    var llColor:LLColor { return LLColor( x, y, z, w ) }
    
    var xyz:LLFloatv3 {
        get { LLFloatv3( x, y, z ) }
        set {
            x = newValue.x
            y = newValue.y
            z = newValue.z
        }
    }
}

// 3x3行列(48バイト)
public typealias LLMatrix3x3 = matrix_float3x3
public extension LLMatrix3x3
{
    var X:LLFloatv3 { get { return columns.0 } set { columns.0 = newValue } }
    var Y:LLFloatv3 { get { return columns.1 } set { columns.1 = newValue } }
    var Z:LLFloatv3 { get { return columns.2 } set { columns.2 = newValue } }
    
    init() {
        self.init( 0.0 )
    }
    
    // 単位行列
    static var identity:Self {
        return LLMatrix3x3([
            [ 1.0, 0.0, 0.0 ],
            [ 0.0, 1.0, 0.0 ],
            [ 0.0, 0.0, 1.0 ]
        ])
    }
}

// 4x4行列(64バイト)
public typealias LLMatrix4x4 = matrix_float4x4
public extension LLMatrix4x4
{
    var X:LLFloatv4 { get { return columns.0 } set { columns.0 = newValue } }
    var Y:LLFloatv4 { get { return columns.1 } set { columns.1 = newValue } }
    var Z:LLFloatv4 { get { return columns.2 } set { columns.2 = newValue } }
    var W:LLFloatv4 { get { return columns.3 } set { columns.3 = newValue } }
    
    init() {
        self.init( 0.0 )
    }
    
    // 単位行列
    static var identity:Self {
        return LLMatrix4x4( [
            [ 1.0, 0.0, 0.0, 0.0 ],
            [ 0.0, 1.0, 0.0, 0.0 ],
            [ 0.0, 0.0, 1.0, 0.0 ],
            [ 0.0, 0.0, 0.0, 1.0 ]
        ])
    }
    
    // 左上3x3行列の抽出
    var upperLeft3x3:LLMatrix3x3 {
      let x = columns.0.xyz
      let y = columns.1.xyz
      let z = columns.2.xyz
      return LLMatrix3x3(columns: (x, y, z))
    }
    
    // 平行移動
    static func translate(_ x:Float, _ y:Float, _ z:Float) -> Self {
        var mat:LLMatrix4x4 = .identity
        mat.W.x = x
        mat.W.y = y
        mat.W.z = z
        return mat
    }
    
    // 平行移動
    static func translate( vector pos:LLFloatv3 ) -> Self {
        return .translate( pos.x, pos.y, pos.z )
    }
    
    // 拡大縮小
    static func scale( _ x:Float, _ y:Float, _ z:Float ) -> Self {
        var mat:LLMatrix4x4 = .identity
        mat.X.x = x
        mat.Y.y = y
        mat.Z.z = z
        return mat
    }
    
    // 拡大縮小
    static func scale( vector sc:LLFloatv3 ) -> Self {
        return .scale( sc.x, sc.y, sc.z )
    }
    
    // 回転(三軸同時)
    static func rotate( vector angle:LLFloatv3 ) -> Self {      
        let rotation_x = LLMatrix4x4.rotateX( byAngle: angle.x )
        let rotation_y = LLMatrix4x4.rotateY( byAngle: angle.y )
        let rotation_z = LLMatrix4x4.rotateZ( byAngle: angle.z )
        return rotation_z * rotation_y * rotation_x
    }
    
    // 回転(三軸同時)
    static func rotate( axis: LLFloatv3, byAngle angle: Float ) -> Self {
        var mat:LLMatrix4x4 = .identity
        
        let c:Float = cos(angle)
        let s:Float = sin(angle)
        
        mat.X.x = axis.x * axis.x + (1 - axis.x * axis.x) * c
        mat.Y.x = axis.x * axis.y * (1 - c) - axis.z * s
        mat.Z.x = axis.x * axis.z * (1 - c) + axis.y * s
        
        mat.X.y = axis.x * axis.y * (1 - c) + axis.z * s
        mat.Y.y = axis.y * axis.y + (1 - axis.y * axis.y) * c
        mat.Z.y = axis.y * axis.z * (1 - c) - axis.x * s
        
        mat.X.z = axis.x * axis.z * (1 - c) - axis.y * s
        mat.Y.z = axis.y * axis.z * (1 - c) + axis.x * s
        mat.Z.z = axis.z * axis.z + (1 - axis.z * axis.z) * c
        
        return mat
    }
    
    static func rotateX(byAngle angle: Float) -> Self {
        var mat:LLMatrix4x4 = .identity
        
        let cosv:Float = cos(angle)
        let sinv:Float = sin(angle)
        
        mat.Y.y = cosv
        mat.Z.y = -sinv
        mat.Y.z = sinv
        mat.Z.z = cosv
        
        return mat
    }
    
    static func rotateY(byAngle angle: Float) -> Self {
        var mat:LLMatrix4x4 = .identity
        
        let cosv:Float = cos(angle)
        let sinv:Float = sin(angle)
        
        mat.X.x = cosv
        mat.Z.x = sinv
        mat.X.z = -sinv
        mat.Z.z = cosv
        
        return mat
    }
    
    static func rotateZ(byAngle angle: Float) -> Self {
        var mat:LLMatrix4x4 = .identity
        
        let cosv:Float = cos(angle)
        let sinv:Float = sin(angle)
        
        mat.X.x = cosv
        mat.Y.x = -sinv
        mat.X.y = sinv
        mat.Y.y = cosv
        
        return mat
    }
    
    static func affine2D( scale sc:LLFloatv2, angle ang:Float, translate t:LLFloatv2 ) -> Self {
        let sc3 = LLFloatv3( sc, 1.0 )
        let t3  = LLFloatv3( t, 0.0 )
        return translate( vector:t3 ) * rotateZ( byAngle:ang ) * scale( vector: sc3 );
    }
    
    static func affine3D( scale sc:LLFloatv3, rotate ro:LLFloatv3, translate t:LLFloatv3 ) -> Self {
        return translate( vector: t ) * rotate( vector: ro ) * scale( vector: sc );
    }
    
    // ピクセル座標系変換行列
    static func pixelUVProjection( wid:Int, hgt:Int ) -> Self {
        var vp_mat:LLMatrix4x4 = .identity
        vp_mat.X.x =  2.0 / Float(wid)
        vp_mat.Y.y = -2.0 / Float(hgt)
        vp_mat.W.x = -1.0
        vp_mat.W.y =  1.0
        return vp_mat
    }
    
    static func pixelUVProjection<T:BinaryInteger>( wid:T, hgt:T ) -> Self {
        return pixelUVProjection( wid: Int(wid), hgt: Int(hgt) )
    }
    
    static func pixelUVProjection<T:BinaryFloatingPoint>( wid:T, hgt:T ) -> Self {
        return pixelUVProjection( wid: Int(wid), hgt: Int(hgt) )
    }
    
    static func pixelUVProjection( _ size:CGSize ) -> Self {
        return pixelUVProjection( wid: Int(size.width), hgt: Int(size.height) )
    }
    
    static func pixelUVProjection( _ size:LLSize ) -> Self {
        return pixelUVProjection( wid: Int(size.width), hgt: Int(size.height) )
    }
    
    static func pixelXYProjection( wid:Int, hgt:Int ) -> Self {
        var vp_mat:LLMatrix4x4 = .identity
        vp_mat.X.x = 2.0 / Float(wid)
        vp_mat.Y.y = 2.0 / Float(hgt)
        return vp_mat
    }
    
    static func pixelXYProjection<T:BinaryInteger>( wid:T, hgt:T ) -> Self {
        return pixelXYProjection( wid: Int(wid), hgt: Int(hgt) )
    }
    
    static func pixelXYProjection<T:BinaryFloatingPoint>( wid:T, hgt:T ) -> Self {
        return pixelXYProjection( wid: Int(wid), hgt: Int(hgt) )
    }
    
    static func pixelXYProjection( _ size:CGSize ) -> Self {
        return pixelXYProjection( wid: Int(size.width), hgt: Int(size.height) )
    }
    
    static func pixelXYProjection( _ size:LLSize ) -> Self {
        return pixelXYProjection( wid: Int(size.width), hgt: Int(size.height) )
    }

    static func ortho(
        left l: Float,
        right r: Float,
        bottom b: Float,
        top t: Float,
        near n: Float,
        far f: Float ) 
    -> Self 
    {
        var mat:LLMatrix4x4 = .identity
        
        mat.X.x = 2.0 / (r-l)
        mat.W.x = (r+l) / (r-l)
        mat.Y.y = 2.0 / (t-b)
        mat.W.y = (t+b) / (t-b)
        mat.Z.z = -2.0 / (f-n)
        mat.W.z = (f+n) / (f-n)
        
        return mat
    }
    
    static func ortho2d( wid:Float, hgt:Float ) -> Self {
        return ortho( left: 0, right: wid, bottom: hgt, top: 0, near: -1, far: 1 )
    }
    
    // 透視投影変換行列
    static func perspectiveLeftHand(
        aspect: Float, 
        fieldOfViewYRadians: Float,
        near: Float, 
        far: Float ) 
    -> Self 
    {
        var mat:LLMatrix4x4 = LLMatrix4x4()
                
        let y = 1.0 / tan( fieldOfViewYRadians * 0.5 )
        let x = y / aspect
        let z = far / ( far - near )
        
        let X = LLFloatv4( x, 0, 0, 0 )
        let Y = LLFloatv4( 0, y, 0, 0 )
        let Z = LLFloatv4( 0, 0, z, 1 )
        let W = LLFloatv4( 0, 0, z * -near, 0 )
        
        mat.columns = ( X, Y, Z, W )
        
        return mat
    }
    
    // 透視投影変換行列
    static func perspectiveRightHand( 
        aspect: Float,
        fieldOfViewYRadians: Float,
        near: Float,
        far: Float 
    )
    -> Self 
    {
        var mat:LLMatrix4x4 = LLMatrix4x4()
                
        let y = 1.0 / tan( fieldOfViewYRadians * 0.5 )
        let x = y / aspect
        let z = far / ( near - far )
        
        let X = LLFloatv4( x, 0, 0, 0 )
        let Y = LLFloatv4( 0, y, 0, 0 )
        let Z = LLFloatv4( 0, 0, z, -1 )
        let W = LLFloatv4( 0, 0, z * near, 0 )
        
        mat.columns = ( X, Y, Z, W )

        return mat
    }
    
    static func perspectiveLeftHand( 
        aspect: Float, 
        fieldOfViewYDegrees: Float,
        near: Float, 
        far: Float
    )
    -> Self 
    {
        let fov_radians = fieldOfViewYDegrees * Float.pi / 180.0
        return Self.perspectiveLeftHand(
            aspect: aspect, 
            fieldOfViewYRadians: fov_radians,
            near: near,
            far: far )
    }
    
    static func perspectiveRightHand( aspect: Float, fieldOfViewYDegrees: Float, near: Float, far: Float ) -> Self 
    {
        let fov_radians = fieldOfViewYDegrees * Float.pi / 180.0
        return Self.perspectiveRightHand(
            aspect: aspect, 
            fieldOfViewYRadians: fov_radians,
            near: near,
            far: far )
    }
    
    static func perspectiveLeftHand( aspect:Float, fieldOfViewY:LLAngle, near:Float, far: Float, lhs:Bool = true ) -> Self 
    {
        let fov_radians = fieldOfViewY.radians.f
        return Self.perspectiveLeftHand(
            aspect: aspect, 
            fieldOfViewYRadians: fov_radians,
            near: near,
            far: far )
    }
    
    static func perspectiveRightHand( aspect:Float, fieldOfViewY:LLAngle, near:Float, far: Float, lhs:Bool = true ) -> Self 
    {
        let fov_radians = fieldOfViewY.radians.f
        return Self.perspectiveRightHand(
            aspect: aspect, 
            fieldOfViewYRadians: fov_radians,
            near: near,
            far: far )
    }
}
