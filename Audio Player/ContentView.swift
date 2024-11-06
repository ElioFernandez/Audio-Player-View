//
//  ContentView.swift
//  Audio Player
//
//  Created by Elio Fernandez on 28/08/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModelAP = AudioPlayerViewModel(state: AudioPlayerState(showAudioPlayer: false)) // Delete after finishing testing
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        viewModelAP.state.showAudioPlayer.toggle()
                    } label: {
                        Image(systemName: "play.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .tint(.black)
                            .shadow(radius: 8)
                    }
                    .padding()
                }
            }
            
            if viewModelAP.state.showAudioPlayer {
                ZStack(alignment: .bottom) {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    AudioPlayerView(viewModel: viewModelAP)
                        .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
