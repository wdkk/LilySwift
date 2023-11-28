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

extension Lily.Stage.Playground2D
{   
    public class PGField<TMe:AnyObject, TObj>
    : LLField
    {    
        public private(set) var relayFunc:((TObj)->Void)?
        
        public init( me:TMe, action:@escaping (TMe)->Void )
        where TObj == LLEmpty
        {
            self.relayFunc = { [weak me] ( objs:TObj ) in
                guard let me:TMe = me else { return }
                action( me )
            }
        }
        
        public init( me:TMe, action:@escaping (TMe, TObj)->Void )
        {
            self.relayFunc = { [weak me] ( objs:TObj ) in
                guard let me:TMe = me else { return }
                action( me, objs )
            }
        }
                
        public func appear( _ objs:TObj? ) {
            if TObj.self == LLEmpty.self { self.relayFunc?( LLEmpty.none as! TObj ); return }
            guard let tobjs = objs else { return }
            self.relayFunc?( tobjs )
        }
    }
    
    public class PGActorTimer {
        public static let shared = PGActorTimer()
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

    public struct PGActorInterval
    {
        var sec:Double = 1.0
        var prev:Double = 0.0
        var field:PGField<PGActor, LLEmpty>
        
        public init( sec:Double, prev:Double, field:PGField<PGActor, LLEmpty> ) {
            self.sec = sec
            self.prev = prev
            self.field = field
        }
    }
    
    open class PGActor : Hashable
    {
        // Hashableの実装
        public static func == ( lhs:PGActor, rhs:PGActor ) -> Bool { lhs === rhs }
        public func hash(into hasher: inout Hasher) { ObjectIdentifier( self ).hash( into: &hasher ) }
        
        
        public var iterateField:PGField<PGActor, LLEmpty>?
        public var intervalField:PGActorInterval?
        public var completionField:PGField<PGActor, LLEmpty>?
       
        @discardableResult
        open func iterate( _ f:@escaping ( PGActor )->Void ) -> Self {
            self.iterateField = PGField.init( me:self, action:f )
            return self
        }
        
        open func appearIterate() {
            self.iterateField?.appear()
        }
        
        @discardableResult
        open func interval( sec:Double, f:@escaping ( PGActor )->Void ) -> Self {
            self.intervalField = PGActorInterval(
                sec:sec,
                prev:PGActorTimer.shared.nowTime,
                field:PGField( me:self, action:f )
            )
            return self
        }
        
        open func appearIntervals() {
            let now = PGActorTimer.shared.nowTime
            
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
        open func completion( _ f:@escaping ( PGActor )->Void ) -> Self {
            self.completionField = PGField( me:self, action:f )
            return self
        }
        
        open func appearCompletion() {
            self.completionField?.appear()
        }
        
        open func checkRemove() {
            if self.life <= 0.0 {
                self.iterateField = nil
                self.intervalField = nil
                self.completionField = nil
                PGMemoryPool.shared.panels.remove( self )
            }
        }
    }
}
