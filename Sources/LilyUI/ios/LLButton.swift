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

open class LLButton : LLLabel
{
    public required init?(coder: NSCoder) { super.init(coder:coder) }
    override public init() {
        super.init()
        
        self.chain
        .style.default { me in
            me.chain
            .textAlignment( .center )
            .borderWidth( 2.0 )
            .textColor( llc: LLColorSet["button","text"]  )
            .borderColor( LLColorSet["button","border"]  )
            .backgroundColor( LLColorSet["button","background"] )
            .cornerRadius( self.height.f / 2.0 )
        }
        .style.action { me in
            me.chain
            .textColor( llc:LLColorSet["button","text-active"] )
            .borderColor( LLColorSet["button","border-active"] )
        }
        .style.disable { me in
            me.chain
            .textColor( llc: LLColorSet["button","disable"] )
            .borderColor( LLColorSet["button","disable"] )
            .backgroundColor( LLColorSet["button","background"] )
            .cornerRadius( self.height.f / 2.0 )
        }
    }
    
    open override func setup() {
        super.setup()
    
        self.chain
        .setup.add( order:.pre, caller:self ) { caller, me in
            me.chain
            .maskToBounds( true )
            .isEnabled( true )
        }
    }
}

#endif
