//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS)

import UIKit

public struct LLTouchFieldContainerFlow<TView:AnyObject>
{   
    public weak var fc:LLTouchFieldContainer?
    public var view:TView
    
    public init( _ fc:LLTouchFieldContainer, _ flow:LLFlow<TView> ) { 
        self.fc = fc
        self.view = flow.obj
    }
    
    @discardableResult
    public func add<TCaller:AnyObject, TPhenomena>(
        label:String = UUID().uuidString,
        with caller:TCaller,
        join phenomena:TPhenomena,
        field f:@escaping (LLDiscussionField<TCaller, TView, LLTouchArg, TPhenomena>.Object,
        TPhenomena)->Void )
    -> LLFlow<TView>
    {
        self.fc?.add(label: label, with: caller, target: self.view, join:phenomena, field: f )
        return LLFlow( self.view )
    }
    
    @discardableResult
    public func add<TCaller:AnyObject>( 
        label:String = UUID().uuidString,
        with caller:TCaller,
        field f:@escaping (LLDiscussionField<TCaller, TView, LLTouchArg, LLEmptyPhenomena>.Object,
        LLEmptyPhenomena)->Void )
    -> LLFlow<TView>
    {
        self.fc?.add(label: label, with: caller, target:self.view, field: f )
        return LLFlow( self.view )
    }    
}

#endif
