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
    public class PGAudioPool
    {
        nonisolated(unsafe) public static let shared:PGAudioPool = .init()
        private init() {}
        
        private var soundGroup:[PGAudioStorage:Set<PGSound>] = [:]
        
        public func sounds( on storage:PGAudioStorage? ) -> Set<PGSound> { 
            guard let storage = storage else { return [] }
            return soundGroup[storage] ?? [] 
        }
        
        public func insert( sound:PGSound, to storage:PGAudioStorage? ) {
            guard let storage = storage else { return }
            if soundGroup[storage] == nil { soundGroup[storage] = [] }
            
            if sound.channel == -1 { return }
            
            if let previous_sound = soundGroup[storage]!.filter({ $0.channel == sound.channel }).first {
                soundGroup[storage]?.remove( previous_sound )
            }
            
            soundGroup[storage]?.insert( sound ) 
        }
        
        public func remove( sound:PGSound, to storage:PGAudioStorage? ) {
            guard let storage = storage else { return }
            soundGroup[storage]?.remove( sound )
        }
        
        public func removeAllSounds( on storage:PGAudioStorage? ) {
            guard let storage = storage else { return }
            soundGroup[storage]?.forEach { $0.trush() }
        }
    }
}

#endif
