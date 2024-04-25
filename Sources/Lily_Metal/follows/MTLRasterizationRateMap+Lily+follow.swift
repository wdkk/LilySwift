//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

import Foundation
import Metal

// TODO: CatalystのバージョンでRasterizationRateMapが使えないのでInt代入で代用しておく
#if targetEnvironment(macCatalyst)
extension Lily.Metal
{
    public typealias RasterizationRateMap = Int
}
#else
extension Lily.Metal
{
    public typealias RasterizationRateMap = MTLRasterizationRateMap
}
#endif

#endif
