//
//  PlayerViewController.swift
//  CustomNetflix
//
//  Created by LeeYongJin on 2021/10/14.
//

import UIKit

class PlayerViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerClosed()
    }
    
    @IBOutlet weak var closeBtn: UIButton!
    
    
    @IBAction func closingPlayer(_ sender: Any) {
        
        print("close btn clicked")
     
        let SearchView =  UIStoryboard(name: "Main", bundle: nil)
        let searchVC = SearchView.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: false, completion: nil)
    }
    
    
    func playerClosed() {
        
        if closeBtn.isSelected == true {
            
        let SearchView =  UIStoryboard(name: "Main", bundle: nil)
        let searchVC = SearchView.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        present(searchVC, animated: false, completion: nil)
        }
    }

}


