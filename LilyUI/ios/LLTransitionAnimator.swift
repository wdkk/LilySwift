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

public typealias LLTransitionFunction = (_ from:UIViewController, _ to:UIViewController )->Void

public struct LLTransitionSet {
    var start:LLTransitionFunction
    var end:LLTransitionFunction
    var completion:LLTransitionFunction
}

open class LLTransitionAnimator
{
    open var duration:Float = 0.5
    open var options:UIView.AnimationOptions = []
    open var start:LLTransitionFunction = { _,_ in }
    open var end:LLTransitionFunction = { _,_ in }
    open var completion:LLTransitionFunction = { _,_ in }
    
    open var style:LLTransitionSet {
        get { return LLTransitionSet( start:start, end:end, completion:completion ) }
        set {
            start = newValue.start
            end = newValue.end
            completion = newValue.completion
        }
    }
        
    public init( style ts:LLTransitionSet, duration dur:Float = 0.5 ) {
        self.style = ts
        self.duration = dur
    }
}

public extension LLTransitionSet
{
    static var slideRight:LLTransitionSet {
        return LLTransitionSet(
            start:
            { ( from, to ) in
                from.view.x = 0.0
                to.view.x = to.width
            },
            end:
            { ( from, to ) in
                from.view.x = -from.view.width
                to.view.x = 0.0
            },
            completion:
            { ( from, to ) in
                from.view.x = 0.0
            }
        )
    }
    
    static var slideLeft:LLTransitionSet {
        return LLTransitionSet(
            start:
            { ( from, to ) in
                from.view.x = 0.0
                to.view.x = -to.view.width
            },
            end:
            { ( from, to ) in
                from.view.x = from.view.width
                to.view.x = 0.0
            },
            completion:
            { ( from, to ) in
                from.view.x = 0.0
            }
        )
    }
    
    static var disolveRight:LLTransitionSet {
        return LLTransitionSet(
            start:
            { ( from, to ) in
                from.view.alpha = 1.0
                from.view.x = 0.0
                to.view.alpha = 0.0
                to.view.x = to.view.width / 4.0
            },
            end:
            { ( from, to ) in
                from.view.alpha = 0.0
                from.view.x = -from.view.width / 4.0
                to.view.alpha = 1.0
                to.view.x = 0.0
            },
            completion:
            { ( from, to ) in
                from.view.alpha = 1.0
                from.view.x = 0.0
            }
        )
    }
    
    static var disolveLeft:LLTransitionSet {
        return LLTransitionSet(
            start:
            { ( from, to ) in
                from.view.alpha = 1.0
                from.view.x = 0.0
                to.view.alpha = 0.0
                to.view.x = -to.view.width / 4.0
            },
            end:
            { ( from, to ) in
                from.view.alpha = 0.0
                from.view.x = from.view.width / 4.0
                to.view.alpha = 1.0
                to.view.x = 0.0
            },
            completion:
            { ( from, to ) in
                from.view.alpha = 1.0
                from.view.x = 0.0
            }
        )
    }
}

#endif
