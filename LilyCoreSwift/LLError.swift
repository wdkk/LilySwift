//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

fileprivate struct LLErrorInternal
{
    var code:Int = 0
    var description:String = ""
}

public class LLErrorSmPtr
{
    fileprivate var e:LLErrorInternal
    
    fileprivate init() {
        e = LLErrorInternal()
    }
}

func LLErrorMake() -> LLErrorSmPtr {
    let err = LLErrorSmPtr()
    err.e.code = 0
    err.e.description = ""
    return err
}

func LLErrorNone( _ err:LLErrorSmPtr ) {
    err.e.code = 0
    err.e.description = ""
}

func LLErrorSet( _ err:LLErrorSmPtr, _ code:Int, _ description:LLConstCCharsPtr ) {
    err.e.code = code
    err.e.description = String( cString: description )
}

func LLErrorCode( _ err:LLErrorSmPtr ) -> Int {
    return err.e.code
}

func LLErrorDescription( _ err:LLErrorSmPtr ) -> LCStringSmPtr {
    return err.e.description.lcStr
}
