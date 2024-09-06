import SwiftUI
import AVKit

struct ShortsView: View {
    let surahs: [Surah]
    
    @Binding var selectedSurah: Surah?
    @Binding var isPlaying: Bool
    @Binding var audioPlayer: AVAudioPlayer?
    @Binding var currentTrackIndex: Int
    @Binding var showDetailView: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Shorts")
                .font(.title2)
                .bold()
                .padding([.top, .leading])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(surahs, id: \.id) { surah in
                        Button(action: {
                            selectedSurah = surah
                            if let index = surahs.firstIndex(where: { $0.id == surah.id }) {
                                currentTrackIndex = index
                            }
                            showDetailView = true
                            prepareAudio(for: currentTrackIndex)
                        }) {
                            VStack {
                                Image(surah.imageFileName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(12)
                                
                                Text(surah.name)
                                    .font(.caption)
                                    .lineLimit(1)
                                    .padding(.top, 4)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showDetailView) {
            if let surah = selectedSurah {
                DetailView(currentTrackIndex: $currentTrackIndex, isPlaying: $isPlaying, audioPlayer: $audioPlayer)
                    .onAppear {
                        prepareAudio(for: currentTrackIndex)
                    }
            }
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

struct ShortsView_Previews: PreviewProvider {
    static var previews: some View {
        ShortsView(surahs: surahs, selectedSurah: .constant(nil), isPlaying: .constant(false), audioPlayer: .constant(nil), currentTrackIndex: .constant(0), showDetailView: .constant(false))
    }
}
