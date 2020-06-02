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

open class PGPanelBase : LBPanel
{
    public static let remove:(( PGPanelBase )->Void) = {
        PGViewController.shared.panels.remove( $0 )
    }
    
    var completionCallBack:(( PGPanelBase )->Void) = PGPanelBase.remove
    
    @discardableResult
    open func completion( _ f:@escaping ( PGPanelBase )->Void ) -> Self {
        completionCallBack = f
        return self
    }
}

open class PGTriangleBase : LBTriangle
{
    public static let remove:(( PGTriangleBase )->Void) = {
        PGViewController.shared.triangles.remove( $0 )
    }
    
    var completionCallBack:(( PGTriangleBase )->Void) = PGTriangleBase.remove
    
    @discardableResult
    open func completion( _ f:@escaping ( PGTriangleBase )->Void ) -> Self {
        completionCallBack = f
        return self
    }
}
