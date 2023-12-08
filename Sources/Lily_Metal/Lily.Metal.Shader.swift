//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Foundation
import Metal

extension Lily.Metal 
{
    /// シェーダオブジェクトクラス
    open class Shader
    {
        var device:MTLDevice?
        // Metalシェーダ関数オブジェクト
        public private(set) var function:MTLFunction?
        
        // デフォルトライブラリでシェーダ関数作成
        private func make( _ shaderName:String ) {
            guard let lib = device?.makeDefaultLibrary() else { 
                LLLogWarning( "シェーダの作成に失敗しました." )
                return 
            }
            function = lib.makeFunction( name: shaderName )
        }
        
        // 外部ライブラリファイルでシェーダ関数作成
        private func make( withLib libName:String, shaderName:String ) {
            guard let lib_path = Bundle.main.path(forResource: libName, ofType: "metallib")
            else {
                LLLogWarning( "シェーダの作成に失敗しました." )
                return
            }
            
            do {
                guard let lib_url = lib_path.url,
                      let lib = try device?.makeLibrary( URL:lib_url )
                else {
                    LLLogWarning( "シェーダの作成に失敗しました." )
                    return 
                }
                function = lib.makeFunction( name: shaderName )
            }
            catch {
                LLLogWarning( "例外:シェーダの作成に失敗しました." )
                print( error )
                function = nil
            }
        }
        
        // クラス名指定でバンドル元を指定し(たとえば外部frameworkなど)そこに含まれるdefault.metallibを用いてシェーダ関数作成
        private func make( withClass cls:AnyClass, shaderName:String ) {
            let bundle = Bundle(for: cls.self )
            do {
                guard let lib = try device?.makeDefaultLibrary(bundle: bundle) 
                else {
                    LLLogWarning( "シェーダの作成に失敗しました." )
                    return 
                }
                function = lib.makeFunction( name: shaderName )
            }
            catch {
                LLLogWarning( "例外:シェーダの作成に失敗しました." )
                print( error )
                function = nil
            }
        }
        
        // クラス名指定でバンドル元を指定し(たとえば外部frameworkなど)そこに含まれる指定したmetallibを用いてシェーダ関数作成
        private func make( withClass cls:AnyClass, libName:String, shaderName:String ) {
            guard let lib_path = Bundle(for: cls.self ).path(forResource: libName, ofType: "metallib") 
            else {
                LLLogWarning( "シェーダの作成に失敗しました." )
                return 
            }
            
            do {
                guard let lib_url = lib_path.url,
                      let lib = try device?.makeLibrary( URL:lib_url )
                else { 
                    LLLogWarning( "シェーダの作成に失敗しました." )
                    return
                }
                function = lib.makeFunction( name: shaderName )
            }
            catch {
                LLLogWarning( "例外:シェーダの作成に失敗しました." )
                print( error )
                function = nil
            }
        }
        
        // コード文字列でシェーダ関数作成
        private func make( withCode code:String, shaderName:String ) {
            do {
                guard let lib = try device?.makeLibrary( source: code, options:nil ) 
                else {
                    LLLogWarning( "シェーダの作成に失敗しました." )
                    return
                }
                function = lib.makeFunction( name: shaderName )
            }
            catch {
                LLLogWarning( "例外:シェーダの作成に失敗しました." )
                print( error )
                function = nil
            }
        }
        
        // MTLLibraryでシェーダ関数作成
        private func make( mtllib:MTLLibrary, shaderName:String ) {
            function = mtllib.makeFunction( name: shaderName )
        }
        
        // シェーダを初期化せずにオブジェクトのみ生成
        public init( device:MTLDevice? ) {
            self.device = device
        }    
        
        // デフォルトライブラリでシェーダ関数作成
        public init( device:MTLDevice?, shaderName:String ) {
            self.device = device
            self.make( shaderName )
        }
        
        // 外部ライブラリファイルでシェーダ関数作成
        public init( device:MTLDevice?, libName:String, shaderName:String ) {
            self.device = device
            self.make( withLib:libName, shaderName: shaderName )
        }
        
        // クラス名指定でバンドル元を指定し(たとえば外部frameworkなど)そこに含まれるdefault.metallibを用いてシェーダ関数作成
        public init( device:MTLDevice?, class cls:AnyClass, shaderName:String ) {
            self.device = device
            self.make( withClass:cls, shaderName: shaderName )
        }
        
        // クラス名指定でバンドル元を指定し(たとえば外部frameworkなど)そこに含まれる指定したmetallibを用いてシェーダ関数作成
        public init( device:MTLDevice?, class cls:AnyClass, libName:String, shaderName:String ) {
            self.device = device
            self.make( withClass:cls, libName: libName, shaderName: shaderName )
        }
        
        // コード文字列でシェーダ関数作成
        public init( device:MTLDevice?, code:String, shaderName:String ) {
            self.device = device
            self.make( withCode:code, shaderName: shaderName )
        }
        
        // MTLLibraryでシェーダ関数作成
        public init( device:MTLDevice?, mtllib:MTLLibrary, shaderName:String ) {
            self.device = device
            self.make( mtllib:mtllib, shaderName: shaderName )
        }
    }
}

