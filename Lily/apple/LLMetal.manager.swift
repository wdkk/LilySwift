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
    /// Metalデバイス
    public static var device = MTLCreateSystemDefaultDevice()
    /// Metal描画用セマフォ
    public static let semaphore = DispatchSemaphore( value: 0 )
    /// Metalコマンドキュー
    private static let commandQueue = device?.makeCommandQueue()
    
    // Metalコマンド実行
    @discardableResult
    public static func execute( pre pre_f:(( MTLCommandBuffer )->())? = nil,
                                main main_f:( MTLCommandBuffer )->(),
                                post post_f:(( MTLCommandBuffer )->())? = nil,
                                completion completion_f: (( MTLCommandBuffer )->())? = nil )
    -> Bool
    {
        // コマンドバッファの生成
        guard let command_buffer = LLMetalManager.commandQueue?.makeCommandBuffer() else {
            LLLogWarning( "Metalコマンドバッファの取得に失敗." )
            return false
        }
        
        // 完了時の処理
        command_buffer.addCompletedHandler { _ in
            LLMetalManager.semaphore.signal()
            completion_f?( command_buffer )
        }
        
        // 事前処理の実行(コンピュートシェーダなどで使える)
        pre_f?( command_buffer )
            
        main_f( command_buffer )
        
        // コマンドバッファの確定
        command_buffer.commit()
        
        // セマフォ待機のチェック
        _ = LLMetalManager.semaphore.wait( timeout: .distantFuture )
    
        // 事後処理の関数の実行(command_buffer.waitUntilCompletedの呼び出しなど)
        post_f?( command_buffer )
        
        return true
    }
    
    // Metalコマンド実行(メインのみ)
    @discardableResult
    public static func execute( _ main_f:( MTLCommandBuffer )->() )
    -> Bool
    {
        execute( main: main_f )
    }
}
