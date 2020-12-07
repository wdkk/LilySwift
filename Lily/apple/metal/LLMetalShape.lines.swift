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

public struct LLDual<T> {
    public var p1:T, p2:T
    public init( _ p1:T, _ p2:T ) {
        self.p1 = p1; self.p2 = p2
    }
}

/// ライン形状クラス
public class LLMetalLines<T> : LLMetalShape<LLDual<T>>
{
    public typealias VerticeType = LLDual<T>
}

public class LLMetalLinePainter<T> : LLMetalShapePainter<LLDual<T>>
{
    public override init() {
        super.init()
        drawFunc = { (encoder, shape) in
            encoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: shape.count )
        }
    }
}
