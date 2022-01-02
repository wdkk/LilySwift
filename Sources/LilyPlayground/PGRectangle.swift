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

public class PGRectangle : PGPanelBase
{
    static private var objpl:[Int:LBPanelPipeline] = [:]
    
    static private func create( index:Int ) -> LBPanelPipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBPanelPipeline.rectangle()
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( objpl:PGRectangle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGAddRectangle : PGPanelBase
{
    static private var objpl:[Int:LBPanelPipeline] = [:]
    
    static private func create( index:Int ) -> LBPanelPipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBPanelPipeline.rectangle()
            .blendType( .add )
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( objpl:PGAddRectangle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGSubRectangle : PGPanelBase
{
    static private var objpl:[Int:LBPanelPipeline] = [:]
    
    static private func create( index:Int ) -> LBPanelPipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBPanelPipeline.rectangle()
            .blendType( .sub )
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( objpl:PGSubRectangle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}
