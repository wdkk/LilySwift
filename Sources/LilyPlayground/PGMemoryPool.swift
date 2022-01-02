//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

open class PGMemoryPool
{
    public static let shared = PGMemoryPool()
    private init() { }

    // 外部処理ハンドラ 
  
    // 形状データ
    public var panels:Set<PGPanelBase> = Set<PGPanelBase>()
    public var triangles:Set<PGTriangleBase> = Set<PGTriangleBase>()
    public var shapes:Set<LBActor> {
        Set<LBActor>( panels ).union( triangles )
    }
    
    // テクスチャデータ
    public var textures:[String:LLMetalTexture] = [:]
 
    func removeAllShapes() {
        panels.removeAll()
        triangles.removeAll()
    }
    
    // テクスチャの取得 & まだつくっていないときは生成
    public func getTexture( _ path:String ) -> LLMetalTexture {
        guard let tex = textures[path] else {
            textures[path] = LLMetalTexture( named: path )
            return textures[path]!
        }
        return tex
    }
}
