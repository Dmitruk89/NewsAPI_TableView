//
//  MockNewsApi.swift
//  NewsAPI_TableViewTests
//
//  Created by Руковичников Дмитрий on 6.01.24.
//

import Foundation
@testable import NewsAPI_TableView

class MockNewsApi {
    
    var shouldReturnError = false
    var fetchNewsWasCalled = false
    
    convenience init(){
        self.init(false)
    }
    
    init(_ shouldReturnError: Bool){
        self.shouldReturnError = shouldReturnError
    }
    
//    let mockNewsApiResponse: [String: Any] = [
//        "articles": [
//          [
//            "author": "Author 1",
//            "title": "Article Title 1",
//            "description": "Description 1",
//            "url": "https://example.com/article1",
//            "urlToImage": "https://example.com/image1.jpg",
//            "publishedAt": "2023-01-01T12:34:56Z",
//            "content": "Content 1"
//          ],
//          [
//            "author": "Author 2",
//            "title": "Article Title 2",
//            "description": "Description 2",
//            "url": "https://example.com/article2",
//            "urlToImage": "https://example.com/image2.jpg",
//            "publishedAt": "2023-01-02T08:45:12Z",
//            "content": "Content 2"
//          ]
//        ]
//      ]
    
    enum MockServiceError: Error {
        case fetchNews
    }
    
    func reset(){
        shouldReturnError = false
        fetchNewsWasCalled = false
    }
}

extension MockNewsApi: NewsServiceProtocol {
    func fetchNews(query: String, completion: @escaping (NewsResponse?, Error?) -> Void){
        fetchNewsWasCalled = true;
        
        if shouldReturnError {
            completion(nil, MockServiceError.fetchNews)
        } else {
            do {
                if let path = Bundle.main.path(forResource: "news_response", ofType: "json"),
                   let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    let decoder = JSONDecoder()
                    let mockNewsApiResponse = try decoder.decode(NewsResponse.self, from: data)
                    completion(mockNewsApiResponse, nil)
                }
            } catch {
                completion(nil, error)
                
            }
        }
    }
}
