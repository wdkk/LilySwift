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

// 四角形メッシュ形状メモリクラス
public class LLMetalQuadrangles<T> : LLMetalShape<LLQuad<T>>
{   
    public typealias VerticeType = LLQuad<T>
}

public class LLMetalQuadranglePainter<T> : LLMetalShapePainter<LLQuad<T>>
{
    public override init() {
        super.init()
        drawFunc = { encoder, shape in
            encoder.drawPrimitives( 
                type: .triangleStrip, 
                vertexStart: 0, 
                vertexCount: 4, 
                instanceCount: shape.count 
            )
        }
    }
}
