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

public class PGCircle : PGPanelBase
{
    static private var objpl:[Int:LBPanelPipeline] = [:]
    
    static private func create( index:Int ) -> LBPanelPipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBPanelPipeline.circle()
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( objpl:PGCircle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGAddCircle : PGPanelBase
{
    static private var objpl:[Int:LBPanelPipeline] = [:]
    
    static private func create( index:Int ) -> LBPanelPipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBPanelPipeline.circle()
            .blendType( .add )
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( objpl:PGAddCircle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGSubCircle : PGPanelBase
{
    static private var objpl:[Int:LBPanelPipeline] = [:]
    
    static private func create( index:Int ) -> LBPanelPipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBPanelPipeline.circle()
            .blendType( .sub )
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( objpl:PGSubCircle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}

