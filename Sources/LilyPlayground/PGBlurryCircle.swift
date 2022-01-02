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

public class PGBlurryCircle : PGPanelBase
{
    static private var objpl:[Int:LBPanelPipeline] = [:]
    
    static private func create( index:Int ) -> LBPanelPipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBPanelPipeline.blurryCircle()
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( objpl:PGBlurryCircle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGAddBlurryCircle : PGPanelBase
{
    static private var objpl:[Int:LBPanelPipeline] = [:]
    
    static private func create( index:Int ) -> LBPanelPipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBPanelPipeline.blurryCircle()
            .blendType( .add )
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( objpl:PGAddBlurryCircle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGSubBlurryCircle : PGPanelBase
{
    static private var objpl:[Int:LBPanelPipeline] = [:]
    
    static private func create( index:Int ) -> LBPanelPipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBPanelPipeline.blurryCircle()
            .blendType( .sub )
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( objpl:PGSubBlurryCircle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}

