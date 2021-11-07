# CustomNetflix

Netflix의 URL을 활용한 넷플릭스 영상 추천 앱 CustomNetflix

#### 사용 기술 및 라이브러리
- Swift, iOS
- 주사용 모듈 및 클래스 : URLSession, AVFoundation, Storyboard 기반
- 외부 라이브러리 : Kingfisher(https://github.com/onevcat/Kingfisher), Firebase(realtime DB)

-----------
### 개발 일지 (역순)

211108
Firebase RT DB 이식 및 

-----------
211102

##### Target errors
![스크린샷 2021-11-03 01 48 39](https://user-images.githubusercontent.com/40759743/139911584-7eb92565-95f7-4d61-84d8-433f086f5640.png)


1. Kingfisher의 최소 타겟은 iOS 12.0이고
2. SceneDelegate를 이용해 앱의 UI Lifecycle과 AppDelegate의 Process Lifecycle을 분리 설계하는 디자인 패턴은 iOS 13 부터 사용할 수 있다

> UIScene 관련 참조
2019WWDC Scene 설명 영상(https://developer.apple.com/videos/play/wwdc2019/212/)

<img width="828" alt="스크린샷 2021-11-03 02 01 30" src="https://user-images.githubusercontent.com/40759743/139911424-bdf56562-3237-412f-8197-a2042b8074f2.png">

- 멀티태스킹, 스플릿뷰 와 같이 한 앱이 서로 다른 씬을 갖는 것이 가장 대표적인 가능 사례. (메모앱 동시 스플릿뷰 사용 가능)


-----------
211027
##### Firebase
1. m1과 cocoapods..
cocoapods로 Firebase를 붙이는 과정에서 처음 겪는 문제를 맞닥 뜨렸다.

네이버 로그인 SDK, RealmSwift 같은 외부라이브러리나 SDK설치 하면서 한번도 본 적 없는 에러가 수백줄이 뜨니 당황스러웠다.

~~~
// 터미널 Console에 뜬 message

 See Crash Report log file under the one of following:                    
     * ~/Library/Logs/DiagnosticReports                                     
     * /Library/Logs/DiagnosticReports                                      
   for more details.                
~~~


> 해결은 역시 구글신. 🤗 😂

cocoapods Github repo의 issue에서 답을 찾을 수 있었다. 
(https://github.com/CocoaPods/CocoaPods/issues/10446 / https://github.com/CocoaPods/CocoaPods/issues/10446#issuecomment-783412450)
> 에러코드를 천천히 훑어보니 아키텍쳐에 대한 이야기가 많이 나왔고, 애플실리콘 M1을 탑재한 모델들에서 발생하는 문제로 알려져음
 
~~~
// 아키텍쳐 x86으로 변경해 cocoapods 재설치
sudo arch -arch x86_64 gem install cocoapods

arch -arch x86_64 pod install or other command
~~~
- 기존 Intel CPU에서 작동하던 Ruby와 cocoapods의 문제였고, Rosetta2와 아키텍쳐 변경으로 우회적인 방법을 사용해 실행하게 되는 것
- M1 칩 제품이 출시된지 1년이 넘었는데 ARM에서 충돌 없이 기본적으로 잘 실행되는 방법이 있지 않을까? 더 찾아봐야할 문제.
- github.io 블로그 관리를 위해 Jeykll 편집을 할 때도 MacOS 기본으로 깔려있는 Ruby 2.6.8가 M1과 충돌이 생겨 굳이굳이 2.7.2로 새로 설치 뒤 다시 받아서 해결했던 기억이 있다.
 
2. iOS targeting 문제
- 위의 방법으로 cocoapods의 동작문제는 해결했지만 install을 하니 콘솔에 다음과 같은 메시지가 떴다
~~~
[!]Automatically assigning platform `iOS` with version `14.5` on target `CustomNetflix` because no platform was specified. Please specify a platform for this target in your Podfile. See `https://guides.cocoapods.org/syntax/podfile.html#platform`.
~~~ 

~~~
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CustomNetflix' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CustomNetflix
  pod 'Firebase/Analytics'

end
~~~
> Podfile에 주석처리가 되어있는 부분 때문에 타겟 버전관련 이슈발생 -> 해제, 버전 변경으로 해결

3. 터미널의 동작 방식을 'Rosetta로 열기' 로 설정하고, cocoapods와 ffi 재설치 후 irebase 설치 성공

<img width="633" alt="스크린샷 2021-10-27 18 13 56" src="https://user-images.githubusercontent.com/40759743/139036994-00e88775-28e9-4767-aeda-b379d7123865.png">

참조
- https://github.com/CocoaPods/CocoaPods/issues/10220
- https://ondemand.tistory.com/340
-----------
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
