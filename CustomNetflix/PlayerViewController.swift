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
    }
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBAction func togglePlayBtn(_ sender: Any) {
        
        playBtn.isSelected = !playBtn.isSelected
        
    }
    @IBAction func closingPlayer(_ sender: Any) {
        
        print("클릭 확인 : close btn clicked")
        
        dismiss(animated: false, completion: nil)
        portraitlMode()
    }
}

func portraitlMode() {
    var supportedfaceorientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension AVPlayer {
    
    //재생 여부 확인
    var isPlaying: Bool {
        
        guard self.currentItem != nil else {
            return false
        }
        return self.rate != 0
    }
}



