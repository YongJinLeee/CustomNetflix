//
//  SearchViewController.swift
//  CustomNetflix
//
//  Created by LeeYongJin on 2021/10/06.
//

// 검색 API 필요
// 결과를 받아올 model (MVVM 패턴) -> stored property가 필요한 것 : 영화 목록, URL Respone
// 받아온 결과물을 처리할 ViewModel -> collectionView에 뿌릴
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
        // 검색버튼 눌리면 최초응답자격 상실-> 키보드 다운
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return print("검색어가 없습니다.") }
        // 검색어 확인 부분 옵셔널 바인딩
        // 검색어 있다면 -> 네트워킹 -> 결과 출력
        
        searchAPI.search(searchTerm) {
            movies in
        }
        
        print("search Bar clicked: \(searchTerm) 에 대한 검색이 시작되었습니다.")
        // 옵셔널 바인딩 되었으므로 콘솔 확인 searchBar.text -> searchTerm으로 변경
    }
    
}

// 검색 동작 수행할 API class
class searchAPI {
    //type method - 인스턴스 생성 없이 .으로 바로 메소드 호출 가능
    // escaping을 쓰면 해당 코드블럭 바깥에서도 사용 될 수 있음을 명시할 수 있음
    static func search(_ term: String, completion: @escaping (([Movie]) -> Void)) {
        let session = URLSession(configuration: .default)
        
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
        let mediaQuery = URLQueryItem(name: "media", value: "music")
        let entityQuery = URLQueryItem(name: "entity", value: "song")
        let termQuery = URLQueryItem(name: "term", value: term)
        
        urlComponents.queryItems?.append(mediaQuery)
        urlComponents.queryItems?.append(entityQuery)
        urlComponents.queryItems?.append(termQuery)
        
        let requestURL = urlComponents.url!
        
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            let successRange = 200..<300
            
            // error 테스트 코드
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print("Error Code: \(successRange)")
                completion([])
                
                return
            }
            guard let resultData = data else {
                completion([])
                return
            }
            
            //data -> [Movie]
            let string = String(data: resultData, encoding: .utf8)
            print("search URL Operation Test : \(string)")
//            completion([Movie])
            
        }
        dataTask.resume()
    }
}

// model

struct Movie: Codable {
    
}

struct Response {
    
}
