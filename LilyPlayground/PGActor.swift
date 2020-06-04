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

public protocol PGActor : LBActor
{
    var iterateField:LLPlaneField<LBActor>? { get set }
    var completionField:LLPlaneField<LBActor>? { get set }

    @discardableResult
    func iterate( _ f:@escaping ( LBActor )->Void ) -> Self
    func appearIterate()
    
    @discardableResult
    func completion( _ f:@escaping ( LBActor )->Void ) -> Self
    func appearCompletion()
    
    func checkRemove()
}

open class PGPanelBase : LBPanel, PGActor
{
    public var iterateField:LLPlaneField<LBActor>?
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
    open func completion( _ f:@escaping ( LBActor )->Void ) -> Self {
        self.completionField = LLPlaneField(by: self, field: f )
        return self
    }
    
    open func appearCompletion() {
        self.completionField?.appear( self )
    }
    
    open func checkRemove() {
        if self.life <= 0.0 {
            PGViewController.shared.panels.remove( self )
        }
    }
}

open class PGTriangleBase : LBTriangle, PGActor
{    
    public var iterateField:LLPlaneField<LBActor>?
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
    open func completion( _ f:@escaping ( LBActor )->Void ) -> Self {
        self.completionField = LLPlaneField(by: self, field: f )
        return self
    }
    
    open func appearCompletion() {
        self.completionField?.appear( self )
    }
    
    open func checkRemove() {
        if self.life <= 0.0 {
            PGViewController.shared.triangles.remove( self )
        }
    }
}
