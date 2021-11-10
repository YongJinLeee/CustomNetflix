//
//  ViewController.swift
//  CustomNetflix
//
//  Created by LeeYongJin
//

import os
import UIKit
import Firebase

class ViewController: UIViewController {
    
    // Firebace의 realTime DB의 레퍼런스 불러오기;
    // Gets a FIRDatabaseReference for the root of your Firebase Database.
    // : FIRDatabaseReference의 인스턴스화 상수 db (.reference() 호출)
    var db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 전달은 JSON type
        db.child("firstData").observeSingleEvent(of: .value) { snapshot in
            print("What a data in snapshot : \(snapshot)")
        }
    }

}
