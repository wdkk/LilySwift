//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import AVFoundation

extension Lily.Stage.Playground
{
    public class PGAudioStorage : Hashable
    {
        public static func == ( lhs:PGAudioStorage, rhs:PGAudioStorage ) -> Bool { lhs === rhs }
        public func hash(into hasher: inout Hasher) { ObjectIdentifier( self ).hash( into: &hasher ) }
        
        nonisolated(unsafe) public static var current:PGAudioStorage?
        
        public var engine:PGAudioEngine
        public let channels:Int
        
        public var audios:[String:AVAudioFile] = [:]
                
        public init( assetNames:[String] ) {
            self.channels = 16
            
            engine = PGAudioEngine()
            engine.setup( channels:channels )
            engine.start()
            
            assetNames.forEach {
                let log_type = LLLogGetEnableType()
                defer { LLLogSetEnableType( log_type ) }
               
                LLLogSetEnableType( .none )
                // アセットから取得を試みる
                let asset_file = AVAudioFile.load( assetName:$0 )
                if asset_file != nil {
                    audios[$0] = asset_file     //　アセットからとれたらそれを適用
                    return
                }
                
                // アセットにない場合バンドルから取得を試みる
                let bundle_path = LLPath.bundle( $0 )
                let bundle_file = AVAudioFile.load( path:bundle_path )
                if bundle_file == nil {
                    LLLogSetEnableType( log_type )
                    LLLog( "\($0): アセットとバンドルにファイルが見つかりません" )    // どちらにもない場合ログをだす
                }
                
                audios[$0] = bundle_file
            }
        }
        
        deinit { engine.clear() }
        
        public func request( 
            channel:Int,
            name:String,
            startTime:Double? = nil,
            endTime:Double? = nil,
            completion:(()->())? = nil
        ) 
        -> Int
        {
            if channel >= engine.flows.count { 
                LLLog( "チャンネルがありません: \(channel)" )
                return -1
            }
            
            guard let audio = audios[name] else {
                LLLog( "ストレージにオーディオデータが登録されていません: \(name)" )
                return -1
            }
         
            engine.flows[channel].repeat( false )
            engine.flows[channel].stop()
            engine.flows[channel].set( audioFile:audio, from:startTime, to:endTime, completion:completion )
            
            return channel
        }
        
        public func request( 
            channel:Int,
            systemSound:String,
            startTime:Double? = nil,
            endTime:Double? = nil,
            completion:(()->())? = nil
        ) 
        -> Int
        {
            if channel >= engine.flows.count { 
                LLLog( "チャンネルがありません: \(channel)" )
                return -1
            }
         
            #if os(macOS) || targetEnvironment(macCatalyst)
            let bundle_path = "/System/Library/Sounds/" + systemSound
            #else
            let bundle_path = systemSound
            #endif
            guard let system_sound = AVAudioFile.load(path:bundle_path ) else {
                LLLog( "システムサウンドが見つかりません: \(systemSound)" )
                return -1
            }
            
            engine.flows[channel].repeat( false )
            engine.flows[channel].stop()
            engine.flows[channel].set( audioFile:system_sound, from:startTime, to:endTime, completion:completion )
            
            return channel
        }
        
        public func trush( index idx:Int ) {
            engine.flows[idx].stop()
        }
    }
}

#endif
