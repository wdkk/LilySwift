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

extension Lily.Stage.Playground.Model
{   
    open class MDActor : Hashable
    {
        public typealias Here = Lily.Stage.Playground.Model
        
        // Hashableの実装
        public static func == ( lhs:MDActor, rhs:MDActor ) -> Bool { lhs === rhs }
        public func hash(into hasher: inout Hasher) { ObjectIdentifier( self ).hash( into: &hasher ) }
    
        public private(set) var index:Int
        public private(set) var storage:ModelStorage?
        public private(set) var statusAccessor:UnsafeMutableBufferPointer<UnitStatus>?
        public private(set) var currentPointer:UnsafeMutablePointer<UnitStatus>?
                
        public var iterateField:MDFIeld<MDActor, LLEmpty>?
        public var intervalField:ActorInterval?
        public var completionField:MDFIeld<MDActor, LLEmpty>?
        
        public init( storage:ModelStorage?, assetName:String ) {   
            self.storage = storage
            
            guard let storage = storage else { 
                self.index = -1
                return 
            }
            
            self.statusAccessor = storage.statuses.accessor
            self.index = storage.request( assetName:assetName ) 
            self.currentPointer = statusAccessor!.baseAddress! + self.index
            
            if checkIndexStatus {
                status?.state = .active
                status?.enabled = true
            }
            else {
                status?.state = .trush
                status?.enabled = false
            }
            
            MDPool.shared.insert( shape:self, to:storage )
        }
        
        private var checkIndexStatus:Bool {
            guard let storage = self.storage else { return false }
            return self.index < storage.capacity
        }
        
        public var status:UnitStatus? {
            get { currentPointer?.pointee }
            set { if let v = newValue { currentPointer?.pointee = v } }
        }
       
        @discardableResult
        public func iterate( _ f:@escaping ( MDActor )->Void ) -> Self {
            self.iterateField = MDFIeld( me:self, action:f )
            return self
        }
        
        public func appearIterate() {
            self.iterateField?.appear()
        }
        
        @discardableResult
        public func interval( sec:Double, f:@escaping ( MDActor )->Void ) -> Self {
            self.intervalField = ActorInterval(
                sec:sec,
                prev:ActorTimer.shared.nowTime,
                field:MDFIeld( me:self, action:f )
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
        public func completion( _ f:@escaping ( MDActor )->Void ) -> Self {
            self.completionField = MDFIeld( me:self, action:f )
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
            MDPool.shared.remove( shape:self, to:storage )
        }
    }
}

// 内部クラスなど
extension Lily.Stage.Playground.Model.MDActor
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
        var field:Here.MDFIeld<Here.MDActor, LLEmpty>
        
        public init(
            sec:Double,
            prev:Double, 
            field:Here.MDFIeld<Here.MDActor, LLEmpty> 
        ) 
        {
            self.sec = sec
            self.prev = prev
            self.field = field
        }
    }
}

// プロパティ
extension Lily.Stage.Playground.Model.MDActor
{
    public var position:LLFloatv3 { 
        get { return status?.position ?? .zero }
        set { status?.position = newValue }
    }

    public var scale:LLFloatv3 {
        get { return status?.scale ?? .zero }
        set { status?.scale = newValue }
    }
    
    public var rotation:LLFloatv3 {
        get { return status?.rotation ?? .zero }
        set { status?.rotation = newValue }
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
        
    public var matrix:LLMatrix4x4 { 
        get { return status?.matrix ?? .identity }
        set { status?.matrix = newValue }
    }
    
    public var deltaPosition:LLFloatv3 { 
        get { return status?.deltaPosition ?? .zero }
        set { status?.deltaPosition = newValue }
    }
    
    public var deltaScale:LLFloatv3 { 
        get { return status?.deltaScale ?? .zero }
        set { status?.deltaScale = newValue }
    }
    
    public var deltaColor:LLColor { 
        get { return status?.deltaColor.llColor ?? .clear }
        set { status?.deltaColor = newValue.floatv4 }
    }
        
    public var deltaRotation:LLFloatv3 {
        get { return status?.deltaRotation ?? .zero }
        set { status?.deltaRotation = newValue }
    }
    
    public var deltaLife:Float {
        get { return status?.deltaLife ?? 0 }
        set { status?.deltaLife = newValue }
    }
}

// MARK: - 基本パラメータ情報の各種メソッドチェーンアクセサ
extension Lily.Stage.Playground.Model.MDActor
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
    public func scale( _ sc:LLFloatv3 ) -> Self {
        status?.scale = sc
        return self
    }
        
    @discardableResult
    public func scale( scx:Float, scy:Float, scz:Float ) -> Self {
        status?.scale = LLFloatv3( scx, scy, scz )
        return self
    }
    
    @discardableResult
    public func scale( x:LLFloatConvertable, y:LLFloatConvertable, z:LLFloatConvertable ) -> Self {
        status?.scale = LLFloatv3( x.f, y.f, z.f )
        return self
    }
    
    @discardableResult
    public func scale( equal sc:Float ) -> Self {
        status?.scale = LLFloatv3( sc, sc, sc )
        return self
    }
    
    @discardableResult
    public func scale( equal sc:LLFloatConvertable ) -> Self {
        status?.scale = LLFloatv3( sc.f, sc.f, sc.f )
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
    public func deltaScale( _ dsc:LLFloatv3 ) -> Self {
        status?.deltaScale = dsc
        return self
    }
    
    @discardableResult
    public func deltaScale( dx:Float, dy:Float, dz:Float ) -> Self {
        status?.deltaScale = LLFloatv3( dx, dy, dz )
        return self
    }
    
    @discardableResult
    public func deltaScale( dx:LLFloatConvertable, dy:LLFloatConvertable, dz:LLFloatConvertable ) -> Self {
        status?.deltaScale = LLFloatv3( dx.f, dy.f, dz.f )
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
