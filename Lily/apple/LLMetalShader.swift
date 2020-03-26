//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Foundation
import Metal

/// シェーダオブジェクトクラス
public class LLMetalShader
{
    // Metalシェーダ関数オブジェクト
    public private(set) var function:MTLFunction?

    // デフォルトライブラリでシェーダ関数作成
    public func make( _ shaderName:String ) {
        guard let lib:MTLLibrary = LLMetalManager.device?.makeDefaultLibrary() else { 
            LLLogWarning( "シェーダの作成に失敗しました." )
            return 
        }
        function = lib.makeFunction( name: shaderName )
    }
    
    // 外部ライブラリファイルでシェーダ関数作成
    public func make( withLib libName:String, shaderName:String ) {
        guard let lib_path = Bundle.main.path(forResource: libName, ofType: "metallib") else {
            LLLogWarning( "シェーダの作成に失敗しました." )
            return
        }
        
        do {
            guard let lib:MTLLibrary = try LLMetalManager.device?.makeLibrary( filepath: lib_path ) else {
                LLLogWarning( "シェーダの作成に失敗しました." )
                return 
            }
            function = lib.makeFunction( name: shaderName )
        }
        catch {
            LLLogWarning( "例外:シェーダの作成に失敗しました." )
            function = nil
        }
    }
    
    // クラス名指定でバンドル元を指定し(たとえば外部frameworkなど)そこに含まれるdefault.metallibを用いてシェーダ関数作成
    public func make( withClass cls:AnyClass, shaderName:String ) {
        let bundle = Bundle(for: cls.self )
        do {
            guard let lib:MTLLibrary = try LLMetalManager.device?.makeDefaultLibrary(bundle: bundle) else {
                LLLogWarning( "シェーダの作成に失敗しました." )
                return 
            }
            function = lib.makeFunction( name: shaderName )
        }
        catch {
            LLLogWarning( "例外:シェーダの作成に失敗しました." )
            function = nil
        }
    }
    
    // クラス名指定でバンドル元を指定し(たとえば外部frameworkなど)そこに含まれる指定したmetallibを用いてシェーダ関数作成
    public func make( withClass cls:AnyClass, libName:String, shaderName:String ) {
        guard let lib_path = Bundle(for: cls.self ).path(forResource: libName, ofType: "metallib") else {
            LLLogWarning( "シェーダの作成に失敗しました." )
            return 
        }
        
        do {
            guard let lib:MTLLibrary = try LLMetalManager.device?.makeLibrary( filepath: lib_path ) else { 
                LLLogWarning( "シェーダの作成に失敗しました." )
                return
            }
            function = lib.makeFunction( name: shaderName )
        }
        catch {
            LLLogWarning( "例外:シェーダの作成に失敗しました." )
            function = nil
        }
    }
    
    // コード文字列でシェーダ関数作成
    public func make( withCode code:String, shaderName:String ) {
        do {
            guard let lib:MTLLibrary = try LLMetalManager.device?.makeLibrary( source: code, options:nil ) else { 
                LLLogWarning( "シェーダの作成に失敗しました." )
                return
            }
            function = lib.makeFunction( name: shaderName )
        }
        catch {
            LLLogWarning( "例外:シェーダの作成に失敗しました." )
            function = nil
        }
    }
    
    // MTLLibraryでシェーダ関数作成
    public func make( mtllib:MTLLibrary, shaderName:String ) {
        function = mtllib.makeFunction( name: shaderName )
    }

    // シェーダを初期化せずにオブジェクトのみ生成
    public init() {
    }    
    
    // デフォルトライブラリでシェーダ関数作成
    public init( _ shaderName:String ) {
        self.make( shaderName )
    }
    
    // 外部ライブラリファイルでシェーダ関数作成
    public init( libName:String, shaderName:String ) {
        self.make( withLib:libName, shaderName: shaderName )
    }
    
    // クラス名指定でバンドル元を指定し(たとえば外部frameworkなど)そこに含まれるdefault.metallibを用いてシェーダ関数作成
    public init( class cls:AnyClass, shaderName:String ) {
        self.make( withClass:cls, shaderName: shaderName )
    }
    
    // クラス名指定でバンドル元を指定し(たとえば外部frameworkなど)そこに含まれる指定したmetallibを用いてシェーダ関数作成
    public init( class cls:AnyClass, libName:String, shaderName:String ) {
        self.make( withClass:cls, libName: libName, shaderName: shaderName )
    }
    
    // コード文字列でシェーダ関数作成
    public init( code:String, shaderName:String ) {
        self.make( withCode:code, shaderName: shaderName )
    }
    
    // MTLLibraryでシェーダ関数作成
    public init( mtllib:MTLLibrary, shaderName:String ) {
        self.make( mtllib:mtllib, shaderName: shaderName )
    }
}

