//
//  SearchView.swift
//  Quran
//
//  Created by Joseph Hayes on 12/07/2024.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    
    var filteredSurahs: [Surah] {
        if searchText.isEmpty {
            return surahs
        } else {
            return surahs.filter { $0.name.contains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            List(filteredSurahs, id: \.name) { surah in
                HStack {
                    Image(surah.imageFileName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                    Text(surah.name)
                        .font(.headline)
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

