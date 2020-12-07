//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Foundation
import Metal

public struct LLTriple<T> {
    public var p1:T, p2:T, p3:T
    public init( _ p1:T, _ p2:T, _ p3:T ) {
        self.p1 = p1; self.p2 = p2; self.p3 = p3
    }
}

// 三角形メッシュ形状メモリクラス
public class LLMetalTriangles<T> : LLMetalShape<LLTriple<T>>
{
    public typealias VerticeType = LLTriple<T>
}

public class LLMetalTrianglePainter<T> : LLMetalShapePainter<LLTriple<T>>
{
    public override init() {
        super.init()
        drawFunc = { encoder, shape in
            encoder.drawPrimitives( type: .triangle,
                                    vertexStart: 0,
                                    vertexCount: 3,
                                    instanceCount: shape.count )
        }
    }
}
