//
//  ContentView.swift
//  DevSwiftUI
//
//  Created by Kengo Watanabe on 2024/02/10.
//

import SwiftUI

struct ContentView: View 
{
    @State private var updated = false
    var body: some View 
    {
        NavigationStack {
            LilyPlaygroundView( updating:$updated )
            .ignoresSafeArea()
            .toolbar {
                NavigationLink( "Go To Next", value:"Next" )
            }       
            .navigationDestination(for: String.self ) { value in
                if value == "Next" {
                    NextView()
                    .onDisappear {
                        updated.toggle()
                    }
                }
            }
            .navigationTitle("LilyView")
            .onChange( of:updated ) { oldValue, newValue in
                print( "ホゲー" )
            }
        }
    }
}

#Preview {
    ContentView()
}
