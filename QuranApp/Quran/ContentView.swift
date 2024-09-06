import SwiftUI
import AVKit

struct ContentView: View {
    @State private var selectedSurah: Surah?
    @State private var isPlaying = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showDetailView = false

    var body: some View {
        NavigationView {
            ZStack {
                TabView {
                    ListenNowView(selectedSurah: $selectedSurah, isPlaying: $isPlaying, audioPlayer: $audioPlayer)
                        .tabItem {
                            Label("Listen Now", systemImage: "play.circle.fill")
                        }

                    BrowseView()
                        .tabItem {
                            Label("Browse", systemImage: "book.circle.fill")
                        }

                    SearchView()
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass.circle.fill")
                        }

                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                }

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
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
