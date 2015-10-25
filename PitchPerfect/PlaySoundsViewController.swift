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

    private let FAST_RATE: Float = 1.5
    private let NORMAL_RATE: Float = 1
    private let SLOW_RATE: Float = 0.5
    private let HIGH_PITCH: Float = 1000
    private let NORMAL_PITCH: Float = 0
    private let LOW_PITCH: Float = -1000
    
    var recordedAudio: RecordedAudio!
    
    private var audioEngine: AVAudioEngine!
    private var audioPlayerNode: AVAudioPlayerNode!
    private var audioFile: AVAudioFile!
    
    private var lastPlayType: PlayType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioFile = try! AVAudioFile(forReading: recordedAudio.filePathUrl)
    }
 
    @IBAction func playSlowAudio(sender: UIButton) {
        handleButton(PlayType.Slow)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        handleButton(PlayType.Fast)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        handleButton(PlayType.Chipmunk)
    }
    
    @IBAction func playDarthWaderAudio(sender: UIButton) {
        handleButton(PlayType.DarthWader)
    }
    
    @IBAction func stop(sender: UIButton) {
        lastPlayType = nil
        stop()
    }
    
    private func handleButton(playType: PlayType) {
        if(lastPlayType != playType) {
            lastPlayType = playType
            switch playType {
            case PlayType.Fast:
                playAudio(FAST_RATE, pitch: NORMAL_PITCH)
            case PlayType.Slow:
                playAudio(SLOW_RATE, pitch: NORMAL_PITCH)
            case PlayType.Chipmunk:
                playAudio(NORMAL_RATE, pitch: HIGH_PITCH)
            case PlayType.DarthWader:
                playAudio(NORMAL_RATE, pitch: LOW_PITCH)
            }
            return
        }
        
        if(audioPlayerNode.playing) {
            audioPlayerNode.pause()
        } else {
            audioPlayerNode.play()
        }
    }
    
    private func stop() {
        audioEngine.stop()
        audioEngine.reset()
    }
    
    private func playAudio(rate: Float, pitch: Float) {
        stop()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let audioUnitTimePitch = AVAudioUnitTimePitch()
        audioUnitTimePitch.pitch = pitch
        audioUnitTimePitch.rate = rate
        audioEngine.attachNode(audioUnitTimePitch)
        
        audioEngine.connect(audioPlayerNode, to: audioUnitTimePitch, format: nil)
        audioEngine.connect(audioUnitTimePitch, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: { () -> Void in
            self.lastPlayType = nil
        })
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    override func viewDidDisappear(animated: Bool) {
        try! NSFileManager.defaultManager().removeItemAtURL(recordedAudio.filePathUrl)
    }
}
