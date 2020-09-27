//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY_FULL

import Foundation
import Metal

open class LPAtlasIO : LPActor
{       
    public var inAtlas:LLMetalTextureAtlas?
    public var outAtlas:LLMetalTextureAtlas?
    public var inParts:LLMetalTextureAtlasParts?
    public var outParts:LLMetalTextureAtlasParts?
    
    @discardableResult
    public func input( atlas:LLMetalTextureAtlas?, key:String ) -> Self {
        inAtlas = atlas
        inParts = inAtlas?.parts( key )
        return self
    }
    
    @discardableResult
    public func output( atlas:LLMetalTextureAtlas?, key:String ) -> Self {
        outAtlas = atlas
        outParts = outAtlas?.parts( key )
        return self
    }
}

#endif
