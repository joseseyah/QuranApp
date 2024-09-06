import SwiftUI
import AVKit

struct MinimizedAudioPlayerView: View {
    let surah: Surah
    @Binding var isPlaying: Bool
    @Binding var audioPlayer: AVAudioPlayer?
    @Binding var showDetailView: Bool

    var body: some View {
        HStack {
            Image(surah.imageFileName)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(surah.name)
                    .font(.headline)
                Text(isPlaying ? "Playing" : "Paused")
                    .font(.subheadline)
            }

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
                    .font(.largeTitle)
            }

            Button(action: {
                showDetailView = true
            }) {
                Image(systemName: "chevron.up")
                    .font(.largeTitle)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 5)
        .onTapGesture {
            showDetailView = true
        }
    }
}
