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

// MARK: - Private Actions
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
    
    func updateVolume(_ volume: Float) {
        state.volume = volume
        state.player?.volume = volume
    }
    
    func updateProgress(newValue: Float) {
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
}

// MARK: - Playback Helpers
private extension AudioPlayerViewModel {
    func playbackTimer() {
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
    
    func restartPlaybackTimer() {
        state.timerPlayback?.invalidate()
        playbackTimer()
    }
    
    func playbackComplete() {
        state.timerPlayback?.invalidate()
        state.isPlaying = .completed
        state.progressTimePlayback = state.totalPlaybackDuration
        closeAudioPlayer()
    }
    
    func resetPlayback() {
        state.progressTimePlayback = 0
        state.pausedTime = 0
    }
}

// MARK: - Network / Audio Initialization
private extension AudioPlayerViewModel {
    func downloadAndInitializePlayer(with urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            if let localURL = localURL {
                do {
                    let player = try AVAudioPlayer(contentsOf: localURL)
                    player.prepareToPlay()
                    let duration = player.duration
                    
                    DispatchQueue.main.sync {
                        self.state.player = player
                        self.state.totalPlaybackDuration = duration
                        self.playbackToggle()
                    }
                } catch {
                    print("Error initializing audio player: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Error downloading audio: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
