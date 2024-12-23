import SwiftUI
import Combine

struct AudioPlayerView: MVIBaseView {
    @ObservedObject var viewModel: AudioPlayerViewModel
    let semiTransparentGray = Color.gray.opacity(0.5)
    
    var body: some View {
        VStack(spacing: 0) {
            infoTrackView
            separatorView
            progressPlayView
            Spacer()
            controlButtonsView
            Spacer()
            sliderVolumeView
        }
        .frame(maxWidth: .infinity, maxHeight: 420)
        .background(.black)
        .cornerRadius(32)
        .padding(.horizontal, 10)
        .overlay(alignment: .topTrailing) {
            closeButtonView
        }
    }

    // MARK: - Subviews
    var infoTrackView: some View {
        HStack(alignment: .top, spacing: 16) {
            albumCoverView
            titleSongView
            
        }
        .padding(.horizontal, 36)
        .padding(.vertical, 24)
    }
    
    var albumCoverView: some View {
        Image("indie-rock")
            .resizable()
            .scaledToFit()
            .frame(width: 74, height: 74)
            .cornerRadius(6)
            .foregroundStyle(semiTransparentGray)
    }
    
    var titleSongView: some View {
        VStack (spacing: 4) {
            Text("iPhone")
                .font(.system(size: 12, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(semiTransparentGray)
            Text("Degmesin Ellerimiz - Diger Masa")
                .font(.system(size: 16, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 54, alignment: .bottom)
                .foregroundStyle(.white)
                .lineLimit(2)
        }
    }
    
    var separatorView: some View {
        Divider()
            .background(semiTransparentGray)
    }
    
    var sliderTimePlayView: some View {
        Slider(value: Binding(
            get: { Double(viewModel.state.progressTimePlayback / viewModel.state.totalPlaybackDuration) },
            set: { newValue in viewModel.intentHandler(.didTapProgressSlider(Float(newValue))) }
        ))
        .tint(.white)
        .padding(.top, 16)
    }
    
    var timerView: some View {
        HStack {
            Text(String(format: "%02d:%02d", Int(viewModel.state.progressTimePlayback) / 60, Int(viewModel.state.progressTimePlayback) % 60))
                .font(.custom("Montserrat-Regular", size: 13))
                .foregroundStyle(semiTransparentGray)
            Spacer()
            Text(String(format: "%02d:%02d", Int(viewModel.state.totalPlaybackDuration) / 60, Int(viewModel.state.totalPlaybackDuration) % 60))
                .font(.custom("Montserrat-Regular", size: 13))
                .foregroundStyle(semiTransparentGray)
        }
    }
    
    var progressPlayView: some View {
        VStack(spacing: 0) {
            sliderTimePlayView
            timerView
        }
        .padding(.horizontal, 36)
    }
    
    var controlButtonsView: some View {
        HStack(spacing: 56) {
            controlButton(imageName: "backward.fill") {
                viewModel.intentHandler(.didTapBackward)
            }
            
            controlButton(imageName: viewModel.state.isPlaying == .on ? "pause.fill" : "play.fill") {
                viewModel.intentHandler(.didTapPlay)
            }
            
            controlButton(imageName: "forward.fill") {
                viewModel.intentHandler(.didTapForward)
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 48)
    }
    
    var sliderVolumeView: some View {
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
    
    var closeButtonView: some View {
        Button {
            viewModel.intentHandler(.didTapClose)
        } label: {
            HStack {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundStyle(semiTransparentGray)
            }
            .padding(EdgeInsets(.init(top: 24, leading: 0, bottom: 0, trailing: 42)))
        }
    }
    
    // MARK: - Action
    func controlButton(imageName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 50)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    AudioPlayerView(viewModel: .init(state: .init(showAudioPlayer: true)))
}

