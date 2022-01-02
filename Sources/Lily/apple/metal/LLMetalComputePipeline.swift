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

open class LLMetalComputePipeline
{
    public private(set) var state:MTLComputePipelineState?
    
    public init() { }
    
    public func make( _ fn:( inout MTLComputePipelineDescriptor )->() ) {
        // パイプラインディスクリプタをデフォルト設定で作成
        var cp_desc = MTLComputePipelineDescriptor.default
        // コールバックで設定の上書きを行う
        fn( &cp_desc )
        // パイプラインの作成
        self.makePipeline( cp_desc )        
    }

    private func makePipeline( _ cpd:MTLComputePipelineDescriptor ) {
        guard let nonnull_f = cpd.computeFunction else { 
            LLLogWarning( "コンピュートシェーダがありません." )
            return 
        }
        
        // パイプラインの生成
        do {
            state = try LLMetalManager.shared.device?.makeComputePipelineState( function:nonnull_f )
        }
        catch {
            LLLogWarning( error.localizedDescription )
        }
    }
}

extension MTLComputeCommandEncoder
{
    // MARK: - pipeline function
    public func use( 
        _ pipeline:LLMetalComputePipeline, 
        _ computeFunc:( MTLComputeCommandEncoder )->() 
    )
    {
        guard let state = pipeline.state else { return }
        // エンコーダにパイプラインを指定
        self.setComputePipelineState( state )
        // 関数を実行
        computeFunc( self )
    }
    
    // 1次元実行
    public func dispatch(
        dataCount:Int, 
        threadCount:Int = 32 
    ) 
    {
        // スレッド数
        let thread_num = MTLSize(width: (dataCount + threadCount-1) / threadCount, height: 1, depth:1 )
        // スレッドグループ数
        let thread_groups = MTLSize(width: threadCount, height: 1, depth:1 )
        
        self.dispatchThreadgroups( thread_groups, threadsPerThreadgroup: thread_num )
    }

    // 2次元実行
    public func dispatch2d( 
        dataSize:LLSizev2, 
        threadSize th_size:LLSizev2 = LLSizev2( 16, 16 ) 
    )
    {
        // スレッド数
        let thread_num = MTLSize(
            width: Int(th_size.width),
            height: Int(th_size.height),
            depth: 1 )
        // スレッドグループ数
        let thread_groups = MTLSize(
            width: Int((dataSize.width + th_size.width-1) / th_size.width),
            height: Int((dataSize.height + th_size.height-1) / th_size.height),
            depth: 1 )
        
        self.dispatchThreadgroups( thread_groups, threadsPerThreadgroup: thread_num )
    }
}
