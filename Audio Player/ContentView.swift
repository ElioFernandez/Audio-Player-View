//
//  ContentView.swift
//  Audio Player
//
//  Created by Elio Fernandez on 28/08/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModelAP = AudioPlayerViewModel(state: AudioPlayerState(showAudioPlayer: false))
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
            
            playButton
            
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
    
    var playButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                        viewModelAP.state.showAudioPlayer.toggle()
                    }
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
    }
}

#Preview {
    ContentView()
}
