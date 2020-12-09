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
    static private var deco:[Int:LBPanelDecoration] = [:]
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.rectangle()
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( decoration:PGRectangle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGAddRectangle : PGPanelBase
{
    static private var deco:[Int:LBPanelDecoration] = [:]
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.rectangle()
            .blendType( .add )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( decoration:PGAddRectangle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}

public class PGSubRectangle : PGPanelBase
{
    static private var deco:[Int:LBPanelDecoration] = [:]
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.rectangle()
            .blendType( .sub )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( decoration:PGSubRectangle.create( index: index ) )
        PGMemoryPool.shared.panels.insert( self )
    }
}
