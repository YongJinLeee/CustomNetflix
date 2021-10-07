# CustomNetflix

NetFlix의 URL을 활용한 넷플릭스 영상 추천 앱 CustomNetflix

#### 사용 기술 및 라이브러리
- Swift, iOS
- URLSession, AVFoundation
~~~

~~~

-----------
### 개발 일지 (역순)

201007
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
