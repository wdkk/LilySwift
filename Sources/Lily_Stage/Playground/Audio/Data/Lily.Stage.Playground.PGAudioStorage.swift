//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

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
        
        public static var current:PGAudioStorage?
        
        public var engine:PGAudioEngine
        public let channels:Int
        
        public var audios:[String:AVAudioFile] = [:]
                
        public init( assetNames:[String] ) {
            self.channels = 8
            
            engine = PGAudioEngine()
            engine.setup( channels:channels )
            engine.start()
            
            assetNames.forEach {
                let asset_file = AVAudioFile.load( assetName:$0 )
                if asset_file != nil {
                    audios[$0] = asset_file 
                    return
                }
                
                let bundle_path = LLPath.bundle( $0 )
                let bundle_file = AVAudioFile.load( bundleName:bundle_path )
                audios[$0] = bundle_file
            }
        }
        
        deinit { engine.clear() }
        
        public func request( 
            channel:Int,
            name:String,
            startTime:Double? = nil,
            endTime:Double? = nil
        ) 
        -> Int
        {
            if channel >= engine.flows.count { 
                LLLogWarning( "サウンドチャンネルがありません: \(channel)" )
                return -1
            }
            
            guard let audio = audios[name] else {
                LLLogWarning( "ストレージにオーディオデータがありません: \(name)" )
                return -1
            }
         
            engine.flows[channel].repeat( false )
            engine.flows[channel].stop()
            engine.flows[channel].set( audioFile:audio, from:startTime, to:endTime )
            
            return channel
        }
        
        public func trush( index idx:Int ) {
            engine.flows[idx].stop()
        }
    }
}
