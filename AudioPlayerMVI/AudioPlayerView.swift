import SwiftUI
import Combine

struct AudioPlayerView: MVIBaseView {
    @ObservedObject var viewModel: AudioPlayerViewModel
    @State private var value = 0.0
    @State private var volume = 1.0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 4) {
                Image("indie-rock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 74, height: 74)
                    .cornerRadius(6)
                    .foregroundStyle(.gray.opacity(0.5))
                    
                VStack {
                    HStack {
                        Text("iPhone")
                            .font(.system(size: 14, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.gray.opacity(0.5))
                        Spacer()
                    }
                    Text("Degmesin Ellerimiz Model - Diger Masa")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .padding(.vertical, 1)
                }
                .padding(.horizontal)
            }
            .frame(height: 72)
            .padding(36)
            
            Divider()
                .foregroundStyle(.white)
                
            Spacer()
            VStack(spacing: 0) {
                Slider(value: Binding(
                    get: { Double(viewModel.state.progressTimePlayback / viewModel.state.totalPlaybackDuration) },
                    set: { newValue in viewModel.intentHandler(.didTapProgressSlider(Float(newValue))) }
                ))
                .tint(.pink.opacity(0.4))
                                
                HStack {
                    Text(String(format: "%02d:%02d", Int(viewModel.state.progressTimePlayback) / 60, Int(viewModel.state.progressTimePlayback) % 60))
                        .font(.custom("Montserrat-Regular", size: 13))
                        .foregroundStyle(.gray.opacity(0.5))
                    Spacer()
                    Text(String(format: "%02d:%02d", Int(viewModel.state.totalPlaybackDuration) / 60, Int(viewModel.state.totalPlaybackDuration) % 60))
                        .font(.custom("Montserrat-Regular", size: 13))
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
            .padding(.horizontal, 36)
            
            Spacer()
            HStack(spacing: 56) {
                Button {
                    viewModel.intentHandler(.didTapBackward)
                } label: {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 50)
                        .foregroundStyle(.white)
                }
                
                Button {
                    viewModel.intentHandler(.didTapPlay)
                } label: {
                    Image(systemName: viewModel.state.isPlaying == .on ? "pause.fill" : "play.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 50)
                        .foregroundStyle(.white)
                }
                
                Button {
                    viewModel.intentHandler(.didTapForward)
                } label: {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 50)
                        .foregroundStyle(.white)
                }
            }
            .frame(height: 50)
            .padding(.horizontal, 48)
            
            Spacer()
            HStack {
                Image(systemName: "speaker.wave.1.fill")
                    .foregroundStyle(.gray)
                    .font(.system(size: 24))
                Slider(value: Binding(
                    get: { Double(viewModel.state.volume) },
                    set: { newValue in
                        viewModel.intentHandler(.didTapVolumeSlider(Float(newValue))) }
                ), in: 0...1)
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundStyle(.gray)
                    .font(.system(size: 24))
            }
            .tint(.white)
            .padding(.vertical, 24)
            .padding(.horizontal, 36)
            
        }
        .frame(maxWidth: .infinity, maxHeight: 420)
        .background(.black)
        .cornerRadius(32)
        .padding(.horizontal, 10)
        .overlay(alignment: .topTrailing) {
            Button {
                    viewModel.intentHandler(.didTapClose)
            } label: {
                HStack {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .foregroundStyle(.gray.opacity(0.5))
                }
                .padding()
                .padding(.trailing)
            }
        }
    }
    
}


#Preview {
    AudioPlayerView(viewModel: .init(state: .init(showAudioPlayer: true)))
}

//import SwiftUI
//import Combine
//
//struct AudioPlayerView: MVIBaseView {
//    @ObservedObject var viewModel: AudioPlayerViewModel
//    @State private var value = 0.0
//    @State private var volume = 1.0
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            closeButton
//            infoView
//            playbackProgressView
//            playbackControlsView
//            volumeControlView
//        }
//        .frame(maxWidth: .infinity, maxHeight: 360)
//        .background(.white)
//        .cornerRadius(24)
//        .padding(.horizontal, 10)
//    }
//    
//    var closeButton: some View {
//        Button {
//                viewModel.intentHandler(.didTapClose)
//        } label: {
//            Text("Close audio")
//                .font(.subheadline)
//                .foregroundStyle(.blue)
//                .padding(.bottom, 24)
//        }
//    }
//    
//    var infoView: some View {
//        HStack(spacing: 4) {
//            Text("1")
//                .font(.custom("Montserrat-Regular", size: 70))
//                .frame(width: 48, height: 72)
//                .foregroundStyle(.customGray)
//                
//            VStack {
//                Text("Plaça Reial (Royal Square)")
//                    .font(.custom("Montserrat-Regular", size: 17))
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .foregroundStyle(.customPink)
//                    .lineLimit(2)
//                Spacer()
//            }
//        }
//        .frame(height: 56)
//        .padding(.horizontal, 10)
//    }
//    
//    var playbackProgressView: some View {
//        VStack(spacing: 0) {
//            Slider(value: Binding(
//                get: { Double(viewModel.state.progressTimePlayback / viewModel.state.totalPlaybackDuration) },
//                set: { newValue in viewModel.intentHandler(.didTapProgressSlider(Float(newValue))) }
//            ))
//            .tint(.customPink)
//            HStack {
//                Text(String(format: "%02d:%02d", Int(viewModel.state.progressTimePlayback) / 60, Int(viewModel.state.progressTimePlayback) % 60))
//                    .font(.custom("Montserrat-Regular", size: 13))
//                    .foregroundStyle(.customGray)
//                Spacer()
//                Text(String(format: "%02d:%02d", Int(viewModel.state.totalPlaybackDuration) / 60, Int(viewModel.state.totalPlaybackDuration) % 60))
//                    .font(.custom("Montserrat-Regular", size: 13))
//                    .foregroundStyle(.customGray)
//            }
//        }
//        .padding(.horizontal, 36)
//        .padding(.vertical, 24)
//    }
//    
//    var playbackControlsView: some View {
//        HStack(spacing: 48) {
//            PlaybackControlButton(imageName: "backward") {
//                viewModel.intentHandler(.didTapBackward)
//            }
//            
//            PlaybackControlButton(imageName: viewModel.state.isPlaying == .on ? "pause" : "play") {
//                viewModel.intentHandler(.didTapPlay)
//            }
//            
//            PlaybackControlButton(imageName: "forward") {
//                viewModel.intentHandler(.didTapForward)
//            }
//        }
//        .frame(height: 50)
//        .padding(.horizontal, 48)
//    }
//    
//    var volumeControlView: some View {
//        Slider(value: Binding(
//            get: { Double(viewModel.state.volume) },
//            set: { newValue in viewModel.intentHandler(.didTapVolumeSlider(Float(newValue))) }
//        ), in: 0...1, minimumValueLabel: Image("silence"), maximumValueLabel: Image("maxAudio")) {
//            EmptyView()
//        }
//        .tint(.customPink)
//        .padding(.vertical, 24)
//        .padding(.horizontal, 36)
//    }
//}
//
//
//#Preview {
//    AudioPlayerView(viewModel: .init(state: .init(showAudioPlayer: true)))
//}
//
//struct PlaybackControlButton: View {
//    let imageName: String
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            Image(imageName)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 40, height: 50)
//        }
//    }
//}
//
