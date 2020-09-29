//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal

public class PGCircle : PGPanelBase
{
    static private var deco:[Int:LBPanelDecoration] = [:]
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.circle()
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( decoration:PGCircle.create( index: index ) )
        PGViewController.shared.panels.insert( self )
    }
}

public class PGAddCircle : PGPanelBase
{
    static private var deco:[Int:LBPanelDecoration] = [:]
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.circle()
            .blendType( .add )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( decoration:PGAddCircle.create( index: index ) )
        PGViewController.shared.panels.insert( self )
    }
}

public class PGSubCircle : PGPanelBase
{
    static private var deco:[Int:LBPanelDecoration] = [:]
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.circle()
            .blendType( .sub )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( decoration:PGSubCircle.create( index: index ) )
        PGViewController.shared.panels.insert( self )
    }
}

