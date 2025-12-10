//
//  HomeView.swift
//  MusicPlayer
//
//  Created by Theik Chan on 12/10/25.
//  Copyright © 2025 Theik Chan. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @State private var viewModel: HomeViewModel = .init()
    @State private var isPlaySong: Bool = false
    
    @State var playSong: SongItem?
    
    var body: some View {
        VStack {
            List(viewModel.songs) { song in
                SongItemView(song: song)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        self.playSong = song
                        self.isPlaySong = true
                    }
            }
        }
        .sheet(isPresented: $isPlaySong, content: {
            MusicPlayerView(song: self.playSong)
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium, .large])
        })
        .onAppear {
            Task {
                await viewModel.getSongs()
            }
        }.navigationTitle(Text("Song Library"))
    }
}

#Preview {
    HomeView()
}
