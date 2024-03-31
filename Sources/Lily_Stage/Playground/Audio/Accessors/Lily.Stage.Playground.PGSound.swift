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
        public private(set) var audioIndex:Int = -1
        public let name:String
        
        public var iterateField:PGField<PGSound, LLEmpty>?
        
        @discardableResult
        public init( 
            storage:PGAudioStorage? = .current,
            _ name:String
        )
        {
            self.storage = storage
            self.name = name
            
            PGAudioPool.shared.insert( sound:self, to:storage )
        }
        
        private var flow:PGAudioFlow? {
            if audioIndex == -1 { return nil }
            guard let storage = storage else { return nil }
            let flows = storage.engine.flows
            if flows.count <= audioIndex { return nil }
            return flows[audioIndex]
        }
        
        public func set(
            assetName:String,
            startTime:Double? = nil,
            endTime:Double? = nil
        ) -> Self
        {
            self.audioIndex = storage?.request(
                name:name,
                assetName:assetName,
                startTime:startTime,
                endTime:endTime
            ) ?? -1
            
            return self
        }
        
        public func play() {
            flow?.play()
        }
        
        public func pause() {
            flow?.pause()
        }
        
        public func stop() {
            flow?.stop()
        }
        
        public func trush() {
            storage?.trush( index:audioIndex )
            iterateField = nil
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
        
        ////
        
        public var volume:Float { flow?.volume ?? 0.0 }
        
        @discardableResult
        public func volume( _ v:Float ) -> Self {
            flow?.volume( v )
            return self
        }        
        
        public var `repeat`:Bool { flow?.isRepeating ?? false }
        
        @discardableResult
        public func `repeat`( _ v:Bool ) -> Self {
            flow?.repeat( v )
            return self
        }        
                
    }
}
