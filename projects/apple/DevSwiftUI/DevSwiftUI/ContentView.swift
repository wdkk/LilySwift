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
        NavigationStack {
            ZStack {
                Color.yellow
                
                LilyPlaygroundView()                    
                .toolbar {
                    NavigationLink( "Go To Next", value:"Next" )
                }       
                .navigationDestination(for: String.self ) { value in
                    if value == "Next" {
                        NextView()
                    }
                }
                .navigationTitle("LilyView")
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
