import Foundation
import AVFoundation
import SwiftUI

// MARK: - States
struct AudioPlayerState: MVIViewState {
    var showAudioPlayer: Bool
    var isPlaying: States = .off
    var player: AVAudioPlayer?
    var progressTimePlayback: TimeInterval = 0
    var pausedTime: TimeInterval = 0
    var playbackStartTime: TimeInterval = 0
    var timerPlayback: Timer?
    var totalPlaybackDuration: TimeInterval = 0
    var currentTime: TimeInterval = 0
    var volume: Float = 0.5
}

enum States: String {
    case completed = "completed", on = "on", off = "off"
}

