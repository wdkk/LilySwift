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
    static private var objpl:[String:LBPanelPipeline] = [:]
    
    static private func create( name:String, index:Int ) -> LBPanelPipeline {
        let id = name + "\(index)"
        if let d = objpl[id] { return d }
        objpl[id] = LBPanelPipeline.maskTex()
            .layer( index:index )
        return objpl[id]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGMemoryPool.shared.getTexture( name )
        
        super.init( objpl:PGMask.create( name:name, index:index ) )
        self.texture( tex )
        
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGAddMask : PGPanelBase
{
    static private var objpl:[Int:LBPanelPipeline] = [:]
    
    static private func create( index:Int ) -> LBPanelPipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBPanelPipeline.maskTex()
            .blendType( .add )
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGMemoryPool.shared.getTexture( name )
        
        super.init( objpl:PGAddMask.create( index: index ) )
        self.texture( tex )
        
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGSubMask : PGPanelBase
{
    static private var objpl:[Int:LBPanelPipeline] = [:]
    
    static private func create( index:Int ) -> LBPanelPipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBPanelPipeline.maskTex()
            .blendType( .sub )
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGMemoryPool.shared.getTexture( name )
        
        super.init( objpl:PGSubMask.create( index: index ) )
        self.texture( tex )
        
        PGMemoryPool.shared.panels.insert( self )
    }
}
