//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import AppKit

/// NSTextFieldチェインアクセサ : プロパティ
public extension LLChain where TObj:NSTextField
{
    var text:LLString? { obj.stringValue }
    
    @discardableResult
    func text( _ txt:LLString? ) -> Self { 
        obj.stringValue = txt ?? ""
        return self
    }
            
    var textColor:NSColor { obj.textColor! }
    
    @discardableResult
    func textColor( uiColor:NSColor ) -> Self { 
        obj.textColor = uiColor
        return self
    }
    
    @discardableResult
    func textColor( _ llc:LLColor ) -> Self { 
        obj.textColor = llc.nsColor
        return self
    }
    
    var font:NSFont { obj.font! }
    
    @discardableResult
    func font( _ f:NSFont ) -> Self {
        obj.font = f
        return self
    }
    
    var fontSize:LLFloat { obj.font!.pointSize.f }
  
    @discardableResult
    func fontSize( _ sz:LLFloat ) -> Self {
        let f_desc = obj.font!.fontDescriptor
        obj.font = NSFont( descriptor: f_desc, size: sz.cgf )
        return self
    }
    
    var textAlignment:NSTextAlignment { obj.alignment }
    
    @discardableResult
    func textAlignment( _ align:NSTextAlignment ) -> Self {
        obj.alignment = align
        return self
    }
    
    /*
    var autocapitalizationType:UITextAutocapitalizationType { obj.autocapitalizationType }
    
    @discardableResult
    func autocapitalizationType( _ type:UITextAutocapitalizationType ) -> Self {
        obj.autocapitalizationType = type
        return self
    }
    
    var autocorrectionType:UITextAutocorrectionType { obj.autocorrectionType }
    
    @discardableResult
    func autocorrectionType( _ type:UITextAutocorrectionType ) -> Self {
        obj.autocorrectionType = type
        return self
    }
    */
    
    var adjustsFontSizeToFitWidth:Bool { return false }
    
    @discardableResult
    func adjustsFontSizeToFitWidth( _ torf:Bool ) -> Self {
        // NOTE: Macではサイズ調整なし
        return self
    }
}

#endif
