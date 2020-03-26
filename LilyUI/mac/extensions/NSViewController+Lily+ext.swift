//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import Cocoa

extension NSViewController : LLUIRectControllable, LLUIPixelControllable
{
    public var ourCenter: CGPoint {
        get { return self.view.ourCenter }
        set { self.view.ourCenter = newValue }
    }
    
    public var ourBounds: CGRect {
        get { return self.view.bounds }
        set { self.view.bounds = newValue }
    }
    
    public var ourFrame: CGRect {
        get { return self.view.frame }
        set { self.view.frame = newValue }
    }
}

// MARK: - セーフエリア/コントロールエリア制御
public extension NSViewController
{
    // セーフエリア領域(viewWilLayoutSubviews以降に有効)
    var safeArea:LLRect {
        //return view.bounds.insetBy( view.safeAreaInsets ).llRect
        return view.bounds.llRect
    }
    
    // 操作可能領域(viewWilLayoutSubviews以降に有効)
    var controllableArea:LLRect {
        //return view.bounds.inset(by: view.layoutMargins ).llRect
        return view.bounds.llRect
    }
}

// MARK: - UI親子関係アクセサ
public extension NSViewController
{
    var keyWindow:NSWindow? { return self.view.window }
}

// MARK: - ステータスバー領域情報
public extension NSViewController
{ 
    /// ステータスバー領域情報
    var statusBarFrame:LLRect {
        return .zero
        /*
        guard let manager = windowScene?.statusBarManager else { return .zero }  
        return manager.statusBarFrame.llRect
        */
    }
    
    /// デバイスの状況に合わせたステータスバーの高さ
    var statusBarHeight:LLDouble {
        return statusBarFrame.size.height
    }
}

#endif
