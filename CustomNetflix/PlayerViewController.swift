//
//  PlayerViewController.swift
//  CustomNetflix
//
//  Created by LeeYongJin on 2021/10/14.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var controllView: UIView!
    
    let player = AVPlayer()
    
    // player 가로뷰 자동설정
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PlayerView 상속
        playerView.player = player
        
    }
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBAction func togglePlayBtn(_ sender: Any) {
        if player.isPlaying { // true: 실행중
            // 정지 -> Foundation moduel에 있음
            pause()
        } else {
            play()
            // 실행
        }
    }

    @IBAction func closingPlayer(_ sender: Any) {
        
        print("클릭 확인 : close btn clicked")
        playerReset()
        dismiss(animated: false, completion: nil)
        portraitlMode()
    }
    
    // player Controller method
    func play() {
        player.play()
        playBtn.isSelected = true
    }
    
    func pause() {
        player.pause()
        playBtn.isSelected = false
    }
    
    func playerReset() {
        pause()
        player.replaceCurrentItem(with: nil)
    }
}

func portraitlMode() {
    var supportedfaceorientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

// AVPlyaer extension
extension AVPlayer {
    
    //재생 여부 확인
    var isPlaying: Bool {
        
        guard self.currentItem != nil else {
            return false
        }
        return self.rate != 0
    }
}



