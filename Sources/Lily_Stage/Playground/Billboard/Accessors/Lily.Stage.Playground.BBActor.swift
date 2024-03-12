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

extension Lily.Stage.Playground.Billboard
{   
    open class BBActor : Hashable
    {
        public typealias Here = Lily.Stage.Playground.Billboard
        
        // Hashableの実装
        public static func == ( lhs:BBActor, rhs:BBActor ) -> Bool { lhs === rhs }
        public func hash(into hasher: inout Hasher) { ObjectIdentifier( self ).hash( into: &hasher ) }
    
        public private(set) var index:Int
        public private(set) var storage:BBStorage?
        public private(set) var statusAccessor:UnsafeMutableBufferPointer<UnitStatus>?
        public private(set) var currentPointer:UnsafeMutablePointer<UnitStatus>?
                
        public var iterateField:BBField<BBActor, LLEmpty>?
        public var intervalField:ActorInterval?
        public var completionField:BBField<BBActor, LLEmpty>?
        
        public private(set) var parent:BBActor?
        
        public init( storage:BBStorage? ) {   
            self.storage = storage
            
            guard let storage = storage else { 
                self.index = -1
                return 
            }
            
            self.statusAccessor = storage.statuses.accessor
            self.index = storage.request() 
            self.currentPointer = statusAccessor!.baseAddress! + self.index
            
            if checkIndexStatus {
                status?.state = .active
                status?.enabled = true
                status?.shapeType = .rectangle
            }
            else {
                status?.state = .trush
                status?.enabled = false
                status?.shapeType = .rectangle
            }
            
            BBPool.shared.insert( shape:self, to:storage )
        }
        
        @discardableResult
        public func parent( _ actor:BBActor ) -> Self {
            self.parent = actor
            self.status?.childDepth = actor.status!.childDepth + 1
            return self
        }        
        
        public var childDepth:LLUInt32 {
            get { return status?.childDepth ?? 0 }
        }
        
        //// 
        
        private var checkIndexStatus:Bool {
            guard let storage = self.storage else { return false }
            return self.index < storage.capacity
        }
        
        public var status:UnitStatus? {
            get { currentPointer?.pointee }
            set { if let v = newValue { currentPointer?.pointee = v } }
        }
       
        @discardableResult
        public func iterate( _ f:@escaping ( BBActor )->Void ) -> Self {
            self.iterateField = BBField( me:self, action:f )
            return self
        }
        
        public func appearIterate() {
            self.iterateField?.appear()
        }
        
        @discardableResult
        public func interval( sec:Double, f:@escaping ( BBActor )->Void ) -> Self {
            self.intervalField = ActorInterval(
                sec:sec,
                prev:ActorTimer.shared.nowTime,
                field:BBField( me:self, action:f )
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
        public func completion( _ f:@escaping ( BBActor )->Void ) -> Self {
            self.completionField = BBField( me:self, action:f )
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
            storage?.trush( index:self.index )
            BBPool.shared.remove( shape:self, to:storage )
        }
    }
}

// 内部クラスなど
extension Lily.Stage.Playground.Billboard.BBActor
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
        var field:Here.BBField<Here.BBActor, LLEmpty>
        
        public init(
            sec:Double,
            prev:Double, 
            field:Here.BBField<Here.BBActor, LLEmpty> 
        ) 
        {
            self.sec = sec
            self.prev = prev
            self.field = field
        }
    }
}

// プロパティ
extension Lily.Stage.Playground.Billboard.BBActor
{
    public var position:LLFloatv3 { 
        get { return status?.position ?? .zero }
        set { status?.position = newValue }
    }
    
    public var cx:LLFloat {
        get { return status?.position.x ?? 0 }
        set { status?.position.x = newValue }
    }
    
    public var cy:LLFloat {
        get { return status?.position.y ?? 0 }
        set { status?.position.y = newValue }
    }
    
    public var cz:LLFloat {
        get { return status?.position.z ?? 0 }
        set { status?.position.z = newValue }
    }
    
    public var scale:LLFloatv3 {
        get { return status?.scale ?? .zero }
        set { status?.scale = newValue }
    }
    
    public var width:Float {
        get { return status?.scale.x ?? 0 }
        set { status?.scale.x = newValue }
    }
    
    public var height:Float {
        get { return status?.scale.y ?? 0 }
        set { status?.scale.y = newValue }
    }
    
    public var rotation:LLFloatv3 {
        get { return status?.rotation ?? .zero }
        set { status?.rotation = newValue }
    }
    
    public var angle:LLAngle {
        get { return LLAngle.radians( status?.angle.d ?? 0 ) }
        set { status?.angle = newValue.radians.f }
    }
    
    public var comboAngle:LLFloat {
        get { return status?.comboAngle ?? 0.0 }
        set { status?.comboAngle = newValue }
    }
    
    
    public var enabled:Bool { 
        get { checkIndexStatus ? ( status?.enabled ?? false ) : false }
        set { if checkIndexStatus { status?.enabled = newValue } }
    }
    
    public var life:Float { 
        get { return status?.life ?? 0 }
        set { status?.life = newValue }
    }
    
    public var color:LLColor {
        get { return status?.color.llColor ?? .clear }
        set { status?.color = newValue.floatv4 }
    }
    
    public var alpha:Float {
        get { return status?.color.w ?? 0 }
        set { status?.color.w = newValue }
    }
    
    public var matrix:LLMatrix4x4 { 
        get { return status?.matrix ?? .identity }
        set { status?.matrix = newValue }
    }
    
    public var deltaPosition:LLFloatv3 { 
        get { return status?.deltaPosition ?? .zero }
        set { status?.deltaPosition = newValue }
    }
    
    public var deltaScale:LLSizeFloat { 
        get { return LLSizeFloat( status?.deltaScale.x ?? 0, status?.deltaScale.y ?? 0 ) }
        set { status?.deltaScale = .init( newValue.width, newValue.height, 0.0 ) }
    }
    
    public var deltaColor:LLColor { 
        get { return status?.deltaColor.llColor ?? .clear }
        set { status?.deltaColor = newValue.floatv4 }
    }
    
    public var deltaAlpha:Float {
        get { return status?.deltaColor.w ?? 0 }
        set { status?.deltaColor.w = newValue }
    }
    
    public var deltaRotation:LLFloatv3 {
        get { return status?.deltaRotation ?? .zero }
        set { status?.deltaRotation = newValue }
    }
    
    public var deltaAngle:LLAngle {
        get { return LLAngle.radians( status?.deltaAngle.d ?? 0 ) }
        set { status?.deltaAngle = newValue.radians.f }
    }
    
    public var deltaLife:Float {
        get { return status?.deltaLife ?? 0 }
        set { status?.deltaLife = newValue }
    }
}

// MARK: - 基本パラメータ情報の各種メソッドチェーンアクセサ
extension Lily.Stage.Playground.Billboard.BBActor
{
    @discardableResult
    public func position( _ p:LLFloatv3 ) -> Self {
        status?.position = p
        return self
    }
    
    @discardableResult
    public func position( cx:Float, cy:Float, cz:Float ) -> Self {
        position = LLFloatv3( cx, cy, cz )
        return self
    }
    
    @discardableResult
    public func position( cx:LLFloatConvertable, cy:LLFloatConvertable, cz:LLFloatConvertable ) -> Self {
        status?.position = LLFloatv3( cx.f, cy.f, cz.f )
        return self
    }
    
    @discardableResult
    public func cx( _ p:Float ) -> Self {
        status?.position.x = p
        return self
    }
    
    @discardableResult
    public func cx( _ p:LLFloatConvertable ) -> Self {
        status?.position.x = p.f
        return self
    }
    
    @discardableResult
    public func cy( _ p:Float ) -> Self {
        status?.position.y = p
        return self
    }
    
    @discardableResult
    public func cy( _ p:LLFloatConvertable ) -> Self {
        status?.position.y = p.f
        return self
    }


    @discardableResult
    public func cz( _ p:Float ) -> Self {
        status?.position.z = p
        return self
    }
    
    @discardableResult
    public func cz( _ p:LLFloatConvertable ) -> Self {
        status?.position.z = p.f
        return self
    }


    
    @discardableResult
    public func scale( _ sz:LLSizeFloat ) -> Self {
        status?.scale = .init( sz.width, sz.height, status?.scale.z ?? 1.0 )
        return self
    }
        
    @discardableResult
    public func scale( width:Float, height:Float, depth:Float = 1.0 ) -> Self {
        status?.scale = .init( width, height, depth )
        return self
    }
    
    @discardableResult
    public func scale( width:LLFloatConvertable, height:LLFloatConvertable, depth:LLFloatConvertable = 1.0 ) -> Self {
        status?.scale = .init( width.f, height.f, depth.f )
        return self
    }
    
    @discardableResult
    public func scale( square sz:Float ) -> Self {
        status?.scale = .init( sz, sz, status?.scale.z ?? 1.0 )
        return self
    }
    
    @discardableResult
    public func scale( square sz:LLFloatConvertable ) -> Self {
        status?.scale = .init( sz.f, sz.f, status?.scale.z ?? 1.0 )
        return self
    }
    
    @discardableResult
    public func scale( cube sz:Float ) -> Self {
        status?.scale = .init( sz, sz, sz )
        return self
    }
    
    @discardableResult
    public func scale( cube sz:LLFloatConvertable ) -> Self {
        status?.scale = .init( sz.f, sz.f, sz.f )
        return self
    }
    
    @discardableResult
    public func scale( xyz:LLFloatv3 ) -> Self {
        status?.scale = xyz
        return self
    }
    
    @discardableResult
    public func scale( scx:LLFloat, scy:LLFloat, scz:LLFloat ) -> Self {
        status?.scale = .init( scx, scy, scz )
        return self
    }
    
    
    @discardableResult
    public func width( _ v:Float ) -> Self {
        status?.scale.x = v
        return self
    }
    
    @discardableResult
    public func width( _ v:LLFloatConvertable ) -> Self {
        status?.scale.x = v.f
        return self
    }

    
    @discardableResult
    public func height( _ v:Float ) -> Self {
        status?.scale.y = v
        return self
    }
    
    @discardableResult
    public func height( _ v:LLFloatConvertable ) -> Self {
        status?.scale.y = v.f
        return self
    }
    

    @discardableResult
    public func rotation( _ ro:LLFloatv3 ) -> Self {
        status?.rotation = ro
        return self
    }
    
    @discardableResult
    public func rotation( rx:Float, ry:Float, rz:Float ) -> Self {
        status?.rotation = .init( rx, ry, rz )
        return self
    }
    
    @discardableResult
    public func angle( _ ang:LLAngle ) -> Self {
        status?.angle = ang.radians.f
        return self
    }
    
    @discardableResult
    public func angle( radians rad:LLFloatConvertable ) -> Self {
        status?.angle = rad.f
        return self
    }
    
    @discardableResult
    public func angle( degrees deg:LLFloatConvertable ) -> Self {
        status?.angle = LLAngle( degrees: deg.f.d ).radians.f
        return self
    }

    @discardableResult
    public func enabled( _ torf:Bool ) -> Self {
        status?.enabled = torf
        return self
    }

    @discardableResult
    public func life( _ v:Float ) -> Self {
        status?.life = v
        return self
    }
    
    @discardableResult
    public func life( _ v:LLFloatConvertable ) -> Self {
        status?.life = v.f
        return self
    }
    
    
    @discardableResult
    public func color( _ c:LLColor ) -> Self {
        status?.color = c.floatv4
        return self
    }
    
    @discardableResult
    public func color( red:Float, green:Float, blue:Float, alpha:Float = 1.0 ) -> Self {
        status?.color = LLFloatv4( red, green, blue, alpha )
        return self
    }
    
    @discardableResult
    public func color( red:LLFloatConvertable, green:LLFloatConvertable,
                blue:LLFloatConvertable, alpha:LLFloatConvertable = 1.0 ) 
    -> Self
    {
        status?.color = LLFloatv4( red.f, green.f, blue.f, alpha.f )
        return self
    }
    
    
    @discardableResult
    public func alpha( _ c:Float ) -> Self {
        status?.color.w = c
        return self
    }
    
    @discardableResult
    public func alpha( _ v:LLFloatConvertable ) -> Self {
        status?.color.w = v.f
        return self
    }
    

    @discardableResult
    public func matrix( _ mat:LLMatrix4x4 ) -> Self {
        status?.matrix = mat
        return self
    }

    
    @discardableResult
    public func deltaPosition( _ p:LLFloatv3 ) -> Self {
        status?.deltaPosition = p
        return self
    }
    
    @discardableResult
    public func deltaPosition( dx:Float, dy:Float, dz:Float ) -> Self {
        status?.deltaPosition = LLFloatv3( dx, dy, dz )
        return self
    }
    
    @discardableResult
    public func deltaPosition( dx:LLFloatConvertable, dy:LLFloatConvertable, dz:LLFloatConvertable ) -> Self {
        status?.deltaPosition = LLFloatv3( dx.f, dy.f, dz.f )
        return self
    }
    
    
    @discardableResult
    public func deltaScale( _ dsc:LLSizeFloat ) -> Self {
        status?.deltaScale = .init( dsc.width, dsc.height, status?.deltaScale.z ?? 0.0 )
        return self
    }
    
    @discardableResult
    public func deltaScale( dw:Float, dh:Float ) -> Self {
        status?.deltaScale = .init( dw, dh, status?.deltaScale.z ?? 0.0 )
        return self
    }
    
    @discardableResult
    public func deltaScale( dw:LLFloatConvertable, dh:LLFloatConvertable ) -> Self {
        status?.deltaScale = .init( dw.f, dh.f, status?.deltaScale.z ?? 0.0 )
        return self
    }
    

    @discardableResult
    public func deltaColor( _ c:LLColor ) -> Self {
        status?.deltaColor = c.floatv4
        return self
    }
        
    @discardableResult
    public func deltaColor( red:Float, green:Float, blue:Float, alpha:Float = 0.0 ) -> Self {
        status?.deltaColor = LLFloatv4( red, green, blue, alpha )
        return self
    }
    
    @discardableResult
    public func deltaColor( red:LLFloatConvertable, green:LLFloatConvertable,
                     blue:LLFloatConvertable, alpha:LLFloatConvertable = 0.0 )
    -> Self
    {
        status?.deltaColor = LLFloatv4( red.f, green.f, blue.f, alpha.f )
        return self
    }

    
    @discardableResult
    public func deltaAlpha( _ v:Float ) -> Self {
        status?.deltaColor.w = v
        return self
    }
    
    @discardableResult
    public func deltaAlpha( _ v:LLFloatConvertable ) -> Self {
        status?.deltaColor.w = v.f
        return self
    }
        
    @discardableResult
    public func deltaRotation( _ ang:LLFloatv3 ) -> Self {
        status?.deltaRotation = ang
        return self
    }
    
    @discardableResult
    public func deltaRotation( rx:Float, ry:Float, rz:Float ) -> Self {
        status?.deltaRotation = .init( rx, ry, rz )
        return self
    }
    
    @discardableResult
    public func deltaAngle( _ ang:LLAngle ) -> Self {
        status?.deltaAngle = ang.radians.f
        return self
    }
    
    @discardableResult
    public func deltaAngle( radians rad:LLFloatConvertable ) -> Self {
        status?.deltaAngle = rad.f
        return self
    }
    
    @discardableResult
    public func deltaAngle( degrees deg:LLFloatConvertable ) -> Self {
        status?.deltaAngle = LLAngle.degrees( deg.f.d ).radians.f
        return self
    }
    
    
    @discardableResult
    public func deltaLife( _ v:Float ) -> Self {
        status?.deltaLife = v
        return self
    }
    
    @discardableResult
    public func deltaLife( _ v:LLFloatConvertable ) -> Self {
        status?.deltaLife = v.f
        return self
    }
}
