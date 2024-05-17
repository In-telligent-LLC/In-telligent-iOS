
//
//  INAudioManager.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/30/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import MediaPlayer

public class INAudioManager: NSObject {
    
    static let shared = INAudioManager()

    private (set)var currentAudioPlayer: AVAudioPlayer?
    private (set)var currentAudio: Audio?
    
    class public func setMaxVolume() {
        shared.setMaxVolume()
    }
    
    class public func play(_ audio: Audio, numberOfLoops: Int = -1, force: Bool = false, completion: @escaping (Bool) -> Void) {
        guard let url = fileURL(for: audio) else {
            completion(false)
            return
        }
        play(url, numberOfLoops: numberOfLoops, force: force, completion: { (success) in
            if success {
                shared.currentAudio = audio
            }
            completion(success)
        })
    }
    
    class public func play(_ url: URL, numberOfLoops: Int = -1, force: Bool = false, completion: @escaping (Bool) -> Void) {
        shared.enableAudioSession { (success) in
            if success {
                shared.play(url, numberOfLoops: numberOfLoops, force: force, completion: completion)
            }
        }
    }

    class public func isPlaying(_ audio: Audio) -> Bool {
        return shared.currentAudio == audio
    }
    
    class public func stop() {
        shared.stop()
    }
    
}

extension INAudioManager {

    private func audioPlayer(for url: URL) -> AVAudioPlayer? {
        var audioPlayer: AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            Logging.info(error)
        }
        
        return audioPlayer
    }
    
    private func setMaxVolume() {
        let volumeControl = MPVolumeView()
        
        volumeControl.showsRouteButton = false
        volumeControl.showsVolumeSlider = false
        
        guard let slider = volumeControl.subviews.first(where: {view in view is UISlider}) as? UISlider else {
            return Logging.info("Unable to find slider in MPVolumeView")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            slider.value = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                slider.sendActions(for: [.touchUpInside])
            }
        }
    }
    
    func enableAudioSession(_ delay: TimeInterval = 0, completion: @escaping (Bool) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            Logging.info("Is on main thread? \(Thread.isMainThread)")
                        
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            } catch {
                Logging.info(error)
            }
            
            Logging.info("Other audio playing: \(AVAudioSession.sharedInstance().isOtherAudioPlaying)")
            
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                Logging.info(error)
                
                do {
                    try AVAudioSession.sharedInstance().setActive(false)
                }
                catch  {
                    Logging.info(error)
                }
                
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    Logging.info(error)
                    return completion(false)
                }
            }
            
            return completion(true)
        }
    }
    
    private func play(_ url: URL, numberOfLoops: Int, force: Bool, completion: @escaping (Bool) -> Void) {
        Logging.info("Trying to play \(url). Is already playing?", currentAudio?.rawValue)

        guard currentAudio == nil || force else {
            return
        }
        
        if let currentAudioPlayer = currentAudioPlayer, currentAudioPlayer.isPlaying {
            self.currentAudioPlayer = nil
            currentAudioPlayer.stop()
        }
        
        guard let audioPlayer = self.audioPlayer(for: url) else { return }

        var retryCallback: (Bool) -> () = {_ in }
        var numTries = 0
        
        retryCallback = {
            success in
            
            numTries += 1
            Logging.info("Play audio attempt: \(numTries)")
            
            if success {
                audioPlayer.volume = 1.0
                audioPlayer.numberOfLoops = numberOfLoops
                audioPlayer.delegate = self
                audioPlayer.play()
                
                if audioPlayer.isPlaying {
                    self.currentAudioPlayer = audioPlayer
                    return completion(true)
                }
            }
            
            if numTries <= 20 {
                self.enableAudioSession(3, completion: retryCallback)
            } else {
                Logging.info("Out of retries")
                completion(false)
            }
        }
        
        enableAudioSession(completion: retryCallback)
    }
    
    private func stop() {
        Logging.info("Trying to stop. Is already playing?", currentAudioPlayer?.isPlaying)

        if let audioPlayer = currentAudioPlayer, audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: [])
        } catch {
            Logging.info("Error changing setting audio session inactive", error)
        }
        
        self.currentAudio = nil
        self.currentAudioPlayer = nil
    }
    
}

extension INAudioManager: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == currentAudioPlayer {
            stop()
        }
    }
}

extension INAudioManager {
    public class func fileURL(for audio: Audio) -> URL? {
        let bundle = Bundle(for: INAudioManager.self)
        return bundle.url(forResource: audio.rawValue, withExtension: "mp3")
    }
}
