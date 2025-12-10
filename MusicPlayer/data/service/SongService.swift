//
//  SongService.swift
//  MusicPlayer
//
//  Created by Theik Chan on 12/10/25.
//  Copyright © 2025 Theik Chan. All rights reserved.
//

final class SongService {    
    func getSongs() async -> [SongItem] {
        [
            SongItem(
                id: 0,
                title: "Linn Linn",
                album: "Album Name",
                image: "disk",
                file: "linlin"
            ),
            SongItem(
                id: 1,
                title: "Lay Phyu",
                album: "Album Name",
                image: "guiter",
                file: "layphyu"
            ),
            SongItem(
                id: 2,
                title: "Waila",
                album: "Album Name",
                image: "headphone",
                file: "waila"
            ),
        ]
    }
}
