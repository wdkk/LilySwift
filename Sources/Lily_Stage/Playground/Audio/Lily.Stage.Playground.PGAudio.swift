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
            do { try engine.start() }
            catch { LLLog( "AudioEngineを開始できませんでした: \(error)") }
        }
        
        public func stop() {
            engine.stop()
        }
            
        public func setAudio( bundleName:String, index:Int ) {
            let audioFile = load( bundleName:bundleName )
            flows[index].set( audioFile:audioFile! )
        }
        
        public func setAudio( assetName:String, index:Int ) {
            let audioFile = load( assetName:assetName )
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

extension Lily.Stage.Playground.PGAudio
{
    private func load( bundleName:String ) -> AVAudioFile? {
        guard let file = Bundle.main.url(forResource: bundleName, withExtension: nil)
        else {
            LLLog( "\(bundleName) がバンドルにありません" )
            return nil
        }
        
        do { return try AVAudioFile(forReading: file) }
        catch {
            LLLog( "\(bundleName) の読み込みに失敗しました: \(error)" )
            return nil
        }
    }
    
    private func load( assetName:String ) -> AVAudioFile? {
        guard let asset = NSDataAsset( name:assetName ) else {
            LLLog( "\(assetName) がアセットにありません" )
            return nil
        }

        let temp_url = FileManager.default.temporaryDirectory.appendingPathComponent( "\(assetName)" )

        do { try asset.data.write( to:temp_url ) }
        catch {
            LLLog( "\(assetName) の一時ファイル書き出しができませんでした" )
            return nil
        }

        do {
            let audio_file = try AVAudioFile( forReading:temp_url )
            try FileManager.default.removeItem( at:temp_url )
            return audio_file
        } catch {
            LLLog( "\(assetName) の読み込みに失敗しました: \(error)" )
            try? FileManager.default.removeItem( at:temp_url )
            return nil
        }
    }
}
