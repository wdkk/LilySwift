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

/// UILabelチェインアクセサ : プロパティ
public extension LLChain where TObj:UILabel
{
    var text:LLString? { obj.text }
    
    @discardableResult
    func text( _ txt:LLString? ) -> Self { 
        obj.text = txt
        return self
    }
    
    var textColor:UIColor { obj.textColor }
    
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
        obj.font = UIFont( name: obj.font.familyName, size: sz.cgf )
        return self
    }
    
    var textAlignment:NSTextAlignment { obj.textAlignment }
    
    @discardableResult
    func textAlignment( _ align:NSTextAlignment ) -> Self {
        obj.textAlignment = align
        return self
    }
}

/// UILabelチェインアクセサ : メソッド
public extension LLChain where TObj:UILabel
{
    @discardableResult
    func sizeToFit() -> Self { 
        obj.sizeToFit()
        return self
    }
}

#endif
