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
    open class PGAudioFlow
    {
        weak var engine:AVAudioEngine?
        public let player = AVAudioPlayerNode()
        
        public var output:AVAudioNode { player }
        
        public private(set) var isRepeating = false
        public private(set) var isPlaying   = false
        
        public init( engine:AVAudioEngine ) {
            self.engine = engine
            self.engine?.attach( player )
        }
        
        public func set( 
            audioFile:AVAudioFile, 
            from:Double? = nil,
            to:Double? = nil, 
            completion:(()->())? = nil 
        ) 
        {
            let rate = audioFile.processingFormat.sampleRate
            
            let from_frame = ((from ?? 0.0) * rate).i64!
            let to_frame = { if let to = to { return (to * rate).i64! } else { return audioFile.length } }()
            let frame_count = LLMax( 0, to_frame - from_frame ).u32!
            
            schedule( audioFile:audioFile, startFrame:from_frame, frameCount:frame_count, completion:completion )
        }
            
        private func schedule( 
            audioFile:AVAudioFile, 
            startFrame: AVAudioFramePosition,
            frameCount: AVAudioFrameCount,
            completion:(()->())? = nil
        ) 
        {
            player.scheduleSegment( 
                audioFile,
                startingFrame:startFrame,
                frameCount:frameCount,
                at: nil 
            )
            { [weak self] in
                if let isRepeating = self?.isRepeating, isRepeating {
                    // リピート処理
                    self?.schedule( audioFile:audioFile, startFrame:startFrame, frameCount:frameCount )
                }
                else {
                    self?.isPlaying = false
                    // リピートしない場合終了処理を入れる
                    completion?()
                }
            }
        }
        
        deinit {
            self.engine?.detach( player )
        }
        
        ////
        
        public func play() { 
            if isPlaying { return } 
            player.play()
            isPlaying = true
        }
        
        public func pause() { 
            if !isPlaying { return } 
            player.pause()
        }
    
        public func stop() { 
            if !isPlaying { return } 
            player.stop() 
            isPlaying = false
        }
    
        public func reset() { 
            player.reset()
        }
        
        ////

        public func `repeat`( _ torf:Bool ) {
            isRepeating = torf
        }
        
        public var volume:Float { 
            get { player.volume }
            set { player.volume = LLWithin(min: 0.0, newValue, max: 1.0) }
        }
        
        public var pan:Float {
            get { player.pan }
            set { player.pan = LLWithin( min:-1.0, newValue, max:1.0 ) }
        }
        
        public var position:AVAudio3DPoint {
            get { player.position }
            set { player.position = newValue }
        }
        
        public var renderingAlgorithm:AVAudio3DMixingRenderingAlgorithm {
            get { player.renderingAlgorithm }
            set { player.renderingAlgorithm = newValue }
        }
        
        public var reverbBlend:Float {
            get { player.reverbBlend }
            set { player.reverbBlend = newValue }
        }
        
        public var sourceMode:AVAudio3DMixingSourceMode {
            get { player.sourceMode }
            set { player.sourceMode = newValue }
        }
        
        public var pointSourceInHeadMode:AVAudio3DMixingPointSourceInHeadMode {
            get { player.pointSourceInHeadMode }
            set { player.pointSourceInHeadMode = newValue }
        }
    }
}

#endif
