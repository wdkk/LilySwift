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
            
            assetNames.forEach { audios[$0] = AVAudioFile.load( assetName:$0 ) }
        }
        
        deinit { engine.clear() }
        
        public func request( 
            channel:Int,
            assetName:String,
            startTime:Double? = nil,
            endTime:Double? = nil
        ) 
        -> Int
        {
            if channel >= engine.flows.count { 
                LLLogWarning( "サウンドチャンネルがありません: \(channel)" )
                return -1
            }
            
            guard let audio = audios[assetName] else {
                LLLogWarning( "Assetにオーディオデータがありません: \(assetName)" )
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
