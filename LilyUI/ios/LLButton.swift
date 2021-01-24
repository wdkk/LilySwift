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
    public override func setup() {
        super.setup()
        
        LLColorSet.set( uikey:"button",key:"background", hexes:( "#FFFFFF", "#212121" ) )
        LLColorSet.set( uikey:"button",key:"text", hexes:( "#4488BB", "#88BBFF" ) )
        LLColorSet.set( uikey:"button",key:"text-active", hexes:( "#88BBFF", "#4488BB" ) )
        LLColorSet.set( uikey:"button",key:"border", hexes:( "#4488BB", "#88BBFF" ) )
        LLColorSet.set( uikey:"button",key:"border-active", hexes:( "#88BBFF", "#4488BB" ) )
        
        self.chain
        .isUserInteractionEnabled( true )
        .maskToBounds( true )
        .borderWidth( 2.0 )
        .buildup.add( "   Pre", with:self ) { caller, me in
            me.chain
            .textAlignment( .center )
            .textColor( llc:LLColorSet["button","text"] )
            .borderColor( LLColorSet["button","border"] )
            .backgroundColor( LLColorSet["button","background"] )
        }
        .buildup.add( "zzzPost", with:self ) { caller, me in
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
