//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS)

import UIKit

/// UITextFieldチェインアクセサ : プロパティ
public extension LLChain where TObj:UITextField
{
    var text:LLString? { obj.text }
    
    @discardableResult
    func text( _ txt:LLString? ) -> Self { 
        obj.text = txt
        return self
    }
            
    var textColor:UIColor { obj.textColor! }
    
    @discardableResult
    func textColor( _ c:UIColor ) -> Self { 
        obj.textColor = c
        return self
    }
    
    @discardableResult
    func textColor( llc:LLColor ) -> Self { 
        obj.textColor = llc.uiColor
        return self
    }
    
    var fontSize:LLFloat { obj.font!.pointSize.f }
  
    @discardableResult
    func fontSize( _ sz:LLFloat ) -> Self {
        if obj.font == nil { obj.font = UIFont() }
        obj.font = UIFont( name: obj.font!.familyName, size: sz.cgf )
        return self
    }
    
    
    var textAlignment:NSTextAlignment { obj.textAlignment }
    
    @discardableResult
    func textAlignment( _ align:NSTextAlignment ) -> Self {
        obj.textAlignment = align
        return self
    }
    
    
    var isSecureTextEntry:Bool { obj.isSecureTextEntry }
    
    @discardableResult
    func isSecureTextEntry( _ torf:Bool ) -> Self {
        obj.isSecureTextEntry = torf
        return self
    }
    
    
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
    
    var adjustsFontSizeToFitWidth:Bool { obj.adjustsFontSizeToFitWidth }
    
    @discardableResult
    func adjustsFontSizeToFitWidth( _ torf:Bool ) -> Self {
        obj.adjustsFontSizeToFitWidth = torf
        return self
    }
}

#endif
