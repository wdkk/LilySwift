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
    
    var font:UIFont { obj.font }
    
    @discardableResult
    func font( _ f:UIFont ) -> Self {
        obj.font = f
        return self
    }
    
    var fontSize:LLFloat { obj.font!.pointSize.f }
  
    @discardableResult
    func fontSize( _ sz:LLFloat ) -> Self {
        let f_desc = obj.font.fontDescriptor
        obj.font = UIFont( descriptor: f_desc, size: sz.cgf )
        return self
    }
        
    var textAlignment:NSTextAlignment { obj.textAlignment }
    
    @discardableResult
    func textAlignment( _ align:NSTextAlignment ) -> Self {
        obj.textAlignment = align
        return self
    }
    
    var numberOfLines:Int { obj.numberOfLines }
    
    @discardableResult
    func numberOfLines( _ number:Int ) -> Self {
        obj.numberOfLines = number
        return self
    }
    
    var adjustsFontSizeToFitWidth:Bool { obj.adjustsFontSizeToFitWidth }
    
    @discardableResult
    func adjustsFontSizeToFitWidth( _ torf:Bool ) -> Self {
        obj.adjustsFontSizeToFitWidth = torf
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

public extension LLChain where TObj:UILabel, TObj:LLUILifeEvent
{
    @discardableResult
    func isEnabled( _ torf:Bool ) -> Self { 
        obj.isEnabled = torf
        obj.isUserInteractionEnabled = torf
        obj.rebuild()
        return self
    }
    
    var isEnabled:Bool { obj.isEnabled }
}


#endif
