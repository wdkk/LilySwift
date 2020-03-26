//
// Lily Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public func LCImageLoaderMake() -> LCImageLoaderSmPtr {
    return LCImageLoaderSmPtr()
}

public func LCImageLoaderLoad( _ loader_:LCImageLoaderSmPtr, _ file_path_:LCStringSmPtr ) -> LCImageSmPtr {
    return loader_.loader.load( file_path_ )
}

public func LCImageLoaderLoadWithOption( _ loader_:LCImageLoaderSmPtr, _ file_path_:LCStringSmPtr,
                                         _ option_:LLImageLoadOption ) -> LCImageSmPtr {
    return loader_.loader.load( file_path_, option_ )
}
