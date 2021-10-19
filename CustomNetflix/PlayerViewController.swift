//
//  PlayerViewController.swift
//  CustomNetflix
//
//  Created by LeeYongJin on 2021/10/14.
//

import UIKit

class PlayerViewController: UIViewController {
    
    // player 가로뷰 자동설정
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBAction func closingPlayer(_ sender: Any) {
        
        print("클릭 확인 : close btn clicked")
        
        dismiss(animated: false, completion: nil)
    }
}




