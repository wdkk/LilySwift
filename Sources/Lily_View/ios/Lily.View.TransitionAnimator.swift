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

extension Lily.View
{
    public typealias TransitionFunction = (_ from:UIViewController, _ to:UIViewController )->Void
    
    public struct TransitionSet {
        var start:TransitionFunction 
        var end:TransitionFunction
        var completion:TransitionFunction
    }
    
    open class TransitionAnimator
    {
        open var duration:Float = 0.5
        open var options:UIView.AnimationOptions = []
        open var start:TransitionFunction = { _,_ in }
        open var end:TransitionFunction = { _,_ in }
        open var completion:TransitionFunction = { _,_ in }
        
        open var style:TransitionSet {
            get { return TransitionSet( start:start, end:end, completion:completion ) }
            set {
                start = newValue.start
                end = newValue.end
                completion = newValue.completion
            }
        }
        
        public init( style ts:TransitionSet, duration dur:Float = 0.5 ) {
            self.style = ts
            self.duration = dur
        }
    }
}

public extension Lily.View.TransitionSet
{
    @MainActor
    static var slideRight:Self {
        return .init(
            start:
                { from, to in
                    from.view.frame.x = 0.0
                    to.view.frame.x = from.width
                },
            end:
                { from, to in
                    from.view.frame.x = -from.view.width
                    to.view.frame.x = 0.0
                },
            completion:
                { from, to in
                    from.view.frame.x = 0.0
                }
        )
    }
    
    @MainActor
    static var slideLeft:Self {
        return .init(
            start:
                { from, to in
                    from.view.frame.x = 0.0
                    to.view.frame.x = -from.view.width
                },
            end:
                { from, to in
                    from.view.frame.x = from.view.width
                    to.view.frame.x = 0.0
                },
            completion:
                { from, to in
                    from.view.frame.x = 0.0
                }
        )
    }
    
    @MainActor
    static var overUp:Self {
        return .init(
            start:
                { from, to in
                    to.view.frame.y = from.height
                },
            end:
                { from, to in
                    to.view.frame.y = 0.0
                },
            completion:
                { from, to in
                    from.view.frame.y = 0.0
                }
        )
    }
    
    @MainActor
    static var overDown:Self {
        return .init(
            start:
                { from, to in
                    to.view.frame.y = 0.0
                },
            end:
                { from, to in
                    to.view.frame.y = from.height
                },
            completion:
                { from, to in
                    to.view.frame.y = from.height
                }
        )
    }
    
    @MainActor
    static var disolveRight:Self {
        return .init(
            start:
                { from, to in
                    from.view.alpha = 1.0
                    from.view.frame.x = 0.0
                    to.view.alpha = 0.0
                    to.view.frame.x = from.view.width / 2.0
                },
            end:
                { from, to in
                    from.view.alpha = 0.0
                    from.view.frame.x = -from.view.width / 2.0
                    to.view.alpha = 1.0
                    to.view.frame.x = 0.0
                },
            completion:
                { from, to in
                    from.view.alpha = 1.0
                    from.view.frame.x = 0.0
                }
        )
    }
    
    @MainActor
    static var disolveLeft:Self {
        return .init(
            start:
                { from, to in
                    from.view.alpha = 1.0
                    from.view.frame.x = 0.0
                    to.view.alpha = 0.0
                    to.view.frame.x = -from.view.width / 2.0  // 元画像サイズを参考に次のビューの開始位置を決める
                },
            end:
                { from, to in
                    from.view.alpha = 0.0
                    from.view.frame.x = from.view.width / 2.0
                    to.view.alpha = 1.0
                    to.view.frame.x = 0.0
                },
            completion:
                { from, to in
                    from.view.alpha = 1.0
                    from.view.frame.x = 0.0
                }
        )
    }
    
    @MainActor
    static var disolveUp:Self {
        return .init(
            start:
                { from, to in
                    from.view.alpha = 1.0
                    from.view.frame.y = 0.0
                    to.view.alpha = 0.0
                    to.view.frame.y = from.view.height / 2.0
                },
            end:
                { from, to in
                    from.view.alpha = 0.0
                    from.view.frame.y = -from.view.height / 2.0
                    to.view.alpha = 1.0
                    to.view.frame.y = 0.0
                },
            completion:
                { from, to in
                    from.view.alpha = 1.0
                    from.view.frame.y = 0.0
                }
        )
    }
    
    @MainActor
    static var disolveDown:Self {
        return .init(
            start:
                { from, to in
                    from.view.alpha = 1.0
                    from.view.frame.y = 0.0
                    to.view.alpha = 0.0
                    to.view.frame.y = -from.view.height / 2.0
                },
            end:
                { from, to in
                    from.view.alpha = 0.0
                    from.view.frame.y = from.view.height / 2.0
                    to.view.alpha = 1.0
                    to.view.frame.y = 0.0
                },
            completion:
                { from, to in
                    from.view.alpha = 1.0
                    from.view.frame.y = 0.0
                }
        )
    }
    
    @MainActor
    static var fade:Self {
        return .init(
            start:
                { from, to in
                    from.view.alpha = 1.0
                    to.view.alpha = 0.0
                },
            end:
                { from, to in
                    from.view.alpha = 0.0
                    to.view.alpha = 1.0
                },
            completion:
                { from, to in
                    from.view.alpha = 1.0
                    to.view.alpha = 1.0
                }
        )
    }
}


#endif
