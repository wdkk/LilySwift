//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import UIKit

open class PGShape : LBPanel 
{
    public static let remove:(( PGShape )->Void) = {
        PGViewController.shared.shapes.remove( $0 )
    }
    
    var completionCallBack:(( PGShape )->Void) = PGShape.remove
    
    open func completion( _ f:@escaping ( PGShape )->Void ) -> Self {
        completionCallBack = f
        return self
    }
}
