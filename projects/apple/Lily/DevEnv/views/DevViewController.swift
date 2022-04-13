
//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import LilySwift
import Foundation
import UIKit

class Fragment
{
    private var parent:LLViewController
    init( _ vc:LLViewController ) {
        parent = vc
    }
    
    lazy var bt = LLButton().chain
    .setup.add( caller:parent ) { caller, me in
        me.chain
        .text( "テスト" )
        .fontSize( 20 )
        .isEnabled( false )
    }
    .layout( caller:parent ) { caller, me in
        me.chain
        .rect( 40, 40, 200, 60 )
    }
    .style.default { me in
        me.chain
        .textAlignment( .center )
        .borderWidth( 2.0 )
        .textColor( .blue )
        .borderColor( .blue )
        .backgroundColor( .lightBlue )
        .cornerRadius( me.height.f / 2.0 )
        .alpha( 1.0 )
    }
    .style.action {
        $0.chain
        .alpha( 0.5 )
    }
    .style.disable { me in
        me.chain
        .textColor( .lightGrey )
        .borderColor( .lightGrey )
        .backgroundColor( LLColor( "#F2F2F2" ) )
    }
}

class DevViewController : LLViewController
{   
    lazy var frag = Fragment( self )
    
    lazy var tf = LLTextField().chain
    .setup.add( caller:self ) { caller, me in
        me.chain
        .placeholderText( "ぷれいすほるだー" )
        .fontSize( 20 )
    }
    .layout( caller:self ) { caller, me in
        me.chain
        .rect( 40, 120, 200, 40 )
    }
    
    lazy var v = LLView().chain
    .setup.add( caller:self ) { caller, me in
        me.chain
        .isEnabled( true )
    }
    .layout( caller:self ) { caller, me in
        me.chain
        .rect( 40, 180, 60, 60 )
    }
    .actionBegan.add( caller:self ) { caller, me, arg in
        print( "押した" )
        caller.frag.bt.isEnabled( !caller.frag.bt.isEnabled )
    }
    .style.default {
        $0.chain.backgroundColor( .aquamarine )
    }
    .style.action {
        $0.chain.backgroundColor( .paleVioletred )
    }
    .style.disable {
        $0.chain.backgroundColor( .lightGrey )
    }
    
    override func setup() {
        self.addSubview( frag.bt )
        self.addSubview( tf )
        self.addSubview( v )
    }
}
