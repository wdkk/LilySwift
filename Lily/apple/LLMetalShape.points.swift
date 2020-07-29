//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Foundation
import Metal

/// 点形状クラス
public class LLMetalPoints<T> : LLMetalShape<T>
{    
    public typealias VerticeType = T
}

public class LLMetalPointPainter<T> : LLMetalShapePainter<T>
{    
    public override init() {
        super.init()
        drawFunc = { (encoder, shape) in
            encoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: shape.count )
        }
    }
}
