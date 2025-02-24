//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public func LCImageLoaderMake() -> LCImageLoaderSmPtr {
    return LCImageLoaderSmPtr()
}

public func LCImageLoaderLoad( _ loader_:LCImageLoaderSmPtr, _ file_path_:String ) 
async
-> LCImageSmPtr 
{
    return await loader_.loader.load( file_path_ )
}

public func LCImageLoaderLoadWithOption( 
    _ loader_:LCImageLoaderSmPtr,
    _ file_path_:String,
    _ option_:LLImageLoadOption
)
async -> LCImageSmPtr {
    return await loader_.loader.load( file_path_, option_ )
}
