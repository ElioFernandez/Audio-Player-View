import Foundation

// MARK: - Intents
enum AudioPlayerIntent: MVIIntent {
    case didTapClose
    case didTapPlay
    case didTapProgressSlider(Float)
    case didTapVolumeSlider(Float)
    case didTapBackward
    case didTapForward
}
