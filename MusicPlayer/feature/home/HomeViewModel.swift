//
//  HomeViewModel.swift
//  MusicPlayer
//
//  Created by Theik Chan on 12/10/25.
//  Copyright © 2025 Theik Chan. All rights reserved.
//

import Foundation
import Observation

@Observable
final class HomeViewModel {
        
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    public var songs: [SongItem] = []

    private let songRepository: SongRepository

    init(songRepository: SongRepository = SongRepository(service: SongService())) {
        self.songRepository = songRepository
    }

    func getSongs() async {
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let response = await songRepository.getSongs()
        if !response.isEmpty {
            self.songs = response
        } else {
            errorMessage = "Failed to fetch songs."
        }
    }
}

