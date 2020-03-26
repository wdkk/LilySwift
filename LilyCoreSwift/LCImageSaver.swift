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

public func LCImageSaverMake() -> LCImageSaverSmPtr {
    return LCImageSaverSmPtr()
}

public func LCImageSaverSave( _ saver_:LCImageSaverSmPtr, _ img_:LCImageSmPtr, _ file_path_:LCStringSmPtr ) -> Bool {
    return saver_.saver.save( img_, file_path_ )
}

public func LCImageSaverSaveWithOption( _ saver_:LCImageSaverSmPtr, _ img_:LCImageSmPtr, _ file_path_:LCStringSmPtr,
                                        _ option_:LLImageSaveOption ) -> Bool {
    return saver_.saver.save( img_, file_path_, option_ )
}
