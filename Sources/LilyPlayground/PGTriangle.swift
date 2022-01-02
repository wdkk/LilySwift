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
    static private var objpl:[Int:LBTrianglePipeline] = [:]
    
    static private func create( index:Int ) -> LBTrianglePipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBTrianglePipeline.plane()
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( objpl:PGTriangle.create( index: index ) )
        PGMemoryPool.shared.triangles.insert( self )
    }
}

public class PGAddTriangle : PGTriangleBase
{
    static private var objpl:[Int:LBTrianglePipeline] = [:]
    
    static private func create( index:Int ) -> LBTrianglePipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBTrianglePipeline.plane()
            .blendType( .add )
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( objpl:PGAddTriangle.create( index: index ) )
        PGMemoryPool.shared.triangles.insert( self )
    }
}

public class PGSubTriangle : PGTriangleBase
{
    static private var objpl:[Int:LBTrianglePipeline] = [:]
    
    static private func create( index:Int ) -> LBTrianglePipeline {
        if let d = objpl[index] { return d }
        objpl[index] = LBTrianglePipeline.plane()
            .blendType( .sub )
            .layer( index:index )
        return objpl[index]!
    }
    
    @discardableResult
    public init( index:Int = 0 ) {
        super.init( objpl:PGSubTriangle.create( index: index ) )
        PGMemoryPool.shared.triangles.insert( self )
    }
}


