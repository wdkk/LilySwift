//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS) || os(tvOS) || os(visionOS)

import UIKit

extension UIViewController 
: LLUIRectControllable
{
    public var center: CGPoint {
        get { return self.view.center }
        set { self.view.center = newValue }
    }
    
    public var ownFrame: CGRect {
        get { return self.view.bounds }
        set { self.view.bounds = newValue }
    }
    
    public var frame: CGRect {
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
    
    var windowScene:UIWindowScene? { return self.keyWindow?.windowScene }
}

// MARK: - デバイスオリエンテーション情報
public extension UIViewController
{ 
    #if !os(tvOS)
    var deviceOrientation:UIInterfaceOrientation {
        guard let win_scene = windowScene else { return .unknown }
        return win_scene.interfaceOrientation
    }
    #endif
    
    var isPortrait:Bool {
        #if !os(tvOS)
        return deviceOrientation.isPortrait
        #else
        return true
        #endif
    }
}

// MARK: - ステータスバー領域情報
public extension UIViewController
{ 
    /// ステータスバー領域情報
    var statusBarFrame:LLRect {
        #if !os(tvOS)
        guard let manager = windowScene?.statusBarManager else { return .zero }
        return manager.statusBarFrame.llRect
        #else
        return .zero
        #endif
    }
    
    /// デバイスの状況に合わせたステータスバーの高さ
    var statusBarHeight:LLDouble {
        return statusBarFrame.size.height
    }
}

// MARK: - 操作プロパティ
public extension UIViewController
{ 
    /// 背景色
    var backgroundColor:LLColor? {
        get {
            return view.layer.backgroundColor?.llColor
        }
        set {
            view.layer.backgroundColor = newValue?.cgColor
        }
    }
}

#endif
