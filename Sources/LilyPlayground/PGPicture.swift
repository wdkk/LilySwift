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

public class PGPicture : PGPanelBase
{
    static private var objpl:[String:LBPanelPipeline] = [:]
    
    static private func create( name:String, index:Int ) -> LBPanelPipeline {
        let id = name + "\(index)"
        if let d = objpl[id] { return d }
        objpl[id] = LBPanelPipeline.texture()
            .layer( index:index )
        return objpl[id]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGMemoryPool.shared.getTexture( name )
        
        super.init( objpl:PGPicture.create( name:name, index:index ) )
        self.texture( tex )
        
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGAddPicture : PGPanelBase
{
    static private var objpl:[Int:LBPanelPipeline] = [:]
    
    static private func create( index:Int ) -> LBPanelPipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBPanelPipeline.texture()
            .blendType( .add )
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGMemoryPool.shared.getTexture( name )
        
        super.init( objpl:PGAddPicture.create( index: index ) )
        self.texture( tex )
        
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGSubPicture : PGPanelBase
{
    static private var objpl:[Int:LBPanelPipeline] = [:]
    
    static private func create( index:Int ) -> LBPanelPipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBPanelPipeline.texture()
            .blendType( .sub )
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGMemoryPool.shared.getTexture( name )
        
        super.init( objpl:PGSubPicture.create( index: index ) )
        self.texture( tex )
        
        PGMemoryPool.shared.panels.insert( self )
    }
}
