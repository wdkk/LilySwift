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

public struct LLQuad<T> {
    public var p1:T, p2:T, p3:T, p4:T
    public init( _ p1:T, _ p2:T, _ p3:T, _ p4:T ) {
        self.p1 = p1; self.p2 = p2; self.p3 = p3; self.p4 = p4
    }
}

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
            encoder.drawPrimitives( type: .triangleStrip, 
                                    vertexStart: 0, 
                                    vertexCount: 4, 
                                    instanceCount: shape.count )
        }
    }
}
