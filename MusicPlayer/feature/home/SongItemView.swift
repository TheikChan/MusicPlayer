//
//  SongItemView.swift
//  MusicPlayer
//
//  Created by Theik Chan on 12/10/25.
//  Copyright © 2025 Theik Chan. All rights reserved.
//

import SwiftUI

struct SongItemView: View {
    
    var song: SongItem?
    
    var body: some View {
        HStack {
            if let albumImage = song?.image {
                Image(albumImage)
                    .resizable()
                    .frame(width: 100, height: 80)
                    .clipShape(Capsule())
            }
            
            VStack {
                Text(song?.title ?? "")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(song?.album ?? "")
                    .foregroundColor(.primary)
                    .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
            }
        }
    }
}

#Preview {
    SongItemView(
        song: SongItem(
            id: 0,
            title: "Thunder",
            album: "Album Name",
            image: "disk",
            file: "linlin"
        )
    )
}
