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
    
        public static var soundMap:[String:PGSound] = [:]
        public static subscript( name:String ) -> PGSound? { 
            get{ Self.soundMap[name] }
            set{ Self.soundMap[name] = newValue }
        }
        
        public let storage:PGAudioStorage?
        public private(set) var audioIndex:Int
        public let name:String
        
        public var iterateField:PGField<PGSound, LLEmpty>?
        
        @discardableResult
        public init( storage:PGAudioStorage? = .current, name:String, assetName:String ) {
            self.storage = storage
            self.name = name
            if let s = PGSound[name] {
                self.audioIndex = storage?.request( overwriteIndex:s.audioIndex, assetName:assetName ) ?? -1
            }
            else {
                self.audioIndex = storage?.request( assetName:assetName ) ?? -1
            }
            
            PGSound[name] = self
            
            PGAudioPool.shared.insert( sound:self, to:storage )
        }
        
        private var flow:PGAudioFlow? {
            if audioIndex == -1 { return nil }
            guard let storage = storage else { return nil }
            let flows = storage.engine.flows
            if flows.count <= audioIndex { return nil }
            return flows[audioIndex]
        }
        
        public func play() {
            flow?.play()
        }
        
        public func pause() {
            flow?.pause()
        }
        
        public func stop() {
            flow?.stop()
            trush()
        }
        
        public func trush() {
            storage?.trush( index:audioIndex )
            iterateField = nil
            PGAudioPool.shared.remove( sound:self, to:storage )
        }
        
        ////
        
        public var volume:Float { flow?.volume ?? 0.0 }
        
        @discardableResult
        public func volume( _ v:Float ) -> Self {
            flow?.volume( v )
            return self
        }        
        
        @discardableResult
        public func iterate( _ f:@escaping ( PGSound )->Void ) -> Self {
            self.iterateField = .init( me:self, action:f )
            return self
        }
        
        public func appearIterate() {
            self.iterateField?.appear()
        }
    }
}
