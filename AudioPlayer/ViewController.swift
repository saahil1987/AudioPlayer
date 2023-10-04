//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Saahil Kaushal on 06/09/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var staringTimeLbl: UILabel!
    @IBOutlet weak var volumeController: UISlider!
    @IBOutlet weak var totalTimelbl: UILabel!
    
    var myAudioPlayer:AVAudioPlayer?
    var time:Timer?
    var coountDown = 0
    var songs : [String] = []
    var currentSongIndex = 0
    var progressView:UIProgressView!
    var currentIndex = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myAudioPlayer = AVAudioPlayer()
        progressBar.progress = 0
        currentIndex = 0
        
        if let myFilePathString = Bundle.main.path(forResource: "hello3", ofType: "mp3"){
            songs.append(myFilePathString)
        }
        if let myFilePathString1 = Bundle.main.path(forResource: "hello4", ofType: "mp3"){
            songs.append(myFilePathString1)
        }
        if let myFilePathString2 = Bundle.main.path(forResource: "love2", ofType: "mp3"){
            songs.append(myFilePathString2)
        }
        
        if let myFilePathString3 = Bundle.main.path(forResource: "love", ofType: "mp3"){
            songs.append(myFilePathString3)
        }
        if let myFilePathString4 = Bundle.main.path(forResource: "love1", ofType: "mp3"){
            songs.append(myFilePathString4)
        }
        
        if let audioURL = URL(string: songs.first ?? ""){
            let audioAsset = AVURLAsset.init(url: audioURL,options: nil)
            do{
                let audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                let duration = (audioPlayer.duration)
            
                time = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
                
                let minutes = Int(duration) % 3600 / 60
                let seconds = Int(duration) % 60
                let time1 = "\(minutes) : \(seconds)"
                totalTimelbl.text = time1
                print(duration)
                
            }catch{
                print("Error")
            }
        }
        // All about the songs
        let myFilePathString = songs
        let myFilePathURL = NSURL(fileURLWithPath: songs.first ?? "")
        do{
            try myAudioPlayer = AVAudioPlayer(contentsOf: myFilePathURL as URL)
            
            myAudioPlayer?.delegate = self
            
        }catch{
            print("Error occured")
        }
    }
    
    //Dynamically Start Progress Bar
    @objc func updateProgressView(){
        if let audioPlayer = myAudioPlayer{
            let currentTime = audioPlayer.currentTime
            let duration = audioPlayer.duration
            let totalTime = Float(currentTime / duration)
            progressBar.progress = totalTime
            //progressBar.value = Float(audioPlayer?.currentTime ?? 0)
            myAudioPlayer?.play()
            
        }
        
        
        // Timer starts with the song
        let minutes = Int(coountDown) / 60 % 60
        let seconds = Int(coountDown) % 60
        staringTimeLbl.text = "\(minutes) : \(seconds)"
        coountDown += 1
    }
    
    @IBAction func playBtn(_ sender: UIButton) {
        
        time = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        myAudioPlayer?.play()
        
    }
    
    @IBAction func pauseBtn(_ sender: UIButton) {
        time?.invalidate()
        myAudioPlayer?.pause()
    }
    @IBAction func volumeControl(_ sender: UISlider) {
        myAudioPlayer?.volume = volumeController.value
        volumeController.value = Float(myAudioPlayer!.currentTime)
        
    }
    
    
    @IBAction func previousBtn(_ sender: UIButton) {
        myAudioPlayer?.stop()
        time?.invalidate()
        // Code used for change previous the song track
        currentSongIndex -= 1
        
        if currentSongIndex < 0 {
            currentSongIndex = songs.count - 1
        }
        playCurrentSong()
        
         time = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        //startingTime()
        //updateProgressView()
        updateDurationTime()
        startingTime()
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        myAudioPlayer?.stop()
        time?.invalidate()
        // code used for to change next track
        
        currentSongIndex += 1
        
        if currentSongIndex >= songs.count{
            currentSongIndex = 0
        }
        playCurrentSong()
        
        time = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        // startingTime()
       // updateProgressView()
        updateDurationTime()
        startingTime()
    }
    // Play Next song in audio player
    func playCurrentSong(){
        myAudioPlayer?.stop()
        time?.invalidate()
        
        let currentSongURL = URL(fileURLWithPath: songs[currentSongIndex])
        do{
            myAudioPlayer = try AVAudioPlayer(contentsOf: currentSongURL)
            
            myAudioPlayer?.delegate = self
            
        }catch{
            print("Error occured while playing the current song")
            
        }
        
    }
    func updateDurationTime(){
        if let audioPlayer = myAudioPlayer{
            let duration = CGFloat(audioPlayer.duration)
            let minutes = Int(duration) % 3600 / 60
            let seconds = Int(duration) % 60
            let time1 = "\(minutes) : \(seconds)"
            totalTimelbl.text = time1
            print(duration)
        }else{
            totalTimelbl.text = "00:00"
        }
    }
    func startingTime(){
        let minutes = Int(coountDown) / 60 % 60
        let seconds = Int(coountDown) % 60
        staringTimeLbl.text = "\(minutes) : \(seconds)"
        coountDown = 0
    
    }
    func audioPlayerDidFinishPlaying(_ player:AVAudioPlayer,successfully flag:Bool){
         print("After player finished playing")
            self.myAudioPlayer?.stop()
            self.myAudioPlayer = nil
        time?.invalidate()
        
        
       
        
    }
}
