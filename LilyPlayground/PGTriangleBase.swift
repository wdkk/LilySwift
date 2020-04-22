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

public class PGTriangleBase : LBTriangle
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
