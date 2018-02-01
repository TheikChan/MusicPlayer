//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Theik Chan on 1/30/18.
//  Copyright © 2018 Theik Chan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var songLibrary: SongLibrary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
    }
}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("song count : \((songLibrary?.allSongs().count)!)")
        return (songLibrary?.allSongs().count)!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as! SongTableViewCell
        
        let songItem = songLibrary?.getSong(indexPath.row)
        
        cell.songTitle.text = songItem?.title
        cell.songImage.image = UIImage(named: (songItem?.image)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let audioViewController = self.storyboard?.instantiateViewController(withIdentifier: "audio_player") as? AudioPlayerController{
            
            audioViewController.songItem = songLibrary?.getSong(indexPath.row)
            //let navController = UINavigationController(rootViewController: audioViewController)
            self.present(audioViewController, animated:true, completion: nil)
        }
    }
    
}


