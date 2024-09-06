import SwiftUI
import AVKit

struct TopPicksView: View {
    let surahs: [Surah]
    
    @Binding var selectedSurah: Surah?
    @Binding var isPlaying: Bool
    @Binding var audioPlayer: AVAudioPlayer?
    @Binding var currentTrackIndex: Int
    @Binding var showDetailView: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Picks")
                .font(.title2)
                .bold()
                .padding([.top, .leading])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(getTopPicks(), id: \.id) { surah in
                        Button(action: {
                            selectedSurah = surah
                            if let index = surahs.firstIndex(where: { $0.id == surah.id }) {
                                currentTrackIndex = index
                            }
                            prepareAudio(for: currentTrackIndex)
                            isPlaying = true
                        }) {
                            VStack {
                                Image(surah.imageFileName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .clipped()
                                    .cornerRadius(12)
                                
                                Text(surah.name)
                                    .font(.headline)
                                    .lineLimit(1)
                                    .padding(.top, 8)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    func getTopPicks() -> [Surah] {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let weekday = calendar.component(.weekday, from: now)
        
        var topPicks = [Surah]()
        
        if hour == 21 {
            if let surahMulk = surahs.first(where: { $0.name == "Al-Mulk" }) {
                topPicks.append(surahMulk)
            }
        }
        
        if weekday == 6 { // Friday
            if let surahKahf = surahs.first(where: { $0.name == "Al-Kahf" }) {
                topPicks.append(surahKahf)
            }
        }
        
        if topPicks.isEmpty {
            topPicks = Array(surahs.prefix(3)) // Default picks
        }
        
        return topPicks
    }
    
    private func prepareAudio(for index: Int) {
        let surah = surahs[index]
        if let audioAsset = NSDataAsset(name: surah.audioFileName) {
            do {
                audioPlayer = try AVAudioPlayer(data: audioAsset.data)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                fatalError("Could not create audio player: \(error.localizedDescription)")
            }
        } else {
            fatalError("Audio file not found.")
        }
    }
}

struct TopPicksView_Previews: PreviewProvider {
    static var previews: some View {
        TopPicksView(surahs: surahs, selectedSurah: .constant(nil), isPlaying: .constant(false), audioPlayer: .constant(nil), currentTrackIndex: .constant(0), showDetailView: .constant(false))
    }
}

