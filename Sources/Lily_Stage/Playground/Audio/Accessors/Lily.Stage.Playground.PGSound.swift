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
    public class PGSound : Hashable
    {
        public static func == ( lhs:PGSound, rhs:PGSound ) -> Bool { lhs === rhs }
        public func hash(into hasher: inout Hasher) { ObjectIdentifier( self ).hash( into: &hasher ) }
            
        public let storage:PGAudioStorage?
        public private(set) var channel:Int = -1
        
        public var iterateField:PGField<PGSound, LLEmpty>?
        public var completionField:PGField<PGSound, LLEmpty>?
        
        @discardableResult
        public init( 
            storage:PGAudioStorage? = .current,
            channel:Int
        )
        {
            self.storage = storage
            self.channel = channel
            PGAudioPool.shared.insert( sound:self, to:storage )
        }
        
        private var flow:PGAudioFlow? {
            if channel == -1 { return nil }
            guard let storage = storage else { return nil }
            let flows = storage.engine.flows
            if flows.count <= channel { return nil }
            return flows[channel]
        }
        
        public func set(
            name:String,
            startTime:Double? = nil,
            endTime:Double? = nil
        ) 
        -> Self
        {
            if let flow = flow, flow.player.isPlaying {
                // 同じチャンネルのものが動作中の場合completionを呼ぶ
                self.appearCompletion()
                self.trush()
            }
            
            self.channel = storage?.request(
                channel:channel,
                name:name,
                startTime:startTime,
                endTime:endTime,
                completion: { [weak self] in
                    self?.appearCompletion()
                    self?.trush()
                }
            ) ?? -1
            
            return self
        }
        
        public func play() { flow?.play() }
        
        public func pause() { flow?.pause() }
        
        public func stop() { flow?.stop() }
        
        public func checkRemove() {
            trush()
        }
        
        public func trush() {
            storage?.trush( index:channel )
            iterateField = nil
            completionField = nil
            PGAudioPool.shared.remove( sound:self, to:storage )
        }
        
        ////
        
        @discardableResult
        public func iterate( _ f:@escaping ( PGSound )->Void ) -> Self {
            self.iterateField = .init( me:self, action:f )
            return self
        }
        
        public func appearIterate() {
            self.iterateField?.appear()
        }
        
        @discardableResult
        public func completion( _ f:@escaping ( PGSound )->Void ) -> Self {
            self.completionField = .init( me:self, action:f )
            return self
        }
        
        public func appearCompletion() {
            self.completionField?.appear()
        }
        
        ////
        
        public var isRepeating:Bool { flow?.isRepeating ?? false }
        
        @discardableResult
        public func `repeat`( _ v:Bool ) -> Self {
            flow?.repeat( v )
            return self
        }    
        
        public var volume:Float { flow?.volume ?? 0.0 }
        
        @discardableResult
        public func volume( _ v:Float ) -> Self {
            flow?.volume = v
            return self
        }        
        
        public var pan:Float { flow?.pan ?? 0.0 }
        
        @discardableResult
        public func pan( _ v:Float ) -> Self {
            flow?.pan = v
            return self
        }   
        
        public var position:AVAudio3DPoint { flow?.position ?? .init() }
        
        @discardableResult
        public func position( _ pos:AVAudio3DPoint ) -> Self {
            flow?.position = pos
            return self
        } 

        @discardableResult
        public func position( x:Float, y:Float, z:Float ) -> Self {
            flow?.position = .init( x:x, y:y, z:z )
            return self
        }         
    }
}
