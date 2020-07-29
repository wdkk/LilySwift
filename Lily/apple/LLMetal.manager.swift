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

open class LLMetalManager
{
    public static let shared = LLMetalManager()
    private init() {
        device = MTLCreateSystemDefaultDevice()
        commandQueue = device?.makeCommandQueue()
    }
    
    /// Metalデバイス
    public var device:MTLDevice?
    /// Metalコマンドキュー
    public let commandQueue:MTLCommandQueue?
    /// Metal描画用セマフォ
    public let semaphore = DispatchSemaphore( value: 3 )
    
    // Metalコマンド実行
    @discardableResult
    public func execute( pre pre_f:(( MTLCommandBuffer )->())? = nil,
                         main main_f:( MTLCommandBuffer )->(),
                         post post_f:(( MTLCommandBuffer )->())? = nil,
                         completion completion_f: (( MTLCommandBuffer )->())? = nil )
    -> Bool
    {
        return autoreleasepool {
            // コマンドバッファの生成
            guard let command_buffer = self.commandQueue?.makeCommandBuffer() else {
                LLLogWarning( "Metalコマンドバッファの取得に失敗." )
                return false
            }
            
            // 完了時の処理
            command_buffer.addCompletedHandler { [weak self] _ in
                self?.semaphore.signal()
                completion_f?( command_buffer )
            }
            
            // 事前処理の実行(コンピュートシェーダなどで使える)
            pre_f?( command_buffer )
                
            main_f( command_buffer )
            
            // コマンドバッファの確定
            command_buffer.commit()
            
            // セマフォ待機のチェック
            _ = self.semaphore.wait( timeout: .distantFuture )
        
            // 事後処理の関数の実行(command_buffer.waitUntilCompletedの呼び出しなど)
            post_f?( command_buffer )

            return true
        }
    }
    
    // Metalコマンド実行(メインのみ)
    @discardableResult
    public func execute( _ main_f:( MTLCommandBuffer )->() )
    -> Bool
    {
        execute( main: main_f )
    }
}
