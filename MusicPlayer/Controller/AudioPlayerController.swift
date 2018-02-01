//
//  DummySong.swift
//  MusicPlayer
//
//  Created by Theik Chan on 1/31/18.
//  Copyright © 2018 Theik Chan. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerController: UIViewController {
   
    @IBOutlet var imgCover: UIImageView!
    
    @IBOutlet weak var lblDurationTime: UILabel!
    @IBOutlet var lblCurrentTime: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblArtistName: UILabel!
    
    @IBOutlet var btnPlayPause: UIButton!
    
    @IBOutlet var slider: UISlider!
    
    @IBOutlet var progressBar: UISlider!

    var audioIndex = Int()
    var onSliderHold = Bool()
    var timer:Timer?
    
    var songItem: SongItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpProgressSlider()
        self.initAudioSession()
    }
    
    func initAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            //print("Failed to set audio session category.  Error: \(error)")
        }
    }
    
    func setUpProgressSlider() {
        let sliderThumb = UIImage(named: "music_slide")
        progressBar.setThumbImage(sliderThumb, for: .normal)
        progressBar.setThumbImage(sliderThumb, for: .highlighted)
        
        progressBar.setMinimumTrackImage(UIImage(named: "min_track")?.resizableImage(withCapInsets: UIEdgeInsetsFromString("0")), for: .normal)
        progressBar.setMaximumTrackImage(UIImage(named: "max_track")?.resizableImage(withCapInsets: UIEdgeInsetsFromString("0")), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if delegate.isPlay || delegate.isPause {
            self.stop()
        }
        
        self.play()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapCloseButton() {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.audioPlayer.stop()
        timer?.invalidate()
        timer = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPlay(_ sender: UIButton) {
        self.play()
    }
    
    func updateData() {
        lblTitle.text = songItem?.title
        lblArtistName.text = songItem?.album
        imgCover.image = UIImage(named: (songItem?.image)!)

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatemyProgress), userInfo: nil, repeats: true)
    }
    
    @objc func updatemyProgress() {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if delegate.isPlay {
            if !onSliderHold {
                let progress = delegate.audioPlayer.currentTime / delegate.audioPlayer.duration
                progressBar.value = Float(progress)

                let time = calculateTimeFromNSTimeInterval(delegate.audioPlayer.currentTime)
                let duration = calculateTimeFromNSTimeInterval(delegate.audioPlayer.duration)
                lblCurrentTime.text  = "\(time.minute):\(time.second)"
                lblDurationTime.text = "\(duration.minute):\(duration.second)"
            }
        }
        else {
            if !delegate.isPause {
                lblCurrentTime.text = ""
                lblDurationTime.text = ""
            }
        }
    }
    
    func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) ->(minute:String, second:String) {
        //let hour_   = abs(Int(duration)/3600)
        let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
        let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))

        // var hour = hour_ > 9 ? "\(hour_)" : "0\(hour_)"
        let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
        let second = second_ > 9 ? "\(second_)" : "0\(second_)"
        return (minute,second)
    }
    
    func play() {
        onSliderHold = false

        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if delegate.isPlay {
            delegate.audioPlayer.pause()
            delegate.isPlay = false
            delegate.isPause = true
            btnPlayPause.setImage(UIImage(named: "ic_play_audio"), for: .normal)
        }else {
                
                let fileUrl = Bundle.main.url(forResource: songItem?.file, withExtension: "mp3")
                
                if !delegate.isPause {
                do {
                    delegate.audioPlayer = try AVAudioPlayer(contentsOf: fileUrl!)
                    }catch {
                        // couldn't load file :)
                    }
                }
                delegate.audioPlayer.delegate = self

                btnPlayPause.setImage(UIImage(named: "ic_play_pause"), for: .normal)
                delegate.isPlay = true
                delegate.isPause = false
                delegate.audioPlayer.prepareToPlay()
                delegate.audioPlayer.play()

                self.updateData()
        }
    }
    
    func stop() {
        onSliderHold = false

        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.audioPlayer.stop()
        delegate.isPause = false
        delegate.isPlay = false
        
        progressBar.value = 0
        btnPlayPause.setImage(UIImage(named: "ic_play_audio"), for: .normal)
        lblCurrentTime.text = ""
        lblDurationTime.text = ""
    }
    
    @IBAction func onSliderStart(_ sender: UISlider) {
        onSliderHold = true
    }
    
    @IBAction func onSilderEnd(_ sender: UISlider) {
        onSliderHold = false
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        onSliderHold = false

        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

        let mySlider = sender
        let tm = mySlider.value * Float(delegate.audioPlayer.duration)

        delegate.audioPlayer.stop()
        delegate.audioPlayer.currentTime = TimeInterval(tm)
        btnPlayPause.setImage(UIImage(named: "ic_play_pause"), for: .normal)
        delegate.isPlay = true
        delegate.isPause = false
        delegate.audioPlayer.prepareToPlay()
        delegate.audioPlayer.play()
    }
    
    @IBAction func skipBackward(_ sender: UIButton) {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

        if delegate.isPlay {
            let currentTime = delegate.audioPlayer.currentTime

            let time = calculateTimeFromNSTimeInterval(currentTime)

            if Int(time.minute)! > 1 || Int(time.second)! > 10 {
                delegate.audioPlayer.stop()

                delegate.audioPlayer.prepareToPlay()
                delegate.audioPlayer.play()
                delegate.audioPlayer.currentTime -= 10

                delegate.isPlay = true
                delegate.isPause = false
            }
        }
        
    }
    
    @IBAction func skipForward(_ sender: Any?) {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if delegate.isPlay {

            let currentTime = delegate.audioPlayer.currentTime
            let durationTime = delegate.audioPlayer.duration

            let time = calculateTimeFromNSTimeInterval(currentTime)
            let duration = calculateTimeFromNSTimeInterval(durationTime)

            if time.minute < duration.minute {

            delegate.audioPlayer.stop()

            delegate.audioPlayer.prepareToPlay()
            delegate.audioPlayer.play()
            delegate.audioPlayer.currentTime += 10

            delegate.isPlay = true
            delegate.isPause = false
            }
        }
    }
    
    @IBAction func volumeChanged(_ sender: UISlider) {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.audioPlayer.volume = sender.value
    }
    
}

extension AudioPlayerController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //self.nextSong(nil)
    }
}
