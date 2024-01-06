//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal
import simd

extension Lily.Stage.Playground3D
{   
    open class PGActor : Hashable
    {
        fileprivate static let Z_INDEX_MIN:Float = 0.0
        fileprivate static let Z_INDEX_MAX:Float = 99999.0
        
        public typealias Here = Lily.Stage.Playground3D
        // Hashableの実装
        public static func == ( lhs:PGActor, rhs:PGActor ) -> Bool { lhs === rhs }
        public func hash(into hasher: inout Hasher) { ObjectIdentifier( self ).hash( into: &hasher ) }
    
        public private(set) var index:Int
        public private(set) var pool:PGPool
        public private(set) var storage:Storage
        public private(set) var statusAccessor:UnsafeMutableBufferPointer<UnitStatus>?
        public private(set) var currentPointer:UnsafeMutablePointer<UnitStatus>!
                
        public var iterateField:PGField<PGActor, LLEmpty>?
        public var intervalField:ActorInterval?
        public var completionField:PGField<PGActor, LLEmpty>?
        
        public init( pool:PGPool = PGPool.current! ) {   
            self.pool = pool
            self.storage = pool.storage!
            self.statusAccessor = storage.statuses?.accessor
            
            self.index = storage.request() 

            self.currentPointer = self.statusAccessor!.baseAddress! + self.index
            
            if self.index < self.storage.capacity {
                status.state = .active
                status.enabled = true
                status.shapeType = .rectangle
            }
            else {
                status.state = .trush
                status.enabled = false
                status.shapeType = .rectangle
            }
            
            pool.insertShape( self )
        }
        
        public var status:UnitStatus {
            get { currentPointer.pointee }
            set { currentPointer.pointee = newValue }
        }
       
        @discardableResult
        public func iterate( _ f:@escaping ( PGActor )->Void ) -> Self {
            self.iterateField = PGField( me:self, action:f )
            return self
        }
        
        public func appearIterate() {
            self.iterateField?.appear()
        }
        
        @discardableResult
        public func interval( sec:Double, f:@escaping ( PGActor )->Void ) -> Self {
            self.intervalField = ActorInterval(
                sec:sec,
                prev:ActorTimer.shared.nowTime,
                field:PGField( me:self, action:f )
            )
            return self
        }
        
        public func appearInterval() {
            let now = ActorTimer.shared.nowTime
            
            guard let intv = self.intervalField else { return }
            if now - intv.prev >= intv.sec {
                intv.field.appear()
                self.intervalField?.prev = now
            }
        }
        
        @discardableResult
        public func stopInterval() -> Self {
            self.intervalField = nil
            return self
        }
        
        @discardableResult
        public func completion( _ f:@escaping ( PGActor )->Void ) -> Self {
            self.completionField = PGField( me:self, action:f )
            return self
        }
        
        public func appearCompletion() {
            self.completionField?.appear()
        }
        
        public func checkRemove() {
            if self.life <= 0.0 {
                self.iterateField = nil
                self.intervalField = nil
                self.completionField = nil
                
                trush()
            }
        }
        
        public func trush() {
            storage.trush( index:self.index )
            pool.removeShape( self )
        }
    }
}

// 内部クラスなど
extension Lily.Stage.Playground3D.PGActor
{
    public class ActorTimer
    {
        public static let shared = ActorTimer()
        private init() {}
        
        public private(set) var startTime:Double = 0.0
        public private(set) var nowTime:Double = 0.0
        
        public func start() {
            startTime = LLClock.now.d / 1000.0
            nowTime = startTime
        }
        
        public func update() {
            nowTime = LLClock.now.d / 1000.0
        }
        
        public var elapsedTime:Double { nowTime - startTime }
    }

    public struct ActorInterval
    {
        var sec:Double = 1.0
        var prev:Double = 0.0
        var field:Here.PGField<Here.PGActor, LLEmpty>
        
        public init(
            sec:Double,
            prev:Double, 
            field:Here.PGField<Here.PGActor, LLEmpty> 
        ) 
        {
            self.sec = sec
            self.prev = prev
            self.field = field
        }
    }
}

// プロパティ
extension Lily.Stage.Playground3D.PGActor
{
    public var position:LLFloatv3 { 
        get { return status.position }
        set { status.position = newValue }
    }
    
    public var cx:LLFloat {
        get { return status.position.x }
        set { status.position.x = newValue }
    }
    
    public var cy:LLFloat {
        get { return status.position.y }
        set { status.position.y = newValue }
    }
    
    public var scale:LLSizeFloat {
        get { return LLSizeFloat( status.scale.x, status.scale.y ) }
        set { status.scale = LLFloatv2( newValue.width, newValue.height ) }
    }
    
    public var width:Float {
        get { return status.scale.x }
        set { status.scale.x = newValue }
    }
    
    public var height:Float {
        get { return status.scale.y }
        set { status.scale.y = newValue }
    }
    
    public var angle:LLAngle {
        get { return LLAngle.radians( status.angle.d ) }
        set { status.angle = newValue.radians.f }
    }
    
    public var enabled:Bool { 
        get { if self.index < self.storage.capacity { return status.enabled } else { return false } }
        set { if self.index < self.storage.capacity { status.enabled = newValue } }
    }
    
    public var life:Float { 
        get { return status.life }
        set { status.life = newValue }
    }
    
    public var color:LLColor {
        get { return status.color.llColor }
        set { status.color = newValue.floatv4 }
    }
    
    public var alpha:Float {
        get { return status.color.w }
        set { status.color.w = newValue }
    }
    
    public var matrix:LLMatrix4x4 { 
        get { return status.matrix }
        set { status.matrix = newValue }
    }
    
    public var deltaPosition:LLFloatv3 { 
        get { return status.deltaPosition }
        set { status.deltaPosition = newValue }
    }
    
    public var deltaScale:LLSizeFloat { 
        get { return LLSizeFloat( status.deltaScale.x, status.deltaScale.y ) }
        set { status.deltaScale = LLFloatv2( newValue.width, newValue.height ) }
    }
    
    public var deltaColor:LLColor { 
        get { return status.deltaColor.llColor
        }
        set { status.deltaColor = newValue.floatv4 }
    }
    
    public var deltaAlpha:Float {
        get { return status.deltaColor.w }
        set { status.deltaColor.w = newValue }
    }
    
    public var deltaAngle:LLAngle {
        get { return LLAngle.radians( status.deltaAngle.d ) }
        set { status.deltaAngle = newValue.radians.f }
    }
    
    public var deltaLife:Float {
        get { return status.deltaLife }
        set { status.deltaLife = newValue }
    }
}

// MARK: - 基本パラメータ情報の各種メソッドチェーンアクセサ
extension Lily.Stage.Playground3D.PGActor
{
    @discardableResult
    public func position( _ p:LLFloatv3 ) -> Self {
        status.position = p
        return self
    }
    
    @discardableResult
    public func position( cx:Float, cy:Float, cz:Float ) -> Self {
        position = LLFloatv3( cx, cy, cz )
        return self
    }
    
    @discardableResult
    public func position( cx:LLFloatConvertable, cy:LLFloatConvertable, cz:LLFloatConvertable ) -> Self {
        status.position = LLFloatv3( cx.f, cy.f, cz.f )
        return self
    }
    
    @discardableResult
    public func position( _ calc:( Here.PGActor )->LLFloatv3 ) -> Self {
        let pf = calc( self )
        status.position = pf
        return self
    }
    
    
    @discardableResult
    public func cx( _ p:Float ) -> Self {
        status.position.x = p
        return self
    }
    
    @discardableResult
    public func cx( _ p:LLFloatConvertable ) -> Self {
        status.position.x = p.f
        return self
    }

    @discardableResult
    public func cx( _ calc:( Here.PGActor )->LLFloat ) -> Self {
        status.position.x = calc( self )
        return self
    }

    
    @discardableResult
    public func cy( _ p:Float ) -> Self {
        status.position.y = p
        return self
    }
    
    @discardableResult
    public func cy( _ p:LLFloatConvertable ) -> Self {
        status.position.y = p.f
        return self
    }

    @discardableResult
    public func cy( _ calc:( Here.PGActor )->LLFloat ) -> Self {
        status.position.y = calc( self )
        return self
    }
    
    @discardableResult
    public func cz( _ p:Float ) -> Self {
        status.position.z = p
        return self
    }
    
    @discardableResult
    public func cz( _ p:LLFloatConvertable ) -> Self {
        status.position.z = p.f
        return self
    }

    @discardableResult
    public func cz( _ calc:( Here.PGActor )->LLFloat ) -> Self {
        status.position.z = calc( self )
        return self
    }

    
    @discardableResult
    public func scale( _ sz:LLSizeFloat ) -> Self {
        status.scale = LLFloatv2( sz.width, sz.height )
        return self
    }
        
    @discardableResult
    public func scale( width:Float, height:Float ) -> Self {
        status.scale = LLFloatv2( width, height )
        return self
    }
    
    @discardableResult
    public func scale( width:LLFloatConvertable, height:LLFloatConvertable ) -> Self {
        status.scale = LLFloatv2( width.f, height.f )
        return self
    }
    
    @discardableResult
    public  func scale( _ calc:( Here.PGActor )->LLSizeFloat ) -> Self {
        let sf = calc( self )
        status.scale = LLFloatv2( sf.width, sf.height )
        return self
    }
    
    @discardableResult
    public func scale( square sz:Float ) -> Self {
        status.scale = LLFloatv2( sz, sz )
        return self
    }
    
    @discardableResult
    public func scale( square sz:LLFloatConvertable ) -> Self {
        status.scale = LLFloatv2( sz.f, sz.f )
        return self
    }

    
    @discardableResult
    public func width( _ v:Float ) -> Self {
        status.scale.x = v
        return self
    }
    
    @discardableResult
    public func width( _ v:LLFloatConvertable ) -> Self {
        status.scale.x = v.f
        return self
    }

    @discardableResult
    public func width( _ calc:( Here.PGActor )->Float ) -> Self {
        status.scale.x = calc( self )
        return self
    }

    
    @discardableResult
    public func height( _ v:Float ) -> Self {
        status.scale.y = v
        return self
    }
    
    @discardableResult
    public func height( _ v:LLFloatConvertable ) -> Self {
        status.scale.y = v.f
        return self
    }

    @discardableResult
    public func height( _ calc:( Here.PGActor )->Float ) -> Self {
        status.scale.y = calc( self )
        return self
    }

    
    @discardableResult
    public func angle( _ ang:LLAngle ) -> Self {
        status.angle = ang.radians.f
        return self
    }
    
    @discardableResult
    public func angle( radians rad:LLFloatConvertable ) -> Self {
        status.angle = rad.f
        return self
    }
    
    @discardableResult
    public func angle( degrees deg:LLFloatConvertable ) -> Self {
        status.angle = LLAngle( degrees: deg.f.d ).radians.f
        return self
    }
    
    @discardableResult
    public func angle( _ calc:( Here.PGActor )->LLAngle ) -> Self {
        let ang = calc( self )
        status.angle = ang.radians.f
        return self
    }
    
    @discardableResult
    public func angle<T:BinaryInteger>( _ calc:( Here.PGActor )->T ) -> Self {
        status.angle = Float( calc( self ) )
        return self
    }
    
    @discardableResult
    public func angle<T:BinaryFloatingPoint>( _ calc:( Here.PGActor )->T ) -> Self {
        status.angle = Float( calc( self ) )
        return self
    }
    
    @discardableResult
    public func enabled( _ torf:Bool ) -> Self {
        status.enabled = torf
        return self
    }
    
    @discardableResult
    public func enabled( _ calc:( Here.PGActor )->Bool ) -> Self {
        status.enabled = calc( self )
        return self
    }

    @discardableResult
    public func life( _ v:Float ) -> Self {
        status.life = v
        return self
    }
    
    @discardableResult
    public func life( _ v:LLFloatConvertable ) -> Self {
        status.life = v.f
        return self
    }
    
    @discardableResult
    public func life( _ calc:( Here.PGActor )->Float ) -> Self {
        status.life = calc( self )
        return self
    }

    
    @discardableResult
    public func color( _ c:LLColor ) -> Self {
        status.color = c.floatv4
        return self
    }
    
    @discardableResult
    public func color( red:Float, green:Float, blue:Float, alpha:Float = 1.0 ) -> Self {
        status.color = LLFloatv4( red, green, blue, alpha )
        return self
    }
    
    @discardableResult
    public func color( red:LLFloatConvertable, green:LLFloatConvertable,
                blue:LLFloatConvertable, alpha:LLFloatConvertable = 1.0 ) 
    -> Self
    {
        status.color = LLFloatv4( red.f, green.f, blue.f, alpha.f )
        return self
    }
    
    @discardableResult
    public func color( _ calc:( Here.PGActor )->LLColor ) -> Self {
        status.color = calc( self ).floatv4
        return self
    }

    
    @discardableResult
    public func alpha( _ c:Float ) -> Self {
        status.color.w = c
        return self
    }
    
    @discardableResult
    public func alpha( _ v:LLFloatConvertable ) -> Self {
        status.color.w = v.f
        return self
    }
    
    @discardableResult
    public func alpha( _ calc:( Here.PGActor )->Float ) -> Self {
        status.color.w = calc( self )
        return self
    }
    

    @discardableResult
    public func matrix( _ mat:LLMatrix4x4 ) -> Self {
        status.matrix = mat
        return self
    }

    
    @discardableResult
    public func deltaPosition( _ p:LLFloatv3 ) -> Self {
        status.deltaPosition = p
        return self
    }
    
    @discardableResult
    public func deltaPosition( dx:Float, dy:Float, dz:Float ) -> Self {
        status.deltaPosition = LLFloatv3( dx, dy, dz )
        return self
    }
    
    @discardableResult
    public func deltaPosition( dx:LLFloatConvertable, dy:LLFloatConvertable, dz:LLFloatConvertable ) -> Self {
        status.deltaPosition = LLFloatv3( dx.f, dy.f, dz.f )
        return self
    }
    
    @discardableResult
    public func deltaPosition( _ calc:( Here.PGActor )->LLFloatv3 ) -> Self {
        let pf = calc( self )
        status.deltaPosition = pf
        return self
    }
    
    @discardableResult
    public func deltaPosition<T:BinaryFloatingPoint>( _ calc:( Here.PGActor )->(T,T,T) ) -> Self {
        let pos = calc( self )
        status.deltaPosition = LLFloatv3( Float(pos.0), Float(pos.1), Float(pos.2) )
        return self
    }

    
    @discardableResult
    public func deltaScale( _ dsc:LLSizeFloat ) -> Self {
        status.deltaScale = LLFloatv2( dsc.width, dsc.height )
        return self
    }
    
    @discardableResult
    public func deltaScale( dw:Float, dh:Float ) -> Self {
        status.deltaScale = LLFloatv2( dw, dh )
        return self
    }
    
    @discardableResult
    public func deltaScale( dw:LLFloatConvertable, dh:LLFloatConvertable ) -> Self {
        status.deltaScale = LLFloatv2( dw.f, dh.f )
        return self
    }
    
    @discardableResult
    public func deltaScale( _ calc:( Here.PGActor )->LLSizeFloat ) -> Self {
        let sf = calc( self )
        status.deltaScale = LLFloatv2( sf.width, sf.height )
        return self
    }

    @discardableResult
    public func deltaColor( _ c:LLColor ) -> Self {
        status.deltaColor = c.floatv4
        return self
    }
        
    @discardableResult
    public func deltaColor( red:Float, green:Float, blue:Float, alpha:Float = 0.0 ) -> Self {
        status.deltaColor = LLFloatv4( red, green, blue, alpha )
        return self
    }
    
    @discardableResult
    public func deltaColor( red:LLFloatConvertable, green:LLFloatConvertable,
                     blue:LLFloatConvertable, alpha:LLFloatConvertable = 0.0 )
    -> Self
    {
        status.deltaColor = LLFloatv4( red.f, green.f, blue.f, alpha.f )
        return self
    }

    
    @discardableResult
    public func deltaAlpha( _ v:Float ) -> Self {
        status.deltaColor.w = v
        return self
    }
    
    @discardableResult
    public func deltaAlpha( _ v:LLFloatConvertable ) -> Self {
        status.deltaColor.w = v.f
        return self
    }

    @discardableResult
    public func deltaAlpha( _ calc:( Here.PGActor )->Float ) -> Self {
        status.deltaColor.w = calc( self )
        return self
    }

        
    @discardableResult
    public func deltaAngle( _ ang:LLAngle ) -> Self {
        status.deltaAngle = ang.radians.f
        return self
    }
    
    @discardableResult
    public func deltaAngle( radians rad:LLFloatConvertable ) -> Self {
        status.deltaAngle = rad.f
        return self
    }
    
    @discardableResult
    public func deltaAngle( degrees deg:LLFloatConvertable ) -> Self {
        status.deltaAngle = LLAngle.degrees( deg.f.d ).radians.f
        return self
    }
    
    @discardableResult
    public func deltaAngle( _ calc:( Here.PGActor )->LLAngle ) -> Self {
        status.deltaAngle = calc( self ).radians.f
        return self
    }
    
    @discardableResult
    public func deltaAngle<T:BinaryInteger>( _ calc:( Here.PGActor )->T ) -> Self {
        status.deltaAngle = Float( calc( self ) )
        return self
    }
    
    @discardableResult
    public func deltaAngle<T:BinaryFloatingPoint>( _ calc:( Here.PGActor )->T ) -> Self {
        status.deltaAngle = Float( calc( self ) )
        return self
    }

    
    @discardableResult
    public func deltaLife( _ v:Float ) -> Self {
        status.deltaLife = v
        return self
    }
    
    @discardableResult
    public func deltaLife( _ v:LLFloatConvertable ) -> Self {
        status.deltaLife = v.f
        return self
    }

    @discardableResult
    public func deltaLife( _ calc:( Here.PGActor )->Float ) -> Self {
        status.deltaLife = calc( self )
        return self
    }
}
