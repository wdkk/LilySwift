//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import SwiftUI

struct ContentView: View 
{
    var body: some View 
    {
        GeometryReader { geo in
            ZStack {
                Color.orange
                
                Image( "lily" )
                .resizable()
                .frame( width: geo.size.height / 3.0, height: geo.size.height / 3.0 )
                
                LilyPlaygroundView()
            }
        }
    }
}

#Preview {
    ContentView()
}
