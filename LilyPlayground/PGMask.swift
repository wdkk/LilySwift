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

public class PGMask : PGPanelBase
{
    static private var deco = [Int:LBPanelDecoration]()
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.maskTex()
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGViewController.shared.getTexture( name )
        
        super.init( decoration:PGMask.create( index: index ) )
        self.texture( tex )
        
        PGViewController.shared.panels.insert( self )
    }
}

public class PGAddMask : PGPanelBase
{
    static private var deco = [Int:LBPanelDecoration]()
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.maskTex()
            .blendType( .add )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGViewController.shared.getTexture( name )
        
        super.init( decoration:PGAddMask.create( index: index ) )
        self.texture( tex )
        
        PGViewController.shared.panels.insert( self )
    }
}

public class PGSubMask : PGPanelBase
{
    static private var deco = [Int:LBPanelDecoration]()
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.maskTex()
            .blendType( .sub )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGViewController.shared.getTexture( name )
        
        super.init( decoration:PGSubMask.create( index: index ) )
        self.texture( tex )
        
        PGViewController.shared.panels.insert( self )
    }
}