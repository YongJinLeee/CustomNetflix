//
//  ViewController.swift
//  CustomNetflix
//
//  Created by LeeYongJin
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Home header 재생버튼 재생할 데이터 SearchAPI로 가져오기..
    @IBAction func playBtnOnHomeHeader(_ sender: Any) {
        
        SearchAPI.search("interstella") { movieInfo in
            guard let interstella = movieInfo.first else { return }
            
            DispatchQueue.main.async {
                let MovieURL = URL(string: interstella.previewURL)!
                let item = AVPlayerItem(url: MovieURL)
                
                let PlayerSB = UIStoryboard(name: "Player", bundle: nil)
                let PlayerVC = PlayerSB.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
                
                PlayerVC.modalPresentationStyle = .fullScreen
                // Player에 동영상 주소 로드
                PlayerVC.player.replaceCurrentItem(with: item)
                self.present(PlayerVC, animated: false, completion: nil)
            }
        }
        
    }
}








