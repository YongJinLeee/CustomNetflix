//
//  ViewController.swift
//  CustomNetflix
//
//  Created by LeeYongJin
//

import os
import UIKit
import Firebase

class SaveViewController: UIViewController {
    
    @IBOutlet weak var dataLabel: UILabel!
    // Firebace의 realTime DB의 레퍼런스 불러오기;
    // Gets a FIRDatabaseReference for the root of your Firebase Database.
    // : FIRDatabaseReference의 인스턴스화 상수 db (.reference() 호출)
    let db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updataDBTest()
    }
    
    func updataDBTest() {
        // 전달은 JSON type
        db.child("firstData").observeSingleEvent(of: .value) { snapshot in
            print("what data in snapshot: \(snapshot)")
            
            let value = snapshot.value as? String ?? ""
            // UI관련 이기때문에 main Thread에서 처리
            DispatchQueue.main.async {
                self.dataLabel.text = value
            }
            print("\(value)")
            //            print("What a data in snapshot : \(snapshot)")
        }
    }

}
