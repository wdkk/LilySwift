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
    open override func setup() {
        super.setup()
    
        self.chain
        .setup.add( order:.pre, caller:self ) { caller, me in
            me.chain
            .maskToBounds( true )
            .borderWidth( 2.0 )
            .isEnabled( true )
        }
        .defaultBuildup.add( order:.pre, caller:self ) { caller, me in
            me.chain
            .textAlignment( .center )
            .textColor( llc: me.isEnabled ? LLColorSet["button","text"] : LLColorSet["button","disable"] )
            .borderColor( me.isEnabled ? LLColorSet["button","border"] : LLColorSet["button","disable"] )
            .backgroundColor( LLColorSet["button","background"] )
        }
        .staticBuildup.add( order:.pre, caller:self ) { caller, me in
            me.chain
            .cornerRadius( self.height.f / 2.0 )
        }
        .touchesBegan.add( order:.pre, caller:self ) { caller, me, phenomena in
            if !me.isEnabled { return }
            me.chain
            .textColor( llc:LLColorSet["button","text-active"] )
            .borderColor( LLColorSet["button","border-active"] )
        }
        .touchesEnded.add( order:.pre, caller:self ) { caller, me, phenomena in
            if !me.isEnabled { return }
            me.chain
            .textColor( llc:LLColorSet["button","text"] )
            .borderColor( LLColorSet["button","border"] )
        }
    }
}

#endif
