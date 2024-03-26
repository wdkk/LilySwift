//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

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
    }
    
    open class PGAudio
    {
        public static let shared = PGAudio()
        private init() {}
    
        lazy var engine = AVAudioEngine()
        public lazy var flows  = [PGAudioFlow]()
        
        public func setup() {
            flows = .init( repeating:.init( engine:engine ), count:4 )
                        
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
            
            do {
                try engine.start()
            }
            catch {
                LLLog( "AudioEngineを開始できませんでした: \(error)")
            }
        }
        
        public func stop() {
            engine.stop()
        }
    
        private func load( bundleName:String ) -> AVAudioFile? {
            guard let file = Bundle.main.url(forResource: bundleName, withExtension: nil)
            else {
                LLLog( "\(bundleName)がバンドルにありません" )
                return nil
            }
            
            do {
                return try AVAudioFile(forReading: file)
            } 
            catch {
                LLLog( "\(bundleName)がバンドルから読み込めませんでした: \(error)" )
                return nil
            }
        }
        
        public func setAudio( bundleName:String, index:Int ) {
            let audioFile = load( bundleName:bundleName )
            flows[index].set( audioFile:audioFile! )
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
    }
}
