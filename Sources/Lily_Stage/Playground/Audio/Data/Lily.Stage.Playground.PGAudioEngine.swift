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
    open class PGAudioEngine
    {
        lazy var engine = AVAudioEngine()
        
        public let environment = AVAudioEnvironmentNode()
        
        public lazy var flows = [PGAudioFlow]()
        
        public var channelCount:Int { flows.count }
        
        public func setup( channels:Int ) {
            for _ in 0 ..< channels { flows.append( .init( engine:engine ) ) }
            
            engine.attach( environment )
            
            engine.connect(
                environment,
                to:engine.mainMixerNode,
                format:nil
            )
            
            for i in 0 ..< flows.count {
                let flow = flows[i]
                
                engine.connect( 
                    flow.output, 
                    to:environment,
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
            
            engine.prepare()
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
        
        public func listenerPosition( _ pos:AVAudio3DPoint ) {
            environment.listenerPosition = pos
        }
        
        public func listenerAngle( _ orientation:AVAudio3DAngularOrientation ) {
            environment.listenerAngularOrientation = orientation
        }
        
        public func environmentReverb( _ torf:Bool ) {
            environment.reverbParameters.enable = torf
        }
        
        public func environmentReverbPreset( _ preset:AVAudioUnitReverbPreset ) {
            environment.reverbParameters.loadFactoryReverbPreset( preset )  
        }
    }
}

#endif
