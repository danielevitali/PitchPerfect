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

    let FAST_RATE: Float = 1.5
    let NORMAL_RATE: Float = 1
    let SLOW_RATE: Float = 0.5
    let HIGH_PITCH: Float = 1000
    let NORMAL_PITCH: Float = 0
    let LOW_PITCH: Float = -1000
    
    var recordedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: recordedAudio.filePathUrl)
    }
 
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(SLOW_RATE, pitch: NORMAL_PITCH)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(FAST_RATE, pitch: NORMAL_PITCH)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudio(NORMAL_RATE, pitch: HIGH_PITCH)
    }
    
    @IBAction func playDarthWaderAudio(sender: UIButton) {
        playAudio(NORMAL_RATE, pitch: LOW_PITCH)
    }
    
    @IBAction func stop(sender: UIButton) {
        stop()
    }
    
    func pause() {
        audioEngine.pause()
    }
    
    func resume() {
        try! audioEngine.start()
    }
    
    func stop() {
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudio(rate: Float, pitch: Float) {
        stop()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let audioUnitTimePitch = AVAudioUnitTimePitch()
        audioUnitTimePitch.pitch = pitch
        audioUnitTimePitch.rate = rate
        audioEngine.attachNode(audioUnitTimePitch)
        
        audioEngine.connect(audioPlayerNode, to: audioUnitTimePitch, format: nil)
        audioEngine.connect(audioUnitTimePitch, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
}
