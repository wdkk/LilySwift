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
    public class PGAudioStorage
    {
        public static var current:PGAudioStorage?
        
        public var engine:PGAudioEngine
        public var reuseIndice:[Int]
        public let channels:Int
        
        public var audios:[String:AVAudioFile] = [:]
        
        public init( assetNames:[String] ) {
            self.channels = 8
            
            engine = PGAudioEngine()
            engine.setup( channels:channels )
            engine.start()
            
            reuseIndice = (0..<channels).map { $0 }.reversed()
            
            assetNames.forEach { audios[$0] = AVAudioFile.load( assetName:$0 ) }
        }
        
        deinit { engine.clear() }
        
        public func request( assetName:String ) -> Int {
            guard let idx = reuseIndice.popLast() else { 
                LLLogWarning( "サウンドチャンネルの空きがありません" )
                return channels
            }
            
            guard let audio = audios[assetName] else {
                LLLogWarning( "\(assetName): オーディオデータがありません" )
                return channels
            }
                
            engine.flows[idx].stop()
            engine.flows[idx].set( audioFile:audio )
           
            return idx
        }
        
        public func request( overwriteIndex idx:Int, assetName:String ) -> Int {
            guard let audio = audios[assetName] else {
                LLLogWarning( "\(assetName): オーディオデータがありません" )
                return idx
            }
                
            engine.flows[idx].stop()
            engine.flows[idx].set( audioFile:audio )
           
            return idx
        }
        
        
        public func trush( index idx:Int ) {
            engine.flows[idx].stop()
            reuseIndice.append( idx )
        }
    }
    
    public class PGSound
    {
        public static var soundMap:[String:PGSound] = [:]
        public static subscript( name:String ) -> PGSound? { 
            get{ Self.soundMap[name] }
            set{ Self.soundMap[name] = newValue }
        }
        
        public let storage:PGAudioStorage?
        public private(set) var audioIndex:Int
        public let name:String
        
        @discardableResult
        public init( storage:PGAudioStorage? = .current, name:String = "", assetName:String ) {
            self.storage = storage
            self.name = name.isEmpty ? assetName : name
            if let s = PGSound[name] {
                self.audioIndex = storage?.request( overwriteIndex:s.audioIndex, assetName:assetName ) ?? -1
            }
            else {
                self.audioIndex = storage?.request( assetName:assetName ) ?? -1
            }
            
            PGSound[name] = self
        }
        
        public func play() {
            if audioIndex == -1 { return }
            storage?.engine.flows[audioIndex].play()
        }
        
        public func pause() {
            if audioIndex == -1 { return }
            storage?.engine.flows[audioIndex].pause()
        }
        
        public func stop() {
            if audioIndex == -1 { return }
            storage?.engine.flows[audioIndex].stop()
            storage?.trush( index:audioIndex )
            audioIndex = -1
        }
    }
}
