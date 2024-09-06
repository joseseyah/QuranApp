import SwiftUI
import AVKit

struct BrowseView: View {
    @State private var selectedSurah: Surah?
    @State private var isPlaying = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var currentTrackIndex: Int = 0
    @State private var showDetailView = false

    var body: some View {
        NavigationView {
            ZStack {
                List(surahs, id: \.name) { surah in
                    Button(action: {
                        // Stop current player if playing
                        if let audioPlayer = audioPlayer {
                            audioPlayer.stop()
                            self.audioPlayer = nil
                            self.isPlaying = false
                        }
                        
                        selectedSurah = surah
                        if let index = surahs.firstIndex(where: { $0.id == surah.id }) {
                            currentTrackIndex = index
                        }
                        showDetailView = true
                        prepareAudio(for: currentTrackIndex)
                    }) {
                        HStack {
                            Image(surah.imageFileName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                            Text(surah.name)
                                .font(.headline)
                        }
                    }
                }
                .navigationTitle("Browse")

                VStack {
                    Spacer()
                    if let surah = selectedSurah {
                        MinimizedAudioPlayerView(surah: surah, isPlaying: $isPlaying, audioPlayer: $audioPlayer, showDetailView: $showDetailView)
                            .padding()
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .background(
                NavigationLink(destination: DetailView(currentTrackIndex: $currentTrackIndex, isPlaying: $isPlaying, audioPlayer: $audioPlayer), isActive: $showDetailView) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }

    private func prepareAudio(for index: Int) {
        let surah = surahs[index]
        if let audioAsset = NSDataAsset(name: surah.audioFileName) {
            do {
                audioPlayer = try AVAudioPlayer(data: audioAsset.data)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                isPlaying = true
            } catch {
                fatalError("Could not create audio player: \(error.localizedDescription)")
            }
        } else {
            fatalError("Audio file not found.")
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}

