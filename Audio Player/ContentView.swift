//
//  ContentView.swift
//  Audio Player
//
//  Created by Elio Fernandez on 28/08/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = AudioPlayerViewModel(state: AudioPlayerState(showAudioPlayer: false))
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
            }
            .padding()
            
            playButton
            
            if viewModel.state.showAudioPlayer {
                ZStack(alignment: .bottom) {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    AudioPlayerView(viewModel: viewModel)
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
                        viewModel.state.showAudioPlayer.toggle()
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
