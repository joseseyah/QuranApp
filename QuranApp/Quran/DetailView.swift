import SwiftUI
import AVKit
import MediaPlayer

struct DetailView: View {
    @Binding var currentTrackIndex: Int
    @Binding var isPlaying: Bool
    @Binding var audioPlayer: AVAudioPlayer?

    @State private var currentTime: TimeInterval = 0.0
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Image(surahs[currentTrackIndex].imageFileName)
                .resizable()
                .frame(width: 300, height: 300)
                .cornerRadius(8)
                .padding()

            Text(surahs[currentTrackIndex].name)
                .font(.title)
                .padding()

            if let audioPlayer = audioPlayer {
                VStack {
                    Slider(value: $currentTime, in: 0...audioPlayer.duration) { isEditing in
                        if !isEditing {
                            audioPlayer.currentTime = currentTime
                        }
                    }
                    .padding()

                    Text(formatTime(currentTime))
                        .font(.caption)
                        .padding(.bottom, 20)

                    AudioPlayerControlsView(currentTrackIndex: $currentTrackIndex, isPlaying: $isPlaying, audioPlayer: $audioPlayer, tracks: surahs)
                }
            }
            Spacer()
        }
        .onAppear {
            updateNowPlayingInfo()
            setupRemoteTransportControls()
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
        .navigationTitle(surahs[currentTrackIndex].name)
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let audioPlayer = audioPlayer {
                currentTime = audioPlayer.currentTime
            }
        }
    }

    private func updateNowPlayingInfo() {
        guard let audioPlayer = audioPlayer else { return }
        let surah = surahs[currentTrackIndex]

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

    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { _ in
            if !self.isPlaying {
                self.audioPlayer?.play()
                self.isPlaying = true
                self.updateNowPlayingInfo()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { _ in
            if self.isPlaying {
                self.audioPlayer?.pause()
                self.isPlaying = false
                self.updateNowPlayingInfo()
                return .success
            }
            return .commandFailed
        }

        commandCenter.nextTrackCommand.addTarget { _ in
            self.nextTrack()
            return .success
        }

        commandCenter.previousTrackCommand.addTarget { _ in
            self.previousTrack()
            return .success
        }
    }

    private func nextTrack() {
        currentTrackIndex = (currentTrackIndex + 1) % surahs.count
        playCurrentTrack()
    }

    private func previousTrack() {
        currentTrackIndex = (currentTrackIndex - 1 + surahs.count) % surahs.count
        playCurrentTrack()
    }

    private func playCurrentTrack() {
        let surah = surahs[currentTrackIndex]
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
}
