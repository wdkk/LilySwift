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

extension AVAudioFile
{
    // バンドルファイルの読み込み
    public static func load( bundleName:String ) -> AVAudioFile? {
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
    
    // アセットの読み込み
    public static func load( assetName:String ) -> AVAudioFile? {
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
