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

public class PGMask : PGPanelBase
{
    static private var deco:[String:LBPanelDecoration] = [:]
    
    static private func create( name:String, index:Int ) -> LBPanelDecoration {
        let id = name + "\(index)"
        if let d = deco[id] { return d }
        deco[id] = LBPanelDecoration.maskTex()
            .layer( index:index )
        return deco[id]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGMemoryPool.shared.getTexture( name )
        
        super.init( decoration:PGMask.create( name:name, index:index ) )
        self.texture( tex )
        
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGAddMask : PGPanelBase
{
    static private var deco:[Int:LBPanelDecoration] = [:]
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.maskTex()
            .blendType( .add )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGMemoryPool.shared.getTexture( name )
        
        super.init( decoration:PGAddMask.create( index: index ) )
        self.texture( tex )
        
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGSubMask : PGPanelBase
{
    static private var deco:[Int:LBPanelDecoration] = [:]
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.maskTex()
            .blendType( .sub )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGMemoryPool.shared.getTexture( name )
        
        super.init( decoration:PGSubMask.create( index: index ) )
        self.texture( tex )
        
        PGMemoryPool.shared.panels.insert( self )
    }
}
