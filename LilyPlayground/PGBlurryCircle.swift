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
    static private var deco:[Int:LBPanelDecoration] = [:]
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.blurryCircle()
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( decoration:PGBlurryCircle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGAddBlurryCircle : PGPanelBase
{
    static private var deco:[Int:LBPanelDecoration] = [:]
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.blurryCircle()
            .blendType( .add )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( decoration:PGAddBlurryCircle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGSubBlurryCircle : PGPanelBase
{
    static private var deco:[Int:LBPanelDecoration] = [:]
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.blurryCircle()
            .blendType( .sub )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( decoration:PGSubBlurryCircle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}

