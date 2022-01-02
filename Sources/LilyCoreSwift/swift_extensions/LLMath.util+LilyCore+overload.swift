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
import CoreGraphics

public func LLRandomf( _ v:LLDouble ) -> LLFloat { return LLRandomf( v.f ) }

public func LLRandomf( _ v:LLInt8 ) -> LLFloat { return LLRandomf( v.f ) }

public func LLRandomf( _ v:LLInt16 ) -> LLFloat { return LLRandomf( v.f ) }

public func LLRandomf( _ v:LLInt32 ) -> LLFloat { return LLRandomf( v.f ) }

public func LLRandomf( _ v:LLInt64 ) -> LLFloat { return LLRandomf( v.f ) }

public func LLRandomf( _ v:LLUInt8 ) -> LLFloat { return LLRandomf( v.f ) }

public func LLRandomf( _ v:LLUInt16 ) -> LLFloat { return LLRandomf( v.f ) }

public func LLRandomf( _ v:LLUInt32 ) -> LLFloat { return LLRandomf( v.f ) }

public func LLRandomf( _ v:LLUInt64 ) -> LLFloat { return LLRandomf( v.f ) }

public func LLRandomf( _ v:Int ) -> LLFloat { return LLRandomf( v.f ) }

public func LLRandomf( _ v:UInt ) -> LLFloat { return LLRandomf( v.f ) }

public func LLRandomf( _ v:CGFloat ) -> LLFloat { return LLRandomf( v.f ) }


public func LLRandomd( _ v:LLFloat ) -> LLDouble { return LLRandomd( v.d ) }

public func LLRandomd( _ v:LLInt8 ) -> LLDouble { return LLRandomd( v.d ) }

public func LLRandomd( _ v:LLInt16 ) -> LLDouble { return LLRandomd( v.d ) }

public func LLRandomd( _ v:LLInt32 ) -> LLDouble { return LLRandomd( v.d ) }

public func LLRandomd( _ v:LLInt64 ) -> LLDouble { return LLRandomd( v.d ) }

public func LLRandomd( _ v:LLUInt8 ) -> LLDouble { return LLRandomd( v.d ) }

public func LLRandomd( _ v:LLUInt16 ) -> LLDouble { return LLRandomd( v.d ) }

public func LLRandomd( _ v:LLUInt32 ) -> LLDouble { return LLRandomd( v.d ) }

public func LLRandomd( _ v:LLUInt64 ) -> LLDouble { return LLRandomd( v.d ) }

public func LLRandomd( _ v:Int ) -> LLDouble { return LLRandomd( v.d ) }

public func LLRandomd( _ v:UInt ) -> LLDouble { return LLRandomd( v.d ) }

public func LLRandomd( _ v:CGFloat ) -> LLDouble { return LLRandomd( v.d ) }


public func LLRandomi( _ v:LLInt8 ) -> LLInt32 {
    return LLRandomi( v.i32 )
}

public func LLRandomi( _ v:LLInt16 ) -> LLInt32 {
    return LLRandomi( v.i32 )
}

public func LLRandomi( _ v:LLInt64 ) -> LLInt32 {
    guard let i32 = v.i32 else { return 0 }
    return LLRandomi( i32 )
}

public func LLRandomi( _ v:LLUInt8 ) -> LLInt32 {
    return LLRandomi( v.i32 )
}

public func LLRandomi( _ v:LLUInt16 ) -> LLInt32 {
    return LLRandomi( v.i32 )
}

public func LLRandomi( _ v:LLUInt32 ) -> LLInt32 {
    guard let i32 = v.i32 else { return 0 }
    return LLRandomi( i32 )
}

public func LLRandomi( _ v:LLUInt64 ) -> LLInt32 {
    guard let i32 = v.i32 else { return 0 }
    return LLRandomi( i32 )
}

public func LLRandomi( _ v:Int ) -> LLInt32 {
    guard let i32 = v.i32 else { return 0 }
    return LLRandomi( i32 )
}

public func LLRandomi( _ v:UInt ) -> LLInt32 {
    guard let i32 = v.i32 else { return 0 }
    return LLRandomi( i32 )
}

public func LLRandomi( _ v:LLFloat ) -> LLInt32 {
    guard let i32 = v.i32 else { return 0 }
    return LLRandomi( i32 )
}

public func LLRandomi( _ v:LLDouble ) -> LLInt32 {
    guard let i32 = v.i32 else { return 0 }
    return LLRandomi( i32 )
}

public func LLRandomi( _ v:CGFloat ) -> LLInt32 {
    guard let i32 = v.i32 else { return 0 }
    return LLRandomi( i32 )
}



public func LLRandomu( _ v:LLInt8 ) -> LLUInt32 {
    guard let u32 = v.u32 else { return 0 }
    return LLRandomu( u32 )
}

public func LLRandomu( _ v:LLInt16 ) -> LLUInt32 {
    guard let u32 = v.u32 else { return 0 }
    return LLRandomu( u32 )
}

public func LLRandomu( _ v:LLInt32 ) -> LLUInt32 {
    guard let u32 = v.u32 else { return 0 }
    return LLRandomu( u32 )
}

public func LLRandomu( _ v:LLInt64 ) -> LLUInt32 {
    guard let u32 = v.u32 else { return 0 }
    return LLRandomu( u32 )
}

public func LLRandomu( _ v:LLUInt8 ) -> LLUInt32 {
    return LLRandomu( v.u32 )
}

public func LLRandomu( _ v:LLUInt16 ) -> LLUInt32 {
    return LLRandomu( v.u32 )
}

public func LLRandomu( _ v:LLUInt64 ) -> LLUInt32 {
    guard let u32 = v.u32 else { return 0 }
    return LLRandomu( u32 )
}

public func LLRandomu( _ v:Int ) -> LLUInt32 {
    guard let u32 = v.u32 else { return 0 }
    return LLRandomu( u32 )
}

public func LLRandomu( _ v:UInt ) -> LLUInt32 {
    guard let u32 = v.u32 else { return 0 }
    return LLRandomu( u32 )
}

public func LLRandomu( _ v:LLFloat ) -> LLUInt32 {
    guard let u32 = v.u32 else { return 0 }
    return LLRandomu( u32 )
}

public func LLRandomu( _ v:LLDouble ) -> LLUInt32 {
    guard let u32 = v.u32 else { return 0 }
    return LLRandomu( u32 )
}

public func LLRandomu( _ v:CGFloat ) -> LLUInt32 {
    guard let u32 = v.u32 else { return 0 }
    return LLRandomu( u32 )
}
