//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

open class LPAtlasIO : LPActor
{       
    public var inAtlas:LBTextureAtlas?
    public var outAtlas:LBTextureAtlas?
    public var inParts:LBTextureAtlasParts?
    public var outParts:LBTextureAtlasParts?
    public var flex = LPFlexibleFloat16()
    
    @discardableResult
    public func input( atlas:LBTextureAtlas?, key:String ) -> Self {
        inAtlas = atlas
        inParts = inAtlas?.parts( key )
        return self
    }
    
    @discardableResult
    public func output( atlas:LBTextureAtlas?, key:String ) -> Self {
        outAtlas = atlas
        outParts = outAtlas?.parts( key )
        return self
    }
    
    @discardableResult
    public func flex( _ f:(inout LPFlexibleFloat16)->Void ) -> Self {
        var ff = self.flex
        f( &ff ) 
        self.flex = ff
        return self
    }
}
