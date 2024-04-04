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
import LilySwiftAlias

struct ContentView: View 
{
    #if os(visionOS)
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    #endif
    
    @StateObject var scenePack:ScenePack = .init()
      
    var body: some View 
    {
        NavigationStack {
            #if os(visionOS)
            Toggle( "イマーシブ空間を開く", isOn:$showImmersiveSpace )
            .toggleStyle( .button )
            .padding()
            #endif
            
            GeometryReader { geo in
                ZStack {
                    /*
                    LLColor( "#44DDFF" ).swiftuiColor
                    
                    Image( "lily" )
                    .resizable()
                    .frame( width: geo.size.height / 3.0, height: geo.size.height / 3.0 )
                    */
                    
                    PGScreenView(
                        device:scenePack.device,
                        environment:.metallib,
                        scene:$scenePack.scene
                    )
                }
                .ignoresSafeArea()
            }
            .toolbar {
                NavigationLink( "Go To Next", value:"Next" )
            }       
            .navigationDestination(for: String.self ) { value in
                if value == "Next" { NextView() }
            }
            .navigationTitle( "LilyView" )
            .onTapGesture {
                scenePack.scene.design = scenePack.design2
                scenePack.scene.update = scenePack.update2
            }
        }
        #if os(visionOS)
        .onChange( of:showImmersiveSpace ) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace( id:"LilyImmersiveSpace" ) {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } 
                else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
        }
        #endif
    }
}

#Preview {
    ContentView()
}
