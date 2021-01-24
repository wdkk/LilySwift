//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import LilySwift
import UIKit
import WebKit

/*
class MyViewController : LLViewController
{   
    lazy var red_view = LLView().chain
    .setup.add( with:self ) {
        $1.backgroundColor = .green
    }
    .buildup.add( with:self ) {
        $1.rect = LLRect( 20, 150, 140, 140 )
    }
    
    override func setup() {        
        super.setup()
        self.view.addSubview( red_view )
    }
}
*/

/*
class MyViewController : LLViewController
{    
    lazy var view_logo = LLImageView().chain
    .setup.add( with:self ) { caller, me in
        //me.chain
        //.image( UIImage( named:"sip_logo.jpg" ) )
    }
    .buildup.add( with:self ) { caller, me in
        me.chain
        .rect( 50, 50, 200, 108 )
    }
    
    override func setup() {
        super.setup()
        self.view.addSubview( view_logo )
        
        let img = LLImage( LLPath.bundle( "supportFiles/images/Lily.png" ) )
        print( img.cgImage )
        view_logo.image( img )
    }
}
*/


class MyViewController : LLViewController
{
    lazy var bt_next = LLButton().chain
    .setup.add( with:self ) { caller, me in
        me.chain
        .text( "ボタン" )
        .fontSize( 20 )
    }
    .buildup.add( with:self ) { caller, me in
        me.chain
        .rect( 100, 100, 120, 50 )
    }
    .touchesBegan.add( with:self ) { caller, me, phenomena in
        print("ボタンを押しました")
    }
          
    override func setup() {
        super.setup()
        self.view.addSubview( bt_next )
    }
    
    override func buildup() {
        super.buildup()
        self.view.backgroundColor = LLColorSet["view","background"].uiColor
    }
}
