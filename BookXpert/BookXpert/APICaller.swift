//
//  APICaller.swift
//  BookXpert
//
//  Created by Shubham  Yerne on 29/07/25.
//


import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
//    https://newsapi.org/v2/everything?q=apple&from=2025-07-28&to=2025-07-28&sortBy=popularity&apiKey=

    struct Constants {
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=d42ed1a77aea4bb19427feea55c321ae")
        static let searchUrlString = "https://newsapi.org/v2/everything?q=apple&from=2025-07-28&to=2025-07-28&sortBy=popularity&apiKey=d42ed1a77aea4bb19427feea55c321ae&q="
    }
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadLinesURL else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(APIResponseModel.self, from: data)
                DispatchQueue.main.async {
                    NewsDataManager.shared.saveOrUpdate(newsData: data, with: "transformableCoreData")
                }
                completion(.success(result.articles))
                
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(APIResponseModel.self, from: data)
                completion(.success(result.articles))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}


