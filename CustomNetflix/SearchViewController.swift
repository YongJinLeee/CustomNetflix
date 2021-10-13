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
import Kingfisher

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    //  MVVM 패턴 하에서는 View Model에서 Model을 가져오는게 맞지만.. 일단 초기화를 위해
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 키보드 호출 감지
//        NotificationCenter.default.addObserver(self, selector: #selector(adjstInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
}

// CollectionView
extension SearchViewController: UICollectionViewDelegate {
    
    // 검색 결과 Click -> 동영상 플레이어 ViewCon
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieItem = movies[indexPath.item]
    }
    
}

extension SearchViewController: UICollectionViewDataSource {
    
    // 데이터 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    // 표현 방식
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let SRCresultsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultsCell", for: indexPath) as? SearchResultsCell else {
            return UICollectionViewCell()
        }
        
        //kingfisher 사용해 이미지 넣기
        let movieThumb = movies[indexPath.item]
        let thumbnailURL = URL(string: movieThumb.thumbnailPath)
        
        SRCresultsCell.movieThumbnail.kf.setImage(with: thumbnailURL)
        
//         if : image Load Fail
        SRCresultsCell.backgroundColor = .systemPink
        
        return SRCresultsCell
    }
    
}

class SearchResultsCell: UICollectionViewCell {
    @IBOutlet weak var movieThumbnail: UIImageView!
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 8
        let itemSpacing: CGFloat =  10
        
        let width: CGFloat = (collectionView.bounds.width - (margin * 2) - (itemSpacing * 2)) / 3
        
        // 포스터 비율 7:10
        let height: CGFloat = (width / 7) * 10
        
        return CGSize(width: width, height: height)
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
        
        SearchAPI.search(searchTerm) {
            movies in
            // 옵셔널 바인딩 -> data 단위에서 전체적으로 처리할 수 없을까?
            guard let firstMovieName = movies.first?.title else { return print("검색 결과가 없습니다.")}
            print("넘어온 영화 개수 : \(movies.count), 첫 번째 영화의 이름은 \(firstMovieName) 입니다. ")
            
            // 검색 완료 후 검색된 데이터를 ViewController에 인스턴스로 호출된 Response structure에 넣고 Cell 업데이트 (비동기처리)
          
            DispatchQueue.main.async {
                self.movies = movies
                self.resultCollectionView.reloadData()
            }
        }
        print("search Bar clicked: \(searchTerm) 에 대한 검색이 시작되었습니다.")
        // 옵셔널 바인딩 되었으므로 콘솔 확인 searchBar.text -> searchTerm으로 변경
    }
    
}

// model

struct Movie: Codable {
    let title: String
    let director: String
    let thumbnailPath: String
    let previewURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case director = "artistName"
        case thumbnailPath = "artworkUrl100"
        case previewURL = "previewUrl"
    }
}

struct Response: Codable {
    let resultCount: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case movies = "results"
    }
}
