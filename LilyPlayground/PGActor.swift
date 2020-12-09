//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal

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
    var field:LLSoloField<LBActor, Any>
    
    public init( sec s_:Double, prev p_:Double, field f_:LLSoloField<LBActor, Any> ) {
        sec = s_
        prev = p_
        field = f_
    }
}

public protocol PGActor : LBActor
{
    var iterateField:LLSoloField<LBActor, Any>? { get set }
    var intervalFields:[String:PGActorInterval] { get set }
    var completionField:LLSoloField<LBActor, Any>? { get set }

    @discardableResult
    func iterate( _ f:@escaping ( LBActor )->Void ) -> Self
    func appearIterate()
    
    @discardableResult
    func interval( key:String, sec:Double, f:@escaping ( LBActor )->Void ) -> Self
    func appearIntervals()
    
    @discardableResult
    func stopInterval( key:String ) -> Self    
    
    @discardableResult
    func completion( _ f:@escaping ( LBActor )->Void ) -> Self
    func appearCompletion()
    
    func checkRemove()
}

open class PGPanelBase : LBPanel, PGActor
{
    public var iterateField:LLSoloField<LBActor, Any>?
    public var intervalFields:[String:PGActorInterval] = [:]
    public var completionField:LLSoloField<LBActor, Any>?
   
    @discardableResult
    open func iterate( _ f:@escaping ( LBActor )->Void ) -> Self {
        self.iterateField = LLSoloField( me:self, action:f )
        return self
    }
    
    open func appearIterate() {
        self.iterateField?.appear( self )
    }
    
    @discardableResult
    open func interval( key:String = UUID().labelString,
                        sec:Double, 
                        f:@escaping ( LBActor )->Void ) -> Self {
        self.intervalFields[key] = PGActorInterval( sec:sec,
                                                    prev:PGActorTimer.shared.nowTime,
                                                    field:LLSoloField( me:self, action:f ) )
        return self
    }
    
    open func appearIntervals() {
        let now = PGActorTimer.shared.nowTime
        for ifs in self.intervalFields {
            let intv = ifs.value
            if now - intv.prev >= intv.sec {
                intv.field.appear( self )
                self.intervalFields[ifs.key]?.prev = now
            }
        }
    }
    
    @discardableResult
    public func stopInterval( key:String ) -> Self {
        self.intervalFields.removeValue( forKey: key )
        return self
    }
    
    @discardableResult
    open func completion( _ f:@escaping ( LBActor )->Void ) -> Self {
        self.completionField = LLSoloField( me:self, action:f )
        return self
    }
    
    open func appearCompletion() {
        self.completionField?.appear( self )
    }
    
    open func checkRemove() {
        if self.life <= 0.0 {
            self.iterateField = nil
            self.intervalFields.removeAll()
            self.completionField = nil
            PGMemoryPool.shared.panels.remove( self )
        }
    }
}

open class PGTriangleBase : LBTriangle, PGActor
{    
    public var iterateField:LLSoloField<LBActor, Any>?
    public var intervalFields = [String:PGActorInterval]()
    public var completionField:LLSoloField<LBActor, Any>?
    
    @discardableResult
    open func iterate( _ f:@escaping ( LBActor )->Void ) -> Self {
        self.iterateField = LLSoloField( me:self, action:f )
        return self
    }
    
    open func appearIterate() {
        self.iterateField?.appear( self )
    }
    
    @discardableResult
    open func interval( key:String = UUID().labelString,
                        sec:Double, 
                        f:@escaping ( LBActor )->Void ) -> Self {
        self.intervalFields[key] = PGActorInterval( sec:sec,
                                                    prev:PGActorTimer.shared.nowTime,
                                                    field:LLSoloField( me:self, action:f ) )
        return self
    }
    
    open func appearIntervals() {
        let now = PGActorTimer.shared.nowTime
        for ifs in self.intervalFields {
            let intv = ifs.value
            if now - intv.prev >= intv.sec {
                intv.field.appear( self )
                self.intervalFields[ifs.key]?.prev = now
            }
        }
    }
    
    @discardableResult
    public func stopInterval( key:String ) -> Self {
        self.intervalFields.removeValue( forKey: key )
        return self
    }
    
    @discardableResult
    open func completion( _ f:@escaping ( LBActor )->Void ) -> Self {
        self.completionField = LLSoloField( me:self, action:f )
        return self
    }
    
    open func appearCompletion() {
        self.completionField?.appear( self )
    }
    
    open func checkRemove() {
        if self.life <= 0.0 {
            self.iterateField = nil
            self.intervalFields.removeAll()
            self.completionField = nil
            PGMemoryPool.shared.triangles.remove( self )
        }
    }
}
