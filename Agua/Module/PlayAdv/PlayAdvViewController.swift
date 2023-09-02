//
//  PlayAdvViewController.swift
//  Agua
//
//  Created by Muneesh Kumar on 03/03/22.
//  Copyright © 2022 Kiwitech. All rights reserved.
//

import UIKit
import AVKit

class PlayAdvViewController: AGABaseVC {
    var player: AVAudioPlayer?
   // var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        playAdv()
        setGradientBackground()
        // Do any additional setup after loading the view.
    }
    @IBAction func backAction(_ sender: UIButton) {
        stopMusic()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopMusic()
    }
    func playAdv() {
        let path = Bundle.main.path(forResource: "adv", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playback,
                mode: AVAudioSession.Mode.default,
                options: [
                    AVAudioSession.CategoryOptions.duckOthers
                ]
            )
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            // 10 min
           // AdvertisementHandlar.shared.updateTimer()
        } catch {
            // couldn't load file :(
        }
    }
//    @objc func updateCounting() {
//        playAdv()
//    }
    deinit {
        AdvertisementHandlar.shared.stopTimer()
        stopMusic()
    }
    private func stopMusic() {
        player?.stop()
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch { }
        player = nil
    }
}
