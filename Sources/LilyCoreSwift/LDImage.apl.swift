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

public func LDImageLoadFileWithOption( _ file_path_:LCStringSmPtr, _ option_:LLImageLoadOption ) -> LCImageSmPtr {
    if !LCFileExists( file_path_ )  {
        LLLogWarning( "ファイルが見つかりません.:\(String( file_path_ ))" )
        return LCImageZero()
    }
    
    var opt:LLImageLoadOption = option_
    
    let splits:LCStringArraySmPtr = LCStringSplit( file_path_, LCStringMakeWithCChars( "." ) )
    let split_count:Int = LCStringArrayCount( splits )
    
    if split_count <= 1 { return LCImageZero() }
    
    // extract extension
    let ext:LCStringSmPtr = LCStringArrayAt( splits, split_count-1 )
    // join path without extension
    let path_without_ext:LCStringSmPtr = LCStringArrayAt( splits, 0 )
    for i:Int in 1 ..< split_count-1 {
        LCStringAppend( path_without_ext, LCStringMakeWithCChars( "." ) )
        LCStringAppend( path_without_ext, LCStringArrayAt( splits, i ) )
    }
    
    // Retina
    var scale:LLDouble = LCSystemGetRetinaScale()
    var new_path:LCStringSmPtr = LCStringZero()
    
    // @3x
    if scale > 2.0 {
        let path:LCStringSmPtr = LCStringJoin( LCStringJoin( path_without_ext, LCStringMakeWithCChars( "@3x." ) ), ext )
        if LCFileExists( path ) { new_path = LCStringMake( path ) }
        scale = 3.0
    }
    
    // @2x
    if scale > 1.0 && LCStringIsEmpty( new_path ) {
        let path:LCStringSmPtr = LCStringJoin( LCStringJoin( path_without_ext, LCStringMakeWithCChars( "@2x." ) ), ext )
        if LCFileExists( path ) { new_path = LCStringMake( path ) }
        scale = 2.0
    }
    
    // default
    if LCStringIsEmpty( new_path ) {
        let path:LCStringSmPtr = LCStringJoin( LCStringJoin( path_without_ext, LCStringMakeWithCChars( "." ) ), ext )
        if LCFileExists( path ) { new_path = LCStringMake( path ) }
        scale = 1.0
    }

    if opt.type == .auto {
        opt.type = LCImageCheckLoadTypeByExtension( opt, ext )
    }
    
    let loader:LCImageLoaderSmPtr = LCImageLoaderMake()
    let result:LCImageSmPtr = LCImageLoaderLoadWithOption( loader, new_path, opt )
    if LCImageGetType( result ) != .none { LCImageChangeScale( result, scale.f ) }
    return result
}


public func LDImageSaveFileWithOption( _ img_:LCImageSmPtr, _ file_path_:LCStringSmPtr, _ option_:LLImageSaveOption ) 
-> Bool {
    if LCFileExists( file_path_ ) {
         LLLogWarning( "すでにファイルが存在します.:\(String( file_path_ ))" );
         return false
     }
    
    let ext:LCStringSmPtr = LCPathPickExtension( file_path_ )    
    var opt:LLImageSaveOption = option_

    if opt.type == .auto {
        opt.type = LCImageCheckSaveTypeByExtension( opt, ext )
    }
    
    let saver:LCImageSaverSmPtr = LCImageSaverMake()
    return LCImageSaverSaveWithOption( saver, img_, file_path_, opt )
}
