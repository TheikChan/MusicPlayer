//
//  SongLibrary.swift
//  MusicPlayer
//
//  Created by Theik Chan on 1/31/18.
//  Copyright © 2018 Theik Chan. All rights reserved.
//

import Foundation

protocol SongLibrary {
    func allSongs() -> [SongItem]
    func addSong(_ song: SongItem)
    func removeSong(_ song: SongItem)
    func updateSong(_ song: SongItem)
    func getSong(_ id: Int) -> SongItem
}
