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
    public class PGAudioFlow
    {
        weak var engine:AVAudioEngine?
        public var player = AVAudioPlayerNode()
        
        public init( engine:AVAudioEngine ) {
            self.engine = engine
            self.engine?.attach( player )
        }
        
        public func set( audioFile:AVAudioFile ) {
            player.scheduleFile( audioFile, at:nil )
        }
        
        deinit {
            self.engine?.detach( player )
        }
        
        public func play() { player.play() }
        
        public func pause() { player.pause() }
        
        public func stop() { player.stop() }
        
        public var volume:Float { player.volume }
        
        public func volume( _ v:Float ) {
            player.volume = LLWithin(min: 0.0, v, max: 1.0)
        }
    }
    
    open class PGAudioEngine
    {
        lazy var engine = AVAudioEngine()
        public lazy var flows = [PGAudioFlow]()
        
        public var channelCount:Int { flows.count }
        
        public func setup( channels:Int ) {
            for i in 0 ..< channels { flows.append( .init( engine:engine ) ) }
            
            for i in 0 ..< flows.count {
                let flow = flows[i]
                engine.connect( 
                    flow.player, 
                    to:engine.mainMixerNode,
                    fromBus: 0,
                    toBus: i,
                    format:nil
                )
            }
            
            let output_format = engine.mainMixerNode.outputFormat( forBus:0 )
            
            engine.connect( 
                engine.mainMixerNode,
                to: engine.outputNode,
                format: output_format
            )
        }
        
        public func start() {
            if engine.isRunning { return }
            do { try engine.start() }
            catch { LLLog( "AudioEngineを開始できませんでした: \(error)") }
        }
        
        public func stop() {
            if !engine.isRunning { return }
            engine.stop()
        }
            
        public func setAudio( bundleName:String, index:Int ) {
            guard let audioFile = AVAudioFile.load( bundleName:bundleName ) else { 
                LLLog( "\(bundleName) のオーディオ生成に失敗しました" )
                return
            }
            flows[index].set( audioFile:audioFile )
        }
        
        public func setAudio( assetName:String, index:Int ) {
            guard let audioFile = AVAudioFile.load( assetName:assetName ) else {
                LLLog( "\(assetName) のオーディオ生成に失敗しました" )
                return
            }
            flows[index].set( audioFile:audioFile )
        }
        
        public func setAudio( audioFile:AVAudioFile?, index:Int ) {
            guard let audioFile = audioFile else {
                LLLog( "\(index) に指定したオーディオの生成に失敗しました" )
                return
            }
            flows[index].set( audioFile:audioFile )
        }        
        
        public func play( index:Int ) {
            if index < flows.count { flows[index].play() }
        }
        
        public func pause( index:Int ) {
            if index < flows.count { flows[index].pause() }
        }
        
        public func stop( index:Int ) {
            if index < flows.count { flows[index].stop() }
        }
        
        public func clear() {
            Task {
                let fade_time:Float = 1.0
                var vol = engine.mainMixerNode.outputVolume
                let d_vol = vol / 1000.0 / fade_time
                while true {
                    if vol <= 0.0 { break } 
                    vol -= d_vol
                    engine.mainMixerNode.outputVolume = vol
                    LLSystem.sleep(1)
                }
                engine.stop()
            }
        }
    }
}
