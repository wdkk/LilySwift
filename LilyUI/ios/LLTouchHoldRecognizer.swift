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

@available(iOS 9.1, *)
open class LLTouchHoldRecognizer
{
    static private var _holded_counter:Int = 0
    private var _holded_id:Int = -1
    private var _hold_prev_pos:CGPoint = .zero
    private var _hold_move_all:CGFloat = 0.0
    private var _touch_pool = [UITouch]()
    
    open var holdTime:LLInt64 = 875
    open var holdLimitMove:CGFloat = 5.0
    open var loop:Bool = false
    open var loopInterval:LLInt64 = 33
    
    open var isEnd:Bool { return (_holded_id == -1) }
    
    open func startHold(
        touches:Set<UITouch>, 
        touchCount touch_count:Int, 
        succeeded:@escaping ()->(), 
        cancelled:@escaping ()->() 
    )
    {
        guard let touch:UITouch = touches.first else { return }
        
        _hold_move_all = 0.0
        _hold_prev_pos = touch.location(in: nil)
        _holded_id = LLTouchHoldRecognizer._holded_counter
        let local_holded_id = LLTouchHoldRecognizer._holded_counter
        LLTouchHoldRecognizer._holded_counter = (LLTouchHoldRecognizer._holded_counter + 1) & 0x00FFFFFF
        
        // clear touches pool
        self._touch_pool.removeAll()
        
        LLTask.Async.sub( waitSec: self.holdTime.d / 1000.0 ) { [weak self] in
            guard let self = self else { return }
            
            let current_holded_id:Int = self._holded_id
            self._holded_id = -1 
            
            // -1の場合強制でホールドキャンセル
            if current_holded_id == -1 { cancelled(); return }
            // idが一致しない場合、ホールドキャンセル
            if current_holded_id != local_holded_id { cancelled(); return }
            // マルチタッチ or タッチキャンセル時はホールドキャンセル
            if touch_count != 1 { cancelled(); return }
            // ホールドを保持するピクセル距離の判定
            if self._hold_move_all > self.holdLimitMove { cancelled(); return }
            // スタイラスで筆圧がよわかったホールドキャンセル
            if touch.type == .stylus && touch.force < 0.125 { cancelled(); return }
            
            LLTask.Sync.main { [weak self] in
                guard let self = self else { return }
                succeeded()
                if self.loop {
                    self.loopHold(touches: touches, touchCount: touch_count, succeeded: succeeded, cancelled: cancelled )
                }
            }
        }
    }
    
    open func loopHold(
        touches:Set<UITouch>,
        touchCount touch_count:Int, 
        succeeded:@escaping ()->(),
        cancelled:@escaping ()->() 
    ) 
    {
        guard let touch:UITouch = touches.first else { return }
        
        _hold_move_all = 0.0
        _hold_prev_pos = touch.location(in: nil)
        _holded_id = LLTouchHoldRecognizer._holded_counter
        let local_holded_id = LLTouchHoldRecognizer._holded_counter
        LLTouchHoldRecognizer._holded_counter = (LLTouchHoldRecognizer._holded_counter + 1) & 0x0000FFFF
        
        // clear touches pool
        self._touch_pool.removeAll()
        
        LLTask.Async.sub( waitSec: self.loopInterval.d / 1000.0 ) { [weak self] in
            guard let self = self else { return }
            
            let current_holded_id:Int = self._holded_id
            self._holded_id = -1  // reset id
            
            // -1 is force cancel.
            if current_holded_id == -1 { cancelled(); return }
            // not equal id is cancel.
            if current_holded_id != local_holded_id { cancelled(); return }
            // multi touch is cancel && guard non touches error.
            if touch_count != 1 { cancelled(); return }
            // check move all distance
            if self._hold_move_all > self.holdLimitMove { cancelled(); return }
            // small force is cancel hold using stylus.
            if touch.type == .stylus && touch.force < 0.125 { cancelled(); return }
            
            LLTask.Sync.main { [weak self] in
                guard let self = self else { return }
                succeeded()
                if self.loop {
                    self.loopHold(touches: touches, touchCount: touch_count, succeeded: succeeded, cancelled: cancelled )
                }
            }
        }
    }
    
    open func checkHold(
        touches:Set<UITouch>, 
        touchCount touch_count:Int, 
        cancelled:@escaping ()->()
    ) 
    {
        if touch_count != 1 { cancelled(); return }

        guard let touch = touches.first else { cancelled(); return }
        
        let pos = touch.location( in: nil )
        
        self._hold_move_all += pos.dist( _hold_prev_pos )
        self._hold_prev_pos = pos
        
        // append touches pool
        self._touch_pool.append( touch )
        
        // check move all distance
        if self._hold_move_all > self.holdLimitMove { cancelled(); return }
    }
    
    open func endHold() {
        _holded_id = -1
    }
    
    open func firePoolTouches( touchFunc:(Set<UITouch>)->Void ) {
        endHold()
        for touch in _touch_pool {
            let waiting_touches = Set<UITouch>( arrayLiteral: touch )
            touchFunc( waiting_touches )
        }
        _touch_pool.removeAll()
    }
}

#endif
