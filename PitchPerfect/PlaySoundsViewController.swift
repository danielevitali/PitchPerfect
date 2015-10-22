//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Daniele Vitali on 14/10/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var recordedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = try! AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: recordedAudio.filePathUrl)
    }
 
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5, pitch: 0)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(1.5, pitch: 0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudio(1, pitch: 1000)
    }
    
    @IBAction func playDarthWaderAudio(sender: UIButton) {
        playAudio(1, pitch: -1000)
    }
    
    @IBAction func stop(sender: UIButton) {
        stop()
    }
    
    func stop() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func pause() {
        audioPlayer.pause()
    }
    
    func resume() {
        audioPlayer.play()
    }
    
    func playAudio(rate: Float, pitch: Float) {
        stop()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = 1000
        audioEngine.attachNode(changePitchEffect)        
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayer.rate = rate
        
        audioPlayerNode.play()
    }
}
