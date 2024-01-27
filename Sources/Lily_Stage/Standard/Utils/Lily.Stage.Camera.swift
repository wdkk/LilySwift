//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import MetalKit
import simd

extension Lily.Stage
{
    // カメラ設定
    public struct Camera
    {
        // MARK: - パラメータ
        public var viewAngle:Float
            
        public var width:Float
        
        public var direction:LLFloatv3 = .zero
        
        public var position:LLFloatv3
        
        private var _up:LLFloatv3 = .zero
        public var up:LLFloatv3 {
            get { return _up }
            set { 
                self.orthogonalize( fromUp:newValue )
            }
        }
        
        public var near:Float
    
        public var far:Float

        public var aspect:Float
     
        // MARK: - アクセサ
        public var left:LLFloatv3 { simd_cross( direction, up ) }
        
        public var right:LLFloatv3 { -left }
        
        public var down:LLFloatv3 { -up }
        
        public var forward:LLFloatv3 { direction }
        
        public var backward:LLFloatv3 { -direction }
    
        public var isPerspective:Bool { return viewAngle != 0.0 }
       
        public var isParallel:Bool { return viewAngle == 0.0 }
        
        public func calcViewMatrix() -> LLMatrix4x4 { 
            return Self.invMatrixLookat( position, position + direction, up ) 
        }
        
        public func calcProjectionMatrix() -> LLMatrix4x4 {
            if viewAngle != 0 {
                let va_tan = 1.0 / tanf(viewAngle * 0.5)
                let ys = va_tan
                let xs = ys / aspect
                let zs = far / (near - far)
                let ws = near * zs
                
                return LLMatrix4x4(
                    LLFloatv4( xs,  0,  0,  0 ),
                    LLFloatv4( 0,  ys,  0,  0 ),
                    LLFloatv4( 0,   0, zs, -1 ),
                    LLFloatv4( 0,   0, ws,  0 ) 
                )
            }
            // TODO: シャドウカメラ用の行列?
            else {
                let ys = 2.0 / width
                let xs = ys / aspect
                let zs = 1.0 / (near - far)
                let ws = near * zs
                
                return LLMatrix4x4(
                    LLFloatv4( xs,  0,  0,  0 ),
                    LLFloatv4( 0,  ys,  0,  0 ),
                    LLFloatv4( 0,   0, zs,  0 ),
                    LLFloatv4( 0,   0, ws,  1 ) 
                )
            }
        }
        
        public func calcOrientationMatrix() -> LLMatrix4x4 {
            return Camera.invMatrixLookat( .zero, self.direction, self.up )
        }
        
        public mutating func rotate( on axis:LLFloatv3, radians:Float ) {
            let axis = normalize( axis )
            let cosv = cosf( radians )
            let sinv = sinf( radians )
            let inv_cosv = 1.0 - cosv
            let x = axis.x
            let y = axis.y
            let z = axis.z
            
            let mat = LLMatrix3x3( 
                LLFloatv3( cosv + x * x * inv_cosv,     y * x * inv_cosv + z * sinv, z * x * inv_cosv - y * sinv ),
                LLFloatv3( x * y * inv_cosv - z * sinv, cosv + y * y * inv_cosv,     z * y * inv_cosv + x * sinv ),
                LLFloatv3( x * z * inv_cosv + y * sinv, y * z * inv_cosv - x * sinv, cosv + z * z * inv_cosv     ) 
            )

            direction = simd_mul( direction, mat )
            up = simd_mul( up, mat )
        }
        
        private mutating func orthogonalize( fromUp up:LLFloatv3 ) {
            _up = normalize( up )
            let right = normalize( cross( direction, _up ) )
            direction = ( cross( _up, right ) )
        }

        private mutating func orthogonalize( fromForward forward:LLFloatv3 ) {
            direction = normalize( forward )
            let right = normalize( cross( direction, up ) )
            up = cross( right, direction )
        }
        
        public static func invMatrixLookat( _ eye:LLFloatv3, _ to:LLFloatv3, _ up:LLFloatv3 ) -> LLMatrix4x4 {
            //let z = normalize( to - eye )
            let z = normalize( eye - to )
            let x = normalize( cross( up, z ) )
            let y = cross( z, x )
            let t = LLFloatv3( -dot(x, eye), -dot(y, eye), -dot(z, eye) )
            return LLMatrix4x4( 
                LLFloatv4( x.x, y.x, z.x, 0 ),
                LLFloatv4( x.y, y.y, z.y, 0 ),
                LLFloatv4( x.z, y.z, z.z, 0 ),
                LLFloatv4( t.x, t.y, t.z, 1 )
            )
        }

        private func normaizePlane( _ plane:LLFloatv4 ) -> LLFloatv4 {
            return plane / simd_length( plane.xyz )
        }
        
        public init( 
            perspectiveWith position:LLFloatv3,
            direction:LLFloatv3,
            up:LLFloatv3,
            viewAngle:Float,
            aspectRatio:Float,
            near:Float,
            far:Float 
        ) 
        {
            self._up = up
            self.position = position
            self.width = 0
            self.viewAngle = viewAngle
            self.aspect = aspectRatio
            self.near = near
            self.far = far
            
            self.orthogonalize( fromForward:direction )
        }
        
        public init(
            parallelWith position:LLFloatv3,
            direction:LLFloatv3,
            up:LLFloatv3,
            width:Float,
            height:Float,
            near:Float,
            far:Float 
        )
        {
            self._up = up
            self.position = position
            self.width = width
            self.viewAngle = 0
            self.aspect = width / height
            self.near = near
            self.far = far
        
            self.orthogonalize( fromForward:direction )
        }
    }
}
