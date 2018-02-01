//
//  SongItem.swift
//  MusicPlayer
//
//  Created by Theik Chan on 1/31/18.
//  Copyright © 2018 Theik Chan. All rights reserved.
//

import Foundation

class SongItem: NSObject {
    var id = 0
    var title = ""
    var album = ""
    var image = ""
    var file = ""
    
    init(_ id: Int,_ title: String,_ album: String,_ image: String,_ file: String) {
        self.id = id
        self.title = title
        self.album = album
        self.image = image
        self.file = file
    }
}
