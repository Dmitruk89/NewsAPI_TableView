//
//  NewsService.swift
//  NewsAPI_TableView
//
//  Created by Mac on 08.12.2023.
//

import Foundation

class NewsService {
    let apiKey: String = Constant.apiKey
    
    func fetchNews(query: String = Constant.defaultQuery, completion: @escaping (NewsResponse?) -> Void){
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(query)&sortBy=popularity&apiKey=\(apiKey)") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error fetching news: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    completion(nil)
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                    if newsResponse.articles.count == 0 {
                        print(Constant.noNewsForTheQuery)
                    }
                    completion(newsResponse)
                } catch {
                    print("Error decoding news: \(error.localizedDescription)")
                    completion(nil)
                }
            }

            task.resume()
    }
}

private extension NewsService {
    enum Constant {
        static let apiKey = "5bb470c44d244ea68261255a8222a824"
        static let defaultQuery = "apple"
        static let noNewsForTheQuery = "Sorry, there are no news for your query!"
    }
}
