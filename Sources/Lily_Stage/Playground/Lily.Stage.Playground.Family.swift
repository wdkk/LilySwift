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

import Metal

extension Lily.Stage
{
    open class Playground
    {
        open class Shared { }
        
        open class Plane { }
 
        open class Billboard { }
        
        open class Model { 
            open class Mesh { }
            open class Lighting { }
        }
        
        open class sRGB { }
    }
}

#endif
