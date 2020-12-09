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

public class PGTriangle : PGTriangleBase
{
    static private var deco:[Int:LBTriangleDecoration] = [:]
    
    static private func create( index:Int ) -> LBTriangleDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBTriangleDecoration.plane()
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( decoration:PGTriangle.create( index: index ) )
        PGMemoryPool.shared.triangles.insert( self )
    }
}

public class PGAddTriangle : PGTriangleBase
{
    static private var deco:[Int:LBTriangleDecoration] = [:]
    
    static private func create( index:Int ) -> LBTriangleDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBTriangleDecoration.plane()
            .blendType( .add )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( decoration:PGAddTriangle.create( index: index ) )
        PGMemoryPool.shared.triangles.insert( self )
    }
}

public class PGSubTriangle : PGTriangleBase
{
    static private var deco:[Int:LBTriangleDecoration] = [:]
    
    static private func create( index:Int ) -> LBTriangleDecoration {
        if let d = deco[index] { return d }
        deco[index] = LBTriangleDecoration.plane()
            .blendType( .sub )
            .layer( index:index )
        return deco[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( decoration:PGSubTriangle.create( index: index ) )
        PGMemoryPool.shared.triangles.insert( self )
    }
}


