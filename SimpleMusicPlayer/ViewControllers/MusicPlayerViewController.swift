//
//  MusicPlayerViewController.swift
//  SimpleMusicPlayer
//
//  Created by Дмитрий on 15.06.2018.
//  Copyright © 2018 Dmitry Lupich. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class MusicPlayerViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    // MARK: Properties

    var musicPlayer = AVAudioPlayer()
    var audioSession = AVAudioSession.sharedInstance()

    // MARK: ViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMusicPlayer()
        setAudioSession()
        setupCommandCenter()
    }

    // MARK: Actions

    @IBAction func playButton(_ sender: UIButton) {
        playMusic()
    }

    @IBAction func pauseButton(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            pauseMusic()
        }
    }

    @IBAction func stopButton(_ sender: UIButton) {
        musicPlayer.stop()
        musicPlayer.currentTime = 0
        statusLabel.text = AppConstants.stopText
    }

    // MARK: Additional Methods

    func setupMusicPlayer() {
        let url = Bundle.main.path(forResource: AppConstants.musicFileName, ofType: "mp3")
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: url!))
        } catch {
            print(error.localizedDescription)
            // handle error here
        }
        musicPlayer.prepareToPlay()
        songNameLabel.text = AppConstants.musicFileName
    }

    func setAudioSession() {
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print(error.localizedDescription)
        }
    }

    func setupCommandCenter() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: AppConstants.appName]

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] (_) -> MPRemoteCommandHandlerStatus in
            self?.playMusic()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] (_) -> MPRemoteCommandHandlerStatus in
            self?.pauseMusic()
            return .success
        }
    }

    func playMusic() {
        musicPlayer.play()
        statusLabel.text = AppConstants.playText
    }

    func pauseMusic() {
        musicPlayer.pause()
        statusLabel.text = AppConstants.pauseText
    }
}
