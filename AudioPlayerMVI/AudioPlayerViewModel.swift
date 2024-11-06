import AVFoundation
import SwiftUI

class AudioPlayerViewModel: MVIBaseViewModel {
    @Published var state: AudioPlayerState
    
    init(state: AudioPlayerState) {
        self.state = state
    }
        
    func intentHandler(_ intent: AudioPlayerIntent) {
        switch intent {
        case .didTapClose:
            closeAudioPlayer()
        case .didTapPlay:
            playbackToggle()
        case .didTapProgressSlider(let newValue):
            updateProgress(newValue: newValue)
        case .didTapVolumeSlider(let volume):
            updateVolume(volume)
        case .didTapBackward:
            backwardPlayback()
        case .didTapForward:
            forwardPlayback()
        }
    }
    
}

private extension AudioPlayerViewModel {
    
    func closeAudioPlayer() {
        state.player?.stop()
        state.isPlaying = .off
        state.player?.currentTime = 0
        state.progressTimePlayback = 0
        state.timerPlayback?.invalidate()
        state.timerPlayback = nil
        state.showAudioPlayer.toggle()
    }
    
    func playbackToggle() {
        if state.isPlaying == .off {
            if state.player == nil {
                downloadAndInitializePlayer(with: "https://www.soundjay.com/free-music/sounds/midnight-ride-01a.mp3")
            } else {
                state.player?.play()
                state.isPlaying = .on
                playbackTimer()
            }
        } else if state.isPlaying == .on {
            state.player?.pause()
            state.isPlaying = .off
            state.timerPlayback?.invalidate()
        } else {
            state.player?.stop()
            resetPlayback()
            state.isPlaying = .on
            state.player?.play()
            playbackTimer()
        }
        
    }
    
    func resetPlayback() {
        state.progressTimePlayback = 0
        state.pausedTime = 0
    }
    
    private func updateProgress(newValue: Float) {
        guard state.showAudioPlayer else { return }
        
        state.timerPlayback?.invalidate()
        
        let newTime = Double(newValue) * state.totalPlaybackDuration
        let clampedTime = min(max(newTime, 0), state.totalPlaybackDuration)
        
        state.player?.currentTime = clampedTime
        state.progressTimePlayback = clampedTime
        state.player?.prepareToPlay()
        
        if state.isPlaying == .on {
            state.player?.play()
        }
        
        restartPlaybackTimer()
    }
    
    func updateVolume(_ volume: Float) {
        state.volume = volume
        state.player?.volume = volume
    }
    
    func backwardPlayback() {
        let newTime = state.progressTimePlayback - 5.0
        if newTime > 0 {
            state.progressTimePlayback = newTime
            state.player?.currentTime = newTime
        } else {
            state.progressTimePlayback = 0
            state.player?.currentTime = 0
        }
        restartPlaybackTimer()
    }
    
    func forwardPlayback() {
        let newTime = state.progressTimePlayback + 5.0
        if newTime < state.totalPlaybackDuration {
            state.progressTimePlayback = newTime
            state.player?.currentTime = newTime
        } else {
            state.progressTimePlayback = state.totalPlaybackDuration
            state.player?.currentTime = state.totalPlaybackDuration
            playbackComplete()
        }
        restartPlaybackTimer()
    }
    
    private func restartPlaybackTimer() {
        state.timerPlayback?.invalidate()
        playbackTimer()
    }
    
    private func playbackTimer() {
        if state.isPlaying == .on {
            if state.pausedTime > 0 {
                state.playbackStartTime = Date.timeIntervalSinceReferenceDate - state.pausedTime
            } else {
                state.playbackStartTime = Date.timeIntervalSinceReferenceDate - state.progressTimePlayback
            }
            
            state.timerPlayback = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [self] _ in
                state.progressTimePlayback = Date.timeIntervalSinceReferenceDate - state.playbackStartTime
                
                if state.progressTimePlayback >= state.totalPlaybackDuration {
                    playbackComplete()
                }
            })
        } else {
            state.timerPlayback?.invalidate()
            state.pausedTime = state.progressTimePlayback
        }
    }
    
    private func playbackComplete() {
        state.timerPlayback?.invalidate()
        state.isPlaying = .completed
        state.progressTimePlayback = state.totalPlaybackDuration
        closeAudioPlayer()
    }
    
    func downloadAndInitializePlayer(with urlString: String) {
        guard let url = URL(string: urlString) else {
            print("URL no válida")
            return
        }
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            if let localURL = localURL {
                do {
                    self.state.player = try AVAudioPlayer(contentsOf: localURL)
                    self.state.player?.prepareToPlay()
                    self.state.totalPlaybackDuration = self.state.player?.duration ?? 0.0
                    DispatchQueue.main.async {
                        self.playbackToggle()
                    }
                } catch {
                    print("Error al inicializar el reproductor de audio: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Error al descargar el audio: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}

