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
import LilySwift

struct ContentView: View 
{
    var body: some View 
    {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    LLColor( "#44DDFF" ).swiftuiColor
                    
                    Image( "lily" )
                    .resizable()
                    .frame( width: geo.size.height / 3.0, height: geo.size.height / 3.0 )
                    
                    LilyPlaygroundView()
                }
                .ignoresSafeArea()
            }
            .toolbar {
                NavigationLink( "Go To Next", value:"Next" )
            }       
            .navigationDestination(for: String.self ) { value in
                if value == "Next" { NextView() }
            }
            .navigationTitle("LilyView")
        }
    }
}

#Preview {
    ContentView()
}
