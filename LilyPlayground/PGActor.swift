//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
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
}

public protocol PGActor : LBActor
{
    var iterateField:LLPlaneField<LBActor>? { get set }
    var intervalFields:[(sec:Double, prev:Double, f:LLPlaneField<LBActor>)] { get set }
    var completionField:LLPlaneField<LBActor>? { get set }

    @discardableResult
    func iterate( _ f:@escaping ( LBActor )->Void ) -> Self
    func appearIterate()
    
    @discardableResult
    func interval( sec:Double, f:@escaping ( LBActor )->Void ) -> Self
    func appearIntervals()
    
    @discardableResult
    func completion( _ f:@escaping ( LBActor )->Void ) -> Self
    func appearCompletion()
    
    func checkRemove()
}

open class PGPanelBase : LBPanel, PGActor
{
    public var iterateField:LLPlaneField<LBActor>?
    public var intervalFields = [(sec:Double, prev:Double, f:LLPlaneField<LBActor>)]()
    public var completionField:LLPlaneField<LBActor>?
   
    @discardableResult
    open func iterate( _ f:@escaping ( LBActor )->Void ) -> Self {
        self.iterateField = LLPlaneField(by: self, field: f )
        return self
    }
    
    open func appearIterate() {
        self.iterateField?.appear( self )
    }
    
    @discardableResult
    open func interval( sec:Double, f:@escaping ( LBActor )->Void ) -> Self {
        self.intervalFields.append( ( sec, 
                                      PGActorTimer.shared.nowTime,
                                      LLPlaneField(by: self, field: f ) ) )
        return self
    }
    
    open func appearIntervals() {
        let now = PGActorTimer.shared.nowTime
        for i in 0 ..< self.intervalFields.count {
            let ifs = self.intervalFields[i]
            let sec = ifs.sec
            let prev = ifs.prev
            let field = ifs.f
            if now - prev >= sec {
                field.appear( self )
                self.intervalFields[i].prev = now
            }
        }
    }
    
    @discardableResult
    open func completion( _ f:@escaping ( LBActor )->Void ) -> Self {
        self.completionField = LLPlaneField(by: self, field: f )
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
            PGViewController.shared.panels.remove( self )
        }
    }
}

open class PGTriangleBase : LBTriangle, PGActor
{    
    public var iterateField:LLPlaneField<LBActor>?
    public var intervalFields = [(sec:Double, prev:Double, f:LLPlaneField<LBActor>)]()
    public var completionField:LLPlaneField<LBActor>?
    
    @discardableResult
    open func iterate( _ f:@escaping ( LBActor )->Void ) -> Self {
        self.iterateField = LLPlaneField(by: self, field: f )
        return self
    }
    
    open func appearIterate() {
        self.iterateField?.appear( self )
    }
    
    @discardableResult
    open func interval( sec:Double, f:@escaping ( LBActor )->Void ) -> Self {
        self.intervalFields.append( ( sec, 
                                      PGActorTimer.shared.nowTime,
                                      LLPlaneField(by: self, field: f ) ) )
        return self
    }
    
    open func appearIntervals() {
        let now = PGActorTimer.shared.nowTime
        for i in 0 ..< self.intervalFields.count {
            let ifs = self.intervalFields[i]
            let sec = ifs.sec
            let prev = ifs.prev
            let field = ifs.f
            if now - prev >= sec {
                field.appear( self )
                self.intervalFields[i].prev = now
            }
        }
    }
    
    @discardableResult
    open func completion( _ f:@escaping ( LBActor )->Void ) -> Self {
        self.completionField = LLPlaneField(by: self, field: f )
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
            PGViewController.shared.triangles.remove( self )
        }
    }
}
