//
//  MinimizedPlayerView.swift
//  Quran
//
//  Created by Joseph Hayes on 14/07/2024.
//

import SwiftUI
import AVKit

struct MinimizedPlayerView: View {
    @Binding var currentTrackIndex: Int
    @Binding var isPlaying: Bool
    @Binding var audioPlayer: AVAudioPlayer?

    var body: some View {
        HStack {
            Image(surahs[currentTrackIndex].imageFileName)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(8)

            Text(surahs[currentTrackIndex].name)
                .font(.headline)
                .lineLimit(1)
                .padding(.leading, 8)

            Spacer()

            Button(action: {
                if isPlaying {
                    audioPlayer?.pause()
                } else {
                    audioPlayer?.play()
                }
                isPlaying.toggle()
            }) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.title)
                    .padding()
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground).shadow(radius: 2))
        .onTapGesture {
            // Handle tap to show detailed view
            NotificationCenter.default.post(name: .showDetailView, object: nil)
        }
    }
}

extension Notification.Name {
    static let showDetailView = Notification.Name("showDetailView")
}

