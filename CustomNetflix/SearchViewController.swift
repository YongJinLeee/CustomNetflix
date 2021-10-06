//
//  SearchViewController.swift
//  CustomNetflix
//
//  Created by LeeYongJin on 2021/10/06.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 키보드 호출 감지
//        NotificationCenter.default.addObserver(self, selector: #selector(adjstInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    // 키보드 내리기
    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 시작 메소드 -> 필요 없다면 내려가도록 처리 (1. 검색 버튼 누를때, 2. 백그라운드 터치시)
        // 키보드 디텍션
        
        // 검색어 있는지 확인
        dismissKeyboard()
        
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        // 검색어 있다면 -> 네트워킹 -> 결과 출력
        
        print("search Bar clicked: \(searchBar.text) 에 대한 검색이 시작되었습니다.")
    }
    
}
