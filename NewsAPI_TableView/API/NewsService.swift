//
//  NewsService.swift
//  NewsAPI_TableView
//
//  Created by Mac on 08.12.2023.
//

import Foundation

class NewsService {
    let apiKey: String = "5bb470c44d244ea68261255a8222a824"
    let apiUrl: String = "https://newsapi.org/v2/everything?q=apple&sortBy=publishedAt&apiKey="
    
    func fetchNews(completion: @escaping (NewsResponse?) -> Void){
        guard let url = URL(string: "\(apiUrl)\(apiKey)") else {
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
                    completion(newsResponse)
                } catch {
                    print("Error decoding news: \(error.localizedDescription)")
                    completion(nil)
                }
            }

            task.resume()
    }
}
