//
//  ContentView.swift
//  DevSwiftUI
//
//  Created by Kengo Watanabe on 2024/02/10.
//

import SwiftUI

struct ContentView: View 
{
    var body: some View 
    {
        NavigationStack {
            LilyPlaygroundView()
            .ignoresSafeArea()
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
    }
}

#Preview {
    ContentView()
}
