// 검색 API
import UIKit

class SearchAPI {
    // type method - 인스턴스 생성 없이 .으로 바로 메소드 호출 가능
    // escaping : https://jusung.github.io/Escaping-Closure/ 참조
    
    static func search(_ term: String, completion: @escaping (([Movie]) -> Void)) {
        let session = URLSession(configuration: .default)
        
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entityQuery = URLQueryItem(name: "entity", value: "movie")
        let termQuery = URLQueryItem(name: "term", value: term)
        
        urlComponents.queryItems?.append(mediaQuery)
        urlComponents.queryItems?.append(entityQuery)
        urlComponents.queryItems?.append(termQuery)
        
        let requestURL = urlComponents.url!
        
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            let successRange = 200..<300
            
            // error test code
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
            
            let parsedMoviesInfo = SearchAPI.parseMovies(resultData)
            completion(parsedMoviesInfo)

        }
        dataTask.resume()
    }
    //data -> [Movie]
    // parsing method
    static func parseMovies(_ data: Data) -> [Movie] {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            
            let moviesInfo = response.movies
            return moviesInfo
        } catch let error {
            print("Parsing error: \(error.localizedDescription)")
            return []
        }
    }
}
