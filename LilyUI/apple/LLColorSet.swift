//
//  LLColorManager.swift
//  Lily
//
//  Created by Kengo on 2021/01/23.
//  Copyright © 2021 Watanabe-DENKI.Inc. All rights reserved.
//

import Foundation

open class LLColorSetModule
{
    fileprivate init() {
        // デフォルト値を設定
        set( uikey:"view", key:"background", hexes:( "#FFFFFF", "#212121" ) )
    }
    
    public var dict:[String:[String:ColorPattern]] = [:]
    
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

// 外部へはLLColorSet実体として提供
public let LLColorSet = LLColorSetModule()
