//
//  PlayerViewController.swift
//  CustomNetflix
//
//  Created by LeeYongJin on 2021/10/14.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    // 추가해야 할 것
    // 1. seeking bar
    // 2. 재생 후 View isHidden 기능 추가
    // 2-1. 화면 터치시 view 다시 보이기 - 자동 사라짐 기능
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var controllView: UIView!
    
    // play에 필요한 데이터는 searchViewController에서 가져옴
    let player = AVPlayer()
    
    // player 가로뷰 자동설정
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PlayerView AVPlayer 인스턴스화
        playerView.player = player
        
    }
    // view에 보여지기 직전
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 자동재생
        play()
    }

    @IBOutlet weak var closeBtn: UIButton!
    @IBAction func togglePlayBtn(_ sender: Any) {
        if player.isPlaying { // true: 실행중
            pause()
        } else {
            play()
        }
    }

    @IBAction func closingPlayer(_ sender: Any) {
        
        // test Code
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



