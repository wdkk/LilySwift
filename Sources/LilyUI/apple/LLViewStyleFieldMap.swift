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

public class LLViewStyleFieldMap : LLFieldMap 
{
    public typealias Args = Any

    private let DEFAULT:Int = 0
    private let ACTION:Int = 1 
    private let DISABLE:Int = 2
    
    public var `default`:LLField? { 
        get { return fields[DEFAULT] }
        set { fields[DEFAULT] = newValue }
    }
    
    open func `default`<TView:AnyObject>(
        label:String = UUID().labelString,
        me view:TView,
        field f:@escaping (TView)->Void 
    )
    {
        fields[DEFAULT] = LLSoloField<TView, Args>(
            label:label,
            me:view,
            action:f
        )
    }
    
    public var action:LLField? { 
        get { return fields[ACTION] }
        set { fields[ACTION] = newValue }
    }
    
    open func action<TView:AnyObject>(
        label:String = UUID().labelString,
        me view:TView,
        field f:@escaping (TView)->Void )
    {
        fields[ACTION] = LLSoloField<TView, Args>(
            label:label,
            me:view,
            action:f
        )
    }
    
    public var disable:LLField? {
        get { return fields[DISABLE] }
        set { fields[DISABLE] = newValue }
    }
    
    open func disable<TView:AnyObject>(
        label:String = UUID().labelString,
        me view:TView,
        field f:@escaping (TView)->Void )
    {
        fields[DISABLE] = LLSoloField<TView, Args>(
            label:label,
            me:view,
            action:f
        )
    }
}
