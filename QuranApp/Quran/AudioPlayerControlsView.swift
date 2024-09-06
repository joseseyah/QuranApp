import SwiftUI
import AVKit
import MediaPlayer

struct AudioPlayerControlsView: View {
    @Binding var currentTrackIndex: Int
    @Binding var isPlaying: Bool
    @Binding var audioPlayer: AVAudioPlayer?
    let tracks: [Surah]

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    previousTrack()
                }) {
                    Image(systemName: "backward.fill")
                        .font(.largeTitle)
                }

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
                    nextTrack()
                }) {
                    Image(systemName: "forward.fill")
                        .font(.largeTitle)
                }
            }
            .padding()
        }
    }

    private func nextTrack() {
        currentTrackIndex = (currentTrackIndex + 1) % tracks.count
        playCurrentTrack()
    }

    private func previousTrack() {
        currentTrackIndex = (currentTrackIndex - 1 + tracks.count) % tracks.count
        playCurrentTrack()
    }

    private func playCurrentTrack() {
        let surah = tracks[currentTrackIndex]
        if let audioAsset = NSDataAsset(name: surah.audioFileName) {
            do {
                audioPlayer = try AVAudioPlayer(data: audioAsset.data)
                audioPlayer?.delegate = AudioPlayerDelegate.shared // Set the delegate
                AudioPlayerDelegate.shared.onFinishPlaying = {
                    nextTrack()
                }
                audioPlayer?.play()
                isPlaying = true
                updateNowPlayingInfo()
            } catch {
                fatalError("Could not create audio player: \(error.localizedDescription)")
            }
        } else {
            fatalError("Audio file not found.")
        }
    }

    private func updateNowPlayingInfo() {
        guard let audioPlayer = audioPlayer else { return }
        let surah = tracks[currentTrackIndex]

        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = surah.name
        if let image = UIImage(named: surah.imageFileName) {
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioPlayer.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer.isPlaying ? 1.0 : 0.0

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
