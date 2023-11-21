//
//  LLColorManager.swift
//  Lily
//
//  Created by Kengo Watanabe on 2021/01/23.
//  Copyright © 2021 Watanabe-DENKI, Inc.. All rights reserved.
//

import Foundation

// TODO: 廃止予定: カラーセットの処理はSwiftUIに合わせて見直し
/*
extension Lily.View
{
    open class ColorSet
    {
        public static let shared:ColorSet = .init()
        
        fileprivate init() {
            // デフォルト値を設定
            set( uikey:"view", key:"background", hexes:( "#FFFFFF", "#212121" ) )
            set( uikey:"view", key:"text", hexes:( "#444444", "#FFFFFF" ) )
            set( uikey:"view", key:"text-error", hexes:( "#FF2222", "#EE4444" ) )
            
            // ボタン
            set( uikey:"button", key:"background", hexes:( "#FFFFFF", "#212121" ) )
            set( uikey:"button", key:"text", hexes:( "#4488BB", "#88BBFF" ) )
            set( uikey:"button", key:"text-active", hexes:( "#88BBFF", "#4488BB" ) )
            set( uikey:"button", key:"border", hexes:( "#4488BB", "#88BBFF" ) )
            set( uikey:"button", key:"border-active", hexes:( "#88BBFF", "#4488BB" ) )
            set( uikey:"button", key:"disable", hexes:( "#BBBBBB", "#888888" ) )
            
            // テキストフィールド
            set( uikey:"text-field", key:"background", hexes:( "#FFFFFF", "#212121" ) )
            set( uikey:"text-field", key:"text", hexes:( "#444444", "#FFFFFF" ) )
            set( uikey:"text-field", key:"border", hexes:( "#666666", "#DDDDDD" ) )
            set( uikey:"text-field", key:"placeholder", hexes:( "#999999", "#888888" ) )
        }
        
        var dict:[String:[String:ColorPattern]] = [:]
        
        public subscript( uikey:String, key:String ) -> LLColor {
            get { 
                guard let cp = self.dict[uikey]?[key] else { return .cyan }  // 値がない時はシアンを返す 
                return cp.get( self.type )
            }
        }
        
        public func set( uikey:String, key:String, pattern:ColorPattern ) {
            if dict[uikey] == nil { dict[uikey] = [:] }
            dict[uikey]?[key] = pattern
        }
        
        public func set( uikey:String, key:String, hexes:(String,String) ) {
            if dict[uikey] == nil { dict[uikey] = [:] }
            dict[uikey]?[key] = ColorPattern( lightHex:hexes.0, darkHex:hexes.1 )
        }
        
        public enum ColorType {
            case light
            case dark
        }
        public var type:ColorType = .light
        
        public struct ColorPattern {
            var light = LLColor()
            var dark = LLColor()
            
            init( _ lightColor:LLColor, _ darkColor:LLColor ) {
                self.light = lightColor
                self.dark = darkColor
            }
            
            init( lightHex:String, darkHex:String ) {
                self.light = LLColor( lightHex )
                self.dark = LLColor( darkHex )
            }
            
            func get( _ type:ColorType ) -> LLColor {
                switch type {
                    case .light: return self.light
                    case .dark : return self.dark
                }
            }
        }
    }
}
*/
