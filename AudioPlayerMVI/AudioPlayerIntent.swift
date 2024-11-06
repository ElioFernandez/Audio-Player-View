import Foundation

enum AudioPlayerIntent: MVIIntent {
    case didTapClose
    case didTapPlay
    case didTapProgressSlider(Float)
    case didTapVolumeSlider(Float)
    case didTapBackward
    case didTapForward
}

