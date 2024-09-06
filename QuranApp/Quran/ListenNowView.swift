import SwiftUI
import AVKit

struct ListenNowView: View {
    @Binding var selectedSurah: Surah?
    @Binding var isPlaying: Bool
    @Binding var audioPlayer: AVAudioPlayer?
    @State private var currentTrackIndex: Int = 0
    @State private var showDetailView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    TopPicksView(surahs: surahs, selectedSurah: $selectedSurah, isPlaying: $isPlaying, audioPlayer: $audioPlayer, currentTrackIndex: $currentTrackIndex, showDetailView: $showDetailView)
                    
                    ShortsView(surahs: surahs, selectedSurah: $selectedSurah, isPlaying: $isPlaying, audioPlayer: $audioPlayer, currentTrackIndex: $currentTrackIndex, showDetailView: $showDetailView)
                    
                    StoriesOfQuranView(selectedSurah: $selectedSurah, isPlaying: $isPlaying, audioPlayer: $audioPlayer, currentTrackIndex: $currentTrackIndex)
                    
                    Spacer()
                }
                
                if let surah = selectedSurah {
                    MinimizedAudioPlayerView(surah: surah, isPlaying: $isPlaying, audioPlayer: $audioPlayer, showDetailView: $showDetailView)
                        .padding()
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
}

struct ListenNowView_Previews: PreviewProvider {
    static var previews: some View {
        ListenNowView(selectedSurah: .constant(nil), isPlaying: .constant(false), audioPlayer: .constant(nil))
    }
}
