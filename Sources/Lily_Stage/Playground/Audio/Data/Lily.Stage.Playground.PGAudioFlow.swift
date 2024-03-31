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
    open class PGAudioFlow
    {
        weak var engine:AVAudioEngine?
        public let player = AVAudioPlayerNode()
        
        public var output:AVAudioNode { player }
        
        public private(set) var isRepeating = false
        
        public init( engine:AVAudioEngine ) {
            self.engine = engine
            self.engine?.attach( player )
            
            player.reverbBlend = 0.5
            player.renderingAlgorithm = .HRTF
            player.sourceMode = .pointSource
            player.pointSourceInHeadMode = .mono
        }
        
        public func set( 
            audioFile:AVAudioFile, 
            from:Double? = nil,
            to:Double? = nil, 
            completion:(()->())? = nil ) 
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
                    self?.schedule( audioFile:audioFile, startFrame:startFrame, frameCount:frameCount )
                }
                completion?()
            }
        }
        
        deinit {
            self.engine?.detach( player )
        }
        
        ////
        
        public func play() { player.play() }
        
        public func pause() { player.pause() }
    
        public func stop() { player.stop() }
    
        public func reset() { player.reset() }
        
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
    }
}
