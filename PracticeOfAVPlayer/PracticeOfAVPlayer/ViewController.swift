//
//  ViewController.swift
//  PracticeOfAVPlayer
//
//  Created by Saahil Kaushal on 14/09/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var currentTimeLbl: UILabel!
    @IBOutlet weak var volumeControl: UISlider!
    
    var musicPlayer:AVAudioPlayer?
    var songs = [String]()
    var timer:Timer?
    var currentSongIndex = 0
    var countDown = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicPlayer = AVAudioPlayer()
        countDown = 0
        
        if let myFile = Bundle.main.path(forResource: "hello", ofType: "mp3"){
            songs.append(myFile)
        }
        if let myFile1 = Bundle.main.path(forResource: "hello3", ofType: "mp3"){
            songs.append(myFile1)
        }
        if let myFile2 = Bundle.main.path(forResource: "hello4", ofType: "mp3"){
            songs.append(myFile2)
        }
        
        if  let audioURL = URL(string: songs.first ?? ""){
            let audioAsset = AVURLAsset.init(url: audioURL,options: nil)
            do{
                let audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
               
                let duration = Float(audioPlayer.duration)
                
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateBar), userInfo: nil, repeats: true)
                
                let minutes = Int(duration) % 3600 / 60
                let seconds  = Int(duration) % 60
                let songTime = "\(minutes) : \(seconds)"
                print(songTime)
                totalTimeLbl.text = songTime
            }
            catch{
                print("Audio Player is not working")
            }
            
        }
        let myFilePath = songs
        let myFileURL = NSURL(fileURLWithPath: songs.first ?? "")
        do{
            try musicPlayer = AVAudioPlayer(contentsOf: myFileURL as URL)
            musicPlayer?.delegate = self
            
        }
        catch{
            print("Error")
        }
        
        
    }
    
    func audioPlayerDidFinishPlaying(_ player:AVAudioPlayer,successfully flag:Bool){
         print("After player finished playing")
            self.musicPlayer?.stop()
            self.musicPlayer = nil
        timer?.invalidate()
    }
    func startingTime(){
        let minutes = Int(countDown) / 60 % 60
        let seconds = Int(countDown) % 60
        currentTimeLbl.text = "\(minutes) : \(seconds)"
        countDown = 0
    
    }
    
    func playNextSong(){
        musicPlayer?.stop()
        timer?.invalidate()
        
        let myURL = URL(fileURLWithPath: songs[currentSongIndex])
        do{
            try musicPlayer = AVAudioPlayer(contentsOf: myURL)
            musicPlayer?.delegate = self
        }
        catch{
            print("Error")
        }
    }
    
    func updateTime(){
        if let audioPlayer = musicPlayer{
            let duration = Float(audioPlayer.duration)
            let minutes = Int(duration) % 3600 / 60
            let seconds = Int(duration) % 60
            let time1 = "\(minutes): \(seconds)"
            totalTimeLbl.text = time1
            print(duration)
            musicPlayer?.play()
        }else{
            totalTimeLbl.text = "00.00"
        }
    }
    
    @objc func updateBar(){
        if let audioPlayer = musicPlayer{
            let  currentTime = audioPlayer.currentTime
            let durationTime = audioPlayer.duration
            let totalTime = Float(currentTime / durationTime)
            progressBar.progress = totalTime
            musicPlayer?.play()
        }
        let minutes = Int(countDown) % 60 / 60
        let seconds = Int(countDown) % 60
        currentTimeLbl.text = "\(minutes) : \(seconds)"
        countDown += 1
    }
    

    @IBAction func PlayBtn(_ sender: UIButton) {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateBar), userInfo: nil, repeats: true)
        
        musicPlayer?.play()
    }
    @IBAction func pauseBtn(_ sender: UIButton) {
        musicPlayer?.pause()
        timer?.invalidate()
    }
    @IBAction func volumeController(_ sender: UISlider) {
        musicPlayer?.volume = volumeControl.value
        //volumeControl.value = Float(musicPlayer!.currentTime)
    }
    @IBAction func previousSong(_ sender: UIButton) {
        musicPlayer?.stop()
        timer?.invalidate()
        
        currentSongIndex -= 1
        if currentSongIndex < 0 {
            currentSongIndex = songs.count - 1
        }
            playNextSong()
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateBar), userInfo: nil, repeats: true)
        
       
        updateTime()
        startingTime()
        
    }
    @IBAction func nextSongBtn(_ sender: UIButton) {
        musicPlayer?.stop()
        timer?.invalidate()
        
        currentSongIndex += 1
        
        if currentSongIndex >= songs.count{
            currentSongIndex = 0
        }
            playNextSong()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateBar), userInfo: nil, repeats: true)
        
        
        updateTime()
        startingTime()
    }
}

