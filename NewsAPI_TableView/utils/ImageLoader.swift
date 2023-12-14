//
//  ImageLoader.swift
//  NewsAPI_TableView
//
//  Created by Mac on 14.12.2023.
//

import Foundation
import UIKit

class ImageLoader {
    static let shared = ImageLoader()

    private init() {}

    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
