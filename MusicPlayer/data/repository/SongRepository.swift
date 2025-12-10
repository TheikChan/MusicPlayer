//
//  SongRepository.swift
//  MusicPlayer
//
//  Created by Theik Chan on 12/10/25.
//  Copyright © 2025 Theik Chan. All rights reserved.
//

class SongRepository {
    
    private let service: SongService
    
    init(service: SongService) {
        self.service = service
    }
    
    func getSongs() async -> [SongItem] {
        await service.getSongs()
    }
}
