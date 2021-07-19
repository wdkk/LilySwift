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
        .setup.add( with:self ) { caller, me in
            me.chain
            .isUserInteractionEnabled( true )
            .maskToBounds( true )
            .borderWidth( 2.0 )
        }
        .defaultBuildup.add( with:self ) { caller, me in
            me.chain
            .textAlignment( .center )
            .textColor( llc:LLColorSet["button","text"] )
            .borderColor( LLColorSet["button","border"] )
            .backgroundColor( LLColorSet["button","background"] )
        }
        .staticBuildup.add( with:self ) { caller, me in
            me.chain
            .cornerRadius( self.height.f / 2.0 )
        }
        .touchesBegan.add( with:self ) { caller, me, phenomena in
            me.chain
            .textColor( llc:LLColorSet["button","text-active"] )
            .borderColor( LLColorSet["button","border-active"] )
        }
        .touchesEnded.add( with:self ) { caller, me, phenomena in
            me.chain
            .textColor( llc:LLColorSet["button","text"] )
            .borderColor( LLColorSet["button","border"] )
        }
    }
}

#endif
