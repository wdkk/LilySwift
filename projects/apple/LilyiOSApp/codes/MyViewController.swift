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
import QuartzCore

/*
class MyViewController : LBViewController
{   
    // パネルを格納するセット
    var panels = Set<LBPanel>()
    
    // 四角形デコレーションの用意
    lazy var objpl_rect = LBPanelPipeline.rectangle()
    
    // 画面が更新された時の構築処理
    override func buildupBoard() {
        super.buildupBoard()
        
        // Metalの背景色の設定
        self.clearColor = .lightGrey
        
        // すでにあるパネルセットを消す
        panels.removeAll()
        
        // パネルを四角で作成
        let p = LBPanel( objpl: objpl_rect )
        .color( .blue )
            
        // パネルセットに追加
        panels.insert( p )
    }
}
*/
 
class MyViewController : LLViewController
{
    lazy var img_view = LLImageView().chain
    .buildup.add( with:self ) { caller, me in
        me.chain
        .rect( 50, 50, 256, 256 )
    }
    
    override func setup() {
        super.setup()
        self.view.addSubview( img_view )
    }
    
    override func buildup() {
        super.buildup()

        let img = LLImage( LLPath.bundle( "supportFiles/images/Lily.png" ) )
        img_view.image( img )
    }
}
