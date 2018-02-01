//
//  DummySong.swift
//  MusicPlayer
//
//  Created by Theik Chan on 1/31/18.
//  Copyright © 2018 Theik Chan. All rights reserved.
//

import Foundation

class DummySong: NSObject, SongLibrary {
    
    fileprivate var songs: [SongItem] = []
    
    override init() {
        super.init()
        
        addDummySong()
    }
    
    fileprivate func addDummySong() {
        var song: SongItem = SongItem(0, "Thunder", "Album Name", "disk","linlin")
        self.songs.append(song)
        
        song = SongItem(1, "Havana", "Album Name", "guiter","layphyu")
        self.songs.append(song)
        
        song = SongItem(2, "Best Song Ever", "Album Name", "headphone","waila")
        self.songs.append(song)
    }
    
    func allSongs() -> [SongItem] {
        return songs
    }
    
    func addSong(_ song: SongItem) {
        for currentSong in songs {
            if currentSong.id == song.id {
                return
            }
        }
        
        songs.append(song)
    }
    
    func removeSong(_ song: SongItem) {
        var indexToRemove: Int?
        for index in 0...songs.count-1 {
            let currentSong = songs[index]
            if currentSong.id == song.id {
                indexToRemove = index
                break
            }
        }
        
        if let indexToRemove = indexToRemove {
            songs.remove(at: indexToRemove)
        }
    }
    
    func updateSong(_ song: SongItem) {
        var existingSong: SongItem?
        for currentSong in songs {
            if currentSong.id == song.id {
                existingSong = currentSong
                break
            }
        }
        
        if let existingSong = existingSong {
            existingSong.id = song.id
            existingSong.title = song.title
            existingSong.album = song.album
            existingSong.image = song.image
        }
    }
    
    func getSong(_ id: Int) -> SongItem{
        var existingSong: SongItem?
        for currentSong in songs {
            if currentSong.id == id {
                existingSong = currentSong
                break
            }
        }
        return existingSong!
    }
}
