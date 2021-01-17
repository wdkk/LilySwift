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

extension UIViewController : LLUIRectControllable, LLUIPixelControllable
{
    public var ourCenter: CGPoint {
        get { return self.view.center }
        set { self.view.center = newValue }
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
public extension UIViewController
{
    // セーフエリア領域(viewWilLayoutSubviews以降に有効)
    var safeArea:LLRect {
        return view.bounds.inset(by: view.safeAreaInsets ).llRect
    }
    
    // 操作可能領域(viewWilLayoutSubviews以降に有効)
    var controllableArea:LLRect {
        return view.bounds.inset(by: view.layoutMargins ).llRect       
    }
}

// MARK: - UI親子関係アクセサ
public extension UIViewController
{
    var keyWindow:UIWindow? { return self.view.window }
    
    @available(iOS 13.0, *)
    var windowScene:UIWindowScene? { return self.keyWindow?.windowScene }
}

// MARK: - デバイスオリエンテーション情報
public extension UIViewController
{ 
    var deviceOrientation:UIInterfaceOrientation {
        if #available(iOS 13.0, *) {
            guard let win_scene = windowScene else { return .unknown }
            return win_scene.interfaceOrientation
        } 
        else {
            return UIApplication.shared.statusBarOrientation
        }
    }
    
    var isPortrait:Bool {
        return deviceOrientation.isPortrait
    }
}

// MARK: - ステータスバー領域情報
public extension UIViewController
{ 
    /// ステータスバー領域情報
    var statusBarFrame:LLRect {
        if #available(iOS 13.0, *) {
            guard let manager = windowScene?.statusBarManager else { return .zero }
            return manager.statusBarFrame.llRect
        } 
        else {
            return UIApplication.shared.statusBarFrame.llRect 
        }  
    }
    
    /// デバイスの状況に合わせたステータスバーの高さ
    var statusBarHeight:LLDouble {
        return statusBarFrame.size.height
    }
}

#endif
