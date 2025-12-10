//
//  MusicPlayerView.swift
//  MusicPlayer
//
//  Created by Theik Chan on 12/10/25.
//  Copyright © 2025 Theik Chan. All rights reserved.
//

import SwiftUI
import AVFoundation

struct MusicPlayerView: View {
    
    var song: SongItem?
    
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var timer: Timer?
    
    @State private var isPlayed: Bool = false
    
    @State private var currentTime: TimeInterval = 0
    @State private var duration: TimeInterval = 0
    @State private var songPlayedDuration: Double = 0 // 0...1 progress
    
    @State private var timeLeftLabel: String = "0:00"
    @State private var timeRightLabel: String = "0:00"
    
    @State private var songVolume: Float = 0.5
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            if let songThumbnail = song?.image {
                Image(songThumbnail)
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    .shadow(radius: 15.0)
                    .padding()
            }
            
            if let songTitle = song?.title {
                Text(songTitle)
                    .font(.title)
            }
            
            if let albumName = song?.album {
                Text(albumName)
                    .font(.subheadline)
                    .padding(.bottom)
            }
            
            Slider(value: Binding(get: {
                songPlayedDuration
            }, set: { newValue in
                songPlayedDuration = newValue
            }), in: 0...1, onEditingChanged: { editing in
                guard let player = audioPlayer else { return }
                if !editing {
                    player.currentTime = newValueClamped(newValue: songPlayedDuration) * (player.duration.isFinite ? player.duration : 0)
                    currentTime = player.currentTime
                    updateTimeLabels()
                }
            })
                .tint(.red)
                .padding(.horizontal)
            
            HStack {
                Text(timeLeftLabel)
                    .font(.caption)
                Spacer()
                Text(timeRightLabel)
                    .font(.caption)
            }.padding(.horizontal)
            
            HStack {
                Button {
                    skipBackward()
                }label: {
                    Image("ic_backword")
                        .resizable()
                        .frame(width: 28, height: 28)
                }.buttonStyle(.glass)
                
                Spacer()
                
                Button {
                    isPlayed.toggle()
                    if isPlayed {
                        play()
                    } else {
                        pause()
                    }
                }label: {
                    Image(isPlayed ? "ic_play_pause" : "ic_play_audio")
                        .resizable()
                        .frame(width: 48, height: 48)
                }.buttonStyle(.glass)
                
                Spacer()
                
                Button {
                    skipForward()
                }label: {
                    Image("ic_forward")
                        .resizable()
                        .frame(width: 28, height: 28)
                }.buttonStyle(.glass)
            }.padding()
            
            Spacer()
            
            HStack {
                Button {
                    songVolume = max(0.0, songVolume - 0.1)
                    audioPlayer?.volume = songVolume
                }label: {
                    Image("ic_vol_dec")
                        .resizable()
                        .frame(width: 28, height: 28)
                }.buttonStyle(.glass)
                
                Spacer()
                
                Slider(value: Binding(get: {
                    Double(songVolume)
                }, set: { newVal in
                    songVolume = Float(newVal)
                    audioPlayer?.volume = songVolume
                }), in: 0...1)
                    .tint(.blue)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    songVolume = min(1.0, songVolume + 0.1)
                    audioPlayer?.volume = songVolume
                }label: {
                    Image("ic_vol_inc")
                        .resizable()
                        .frame(width: 28, height: 28)
                }.buttonStyle(.glass)
            }.padding()
        }
        .onAppear {
            initAudioSession()
            preparePlayer()
        }
        .onDisappear {
            stopTimer()
            audioPlayer?.stop()
        }
    }
    
    private func initAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(true)
        } catch {
            // Handle audio session error if needed
        }
    }
    
    private func play() {
        if audioPlayer == nil {
            preparePlayer()
        }
        guard let player = audioPlayer else { return }
        player.volume = songVolume
        player.play()
        isPlayed = true
        startTimer()
    }
    
    private func pause() {
        audioPlayer?.pause()
        isPlayed = false
        stopTimer()
    }
    
    private func skipBackward() {
        guard let player = audioPlayer else { return }
        let newTime = max(0, player.currentTime - 15)
        player.currentTime = newTime
        currentTime = newTime
        updateProgressFromPlayer()
    }
    
    private func skipForward(){
        guard let player = audioPlayer else { return }
        let newTime = min(player.duration, player.currentTime + 15)
        player.currentTime = newTime
        currentTime = newTime
        updateProgressFromPlayer()
    }
    
    private func displayDuration() {
        updateTimeLabels()
    }
    
    private func preparePlayer() {
        guard let resource = song?.file, let url = Bundle.main.url(forResource: resource, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            duration = audioPlayer?.duration ?? 0
            currentTime = audioPlayer?.currentTime ?? 0
            updateProgressFromPlayer()
            updateTimeLabels()
        } catch {
            audioPlayer = nil
        }
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            guard let player = audioPlayer else { return }
            currentTime = player.currentTime
            updateProgressFromPlayer()
            updateTimeLabels()
            if player.currentTime >= player.duration {
                isPlayed = false
                stopTimer()
            }
        }
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateProgressFromPlayer() {
        guard let player = audioPlayer, player.duration > 0 else { return }
        songPlayedDuration = player.currentTime / player.duration
    }

    private func updateTimeLabels() {
        timeLeftLabel = formatTime(currentTime)
        timeRightLabel = formatTime(max(0, (audioPlayer?.duration ?? 0) - currentTime))
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func newValueClamped(newValue: Double) -> Double {
        return min(max(newValue, 0), 1)
    }
}

#Preview {
    MusicPlayerView(
        song: SongItem(
            id: 0,
            title: "Thunder",
            album: "Album Name",
            image: "disk",
            file: "linlin"
        )
    )
}

