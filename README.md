# CustomNetflix

Netflix의 URL을 활용한 넷플릭스 영상 추천 앱 CustomNetflix

#### 사용 기술 및 라이브러리
- Swift, iOS
- URLSession, AVFoundation
- 외부 라이브러리 : Kingfisher(https://github.com/onevcat/Kingfisher), Firebase

-----------
### 개발 일지 (역순)

201019

##### Player View

<img width="527" alt="스크린샷 2021-10-20 00 30 54" src="https://user-images.githubusercontent.com/40759743/137943828-28053a7a-cc4d-411d-9be1-592d15048742.png">

- UIView에 AVPlayerLayer 적용
- Player View 위에 UIView를 씌워 Player controller 기능 이전(재생,멈춤, 닫기 등)
- play:pause 토글 버튼 기능 구현(동영상 재생, 멈춤)
- close 버튼 클릭 때 AVPlayerItem reset 메소드 적용
- URLSession으로부터 파싱된 정보로 PreviewURL 정보 AVPlayer에 전달
~~~Swift
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieInfo = movies[indexPath.item]
        let movieItemURL = URL(string: movieInfo.previewURL)!
        let item = AVPlayerItem(url: movieItemURL)
        
        let PlayerSB = UIStoryboard(name: "Player", bundle: nil)
        let PlayerVC = PlayerSB.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
        PlayerVC.modalPresentationStyle = .fullScreen

        // AVPlayer에 동영상 주소 로드
        PlayerVC.player.replaceCurrentItem(with: item)
        present(PlayerVC, animated: false, completion: nil)
    }
~~~
- 썸네일 클릭 -> View 전환 -> 자동재생

~~~swift
    
    ...

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 자동재생
        play()
    }
    
    ...
    
    func play() {
    
    player.play()
    playBtn.isSelected = ture
   } 
~~~

-----------
211013
##### 1. Thumbnail Image caching 
- Kingfisher 라이브러리를 이용해 URL path에 있는 이미지 캐싱 후 cell의 Image View에 road
- 라이브러리 관련 참조 : https://dev200ok.blogspot.com/2020/09/ios-kingfisher.html

<img width="435" alt="스크린샷 2021-10-20 00 08 34" src="https://user-images.githubusercontent.com/40759743/137938929-8d03d7a4-11e2-41ef-bb48-7cf5676907a2.png">

~~~Swift
 let movieThumb = movies[indexPath.item]
        let thumbnailURL = URL(string: movieThumb.thumbnailPath)
        
        SRCresultsCell.movieThumbnail.kf.setImage(with: thumbnailURL)
        
        // image Load Fail 
        SRCresultsCell.backgroundColor = .systemPink
        
        return SRCresultsCell
~~~

##### 2.Player View 구성

<img width="528" alt="스크린샷 2021-10-20 00 15 13" src="https://user-images.githubusercontent.com/40759743/137940160-09ceeff7-8018-406f-81df-1ab04f17a3ce.png">


- ViewController에 UIView, Play, close Button 배치


~~~Swift
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // collectionView selected -> View 전환
        let PlayerSB = UIStoryboard(name: "Player", bundle: nil)
        let PlayerVC = PlayerSB.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
        
        // modal present fullScreen으로 설정 -> iOS13 이후 디폴트는 하단부 팝업형태
        PlayerVC.modalPresentationStyle = .fullScreen
        present(PlayerVC, animated: false, completion: nil)
    }
~~~

------------

211011
- searchViewController의 Collection View관련 protocol method 작성
- 검색 결과 중, 검색된 자료 수에 따라 cell을 재사용하여 배치 (3줄), 작동 확인을 위하여 Cell의 배경색을 임의로 systemPink로 설정해 test 진행

##### 1. Cell 배치

<img width="427" alt="스크린샷 2021-10-12 02 09 40" src="https://user-images.githubusercontent.com/40759743/136828964-7bda4b0d-af17-4d88-b817-3758e3b1825c.png">
 
 ###### Console Message
![스크린샷 2021-10-12 02 07 23](https://user-images.githubusercontent.com/40759743/136829537-c443c176-8f86-4de2-abe2-0ed130b9cd50.png)
 
##### 2. Search Button Click - 결과에 따른 화면 재구성 부분 main thread에 비동기 처리
> UI관련 업데이트이기 때문에 GCD 프로토콜에 따라 main thread로 비동기 처리
###### Main Thread Checker Error Message
![스크린샷 2021-10-12 00 56 01](https://user-images.githubusercontent.com/40759743/136829833-adb4de96-cbd4-4f69-9b7d-a998ba3661ff.png)

###### Fixed .async

~~~Swift
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        // ....중략
        
        SearchAPI.search(searchTerm) {
            movies in
    
            guard let firstMovieName = movies.first?.title else { return print("검색 결과가 없습니다.")}
            print("넘어온 영화 개수 : \(movies.count), 첫 번째 영화의 이름은 \(firstMovieName) 입니다. ")
            
            // 검색 완료 후 검색된 데이터를 ViewController에 인스턴스로 호출된 Response structure에 넣고 Cell 업데이트 (비동기처리)
          
            DispatchQueue.main.async {
                self.movies = movies
                self.resultCollectionView.reloadData()
            }
        }
        print("search Bar clicked: \(searchTerm) 에 대한 검색이 시작되었습니다.")
    }
~~~

--------------
211007
searchAPI class - Searchterm 구현
> URLSession관련 componenets, query Item 등 URL관련 프로퍼티 구현

<img width="222" alt="스크린샷 2021-10-08 00 07 20" src="https://user-images.githubusercontent.com/40759743/136412211-0ade0096-915f-42c1-8a4d-02a5fe89d19e.png">
- search Bar 키보드 표시 관련 dismissKeyboard 함수 구현


<img width="559" alt="스크린샷 2021-10-08 00 12 00" src="https://user-images.githubusercontent.com/40759743/136413010-f6037e67-bffb-4ed5-9694-58ec1c97135a.png">
- searchTerm - URLSession protocol을 활용한 Data 연동 테스트 -> 검색어 잘 전달되어 내려오는 것을 확인
- 지난 Networking 때 사용한 iTunes URL을 활용해 Test code 작성 (https://github.com/YongJinLeee/networking/blob/main/URLSession_class.playground/Contents.swift)

~~~Swift
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
//            Test 후 Movie 구조체에 맞게 데이터 받아오도록 Codable 함수 작성
            
        }
        dataTask.resume()
    }
}
~~~
-----------
211006

<img width="435" alt="스크린샷 2021-10-07 22 57 15" src="https://user-images.githubusercontent.com/40759743/136399162-a3312e1a-4388-42da-bac5-68d037231a56.png">

Netfilx와 유사한 형태의 tap Bar 화면을 구현하고 가장 먼저 URL 테스트를 진행해야 하므로 searchBar 구현
