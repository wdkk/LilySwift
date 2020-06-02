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
    var completionCallBack:(( PGActor )->Void)? { get set }
    func checkRemove()
}

open class PGPanelBase : LBPanel, PGActor
{
    public var completionCallBack:(( PGActor )->Void)?
    
    @discardableResult
    open func completion( _ f:@escaping ( PGActor )->Void ) -> Self {
        completionCallBack = f
        return self
    }
    
    open func checkRemove() {
        if self.life <= 0.0 {
            PGViewController.shared.panels.remove( self )
        }
    }
}

open class PGTriangleBase : LBTriangle, PGActor
{    
    public var completionCallBack:(( PGActor )->Void)?
    
    @discardableResult
    open func completion( _ f:@escaping ( PGActor )->Void ) -> Self {
        completionCallBack = f
        return self
    }
    
    open func checkRemove() {
        if self.life <= 0.0 {
            PGViewController.shared.triangles.remove( self )
        }
    }
}
