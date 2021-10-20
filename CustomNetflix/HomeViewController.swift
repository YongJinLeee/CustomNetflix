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
    // thumbnailPath 이용해 헤더뷰에 사진 뜨도록 수정해야 함
    @IBAction func playBtnOnHomeHeader(_ sender: Any) {
        
        SearchAPI.search("Dark") { movieInfo in
            guard let randomHeader = movieInfo.randomElement() else { return }
            
            DispatchQueue.main.async {
                
                let MovieURL = URL(string: randomHeader.previewURL)!
                let item = AVPlayerItem(url: MovieURL)
                
                let PlayerSB = UIStoryboard(name: "Player", bundle: nil)
                let PlayerVC = PlayerSB.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
                // Player에 동영상 주소 로드
                PlayerVC.player.replaceCurrentItem(with: item)
                
                PlayerVC.modalPresentationStyle = .fullScreen
                self.present(PlayerVC, animated: false, completion: nil)
            }
        }
        
    }
}








