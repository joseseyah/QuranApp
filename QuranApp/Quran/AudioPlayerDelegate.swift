//
//  AudioPlayerDelegate.swift
//  Quran
//
//  Created by Joseph Hayes on 14/07/2024.
//

import AVFoundation

class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioPlayerDelegate()
    var onFinishPlaying: (() -> Void)?

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onFinishPlaying?()
    }
}


