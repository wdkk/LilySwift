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
        public var reuseIndice:[Int]
        public let channels:Int
        
        public var audios:[String:AVAudioFile] = [:]
        
        public var accessors:[String:Int] = [:]
        
        public init( assetNames:[String] ) {
            self.channels = 8
            
            engine = PGAudioEngine()
            engine.setup( channels:channels )
            engine.start()
            
            reuseIndice = (0..<channels).map { $0 }.reversed()
            
            assetNames.forEach { audios[$0] = AVAudioFile.load( assetName:$0 ) }
        }
        
        deinit { engine.clear() }
        
        public func request( 
            name:String,
            assetName:String,
            startTime:Double? = nil,
            endTime:Double? = nil
        ) 
        -> Int
        {
            var target_idx = -1
            if let using_idx = accessors[name] {
                target_idx = using_idx
            }
            else {
                guard let idx = reuseIndice.popLast() else { 
                    LLLogWarning( "サウンドチャンネルの空きがありません" )
                    return -1
                }
                target_idx = idx
            }
            
            accessors[name] = target_idx
            
            guard let audio = audios[assetName] else {
                LLLogWarning( "\(assetName): Assetにオーディオデータがありません" )
                return -1
            }
         
            engine.flows[target_idx].repeat( false )
            engine.flows[target_idx].stop()
            engine.flows[target_idx].set( audioFile:audio, from:startTime, to:endTime )
            
            return target_idx
        }
        
        public func trush( index idx:Int ) {
            engine.flows[idx].stop()
            reuseIndice.append( idx )
        }
    }
}
