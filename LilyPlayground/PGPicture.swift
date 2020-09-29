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

public class PGPicture : PGPanelBase
{
    static private var deco:[String:LBPanelDecoration] = [:]
    
    static private func create( name:String, index:Int ) -> LBPanelDecoration {
        let id = name + "\(index)"
        if let d = deco[id] { return d }
        deco[id] = LBPanelDecoration.texture()
            .layer( index:index )
        return deco[id]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGViewController.shared.getTexture( name )
        
        super.init( decoration:PGPicture.create( name:name, index:index ) )
        self.texture( tex )
        
        PGViewController.shared.panels.insert( self )
    }
}

public class PGAddPicture : PGPanelBase
{
    static private var deco:[Int:LBPanelDecoration] = [:]
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.texture()
            .blendType( .add )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGViewController.shared.getTexture( name )
        
        super.init( decoration:PGAddPicture.create( index: index ) )
        self.texture( tex )
        
        PGViewController.shared.panels.insert( self )
    }
}

public class PGSubPicture : PGPanelBase
{
    static private var deco:[Int:LBPanelDecoration] = [:]
    
    static private func create( index:Int ) -> LBPanelDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBPanelDecoration.texture()
            .blendType( .sub )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( _ name:String, index:Int = 0 ) {
        let tex = PGViewController.shared.getTexture( name )
        
        super.init( decoration:PGSubPicture.create( index: index ) )
        self.texture( tex )
        
        PGViewController.shared.panels.insert( self )
    }
}
