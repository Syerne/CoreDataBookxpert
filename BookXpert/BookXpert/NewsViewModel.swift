//
//  NewsViewModel.swift
//  BookXpert
//
//  Created by Shubham  Yerne on 29/07/25.
//

import Foundation
import CoreData

protocol NewsViewModelProtocol: AnyObject {
    func reloadData()
}


class NewsViewModel {
    var newsArray = [NewsTableViewCellModel]()
    var articles = [Article]()
    
    weak var delegate: NewsViewModelProtocol?
    
    var bool: Bool = false
    
    init() {
        
    }
    
    func fetchTopBusinessNews() {
        if self.bool == true {
            let data =  NewsDataManager.shared.retrieveNewsData(by: "transformableCoreData")
            do {
                let result = try JSONDecoder().decode(APIResponseModel.self, from: data ?? Data())
                self.articles = result.articles
                self.newsArray = articles.compactMap({ NewsTableViewCellModel(title: $0.title, subtitle: $0.description ?? "No Description", imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self.delegate?.reloadData()
                }
            } catch {
                print("Failed to decode articles: \(error)")
            }
           
            return
        }
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.bool = true
                self?.articles = articles
                self?.newsArray = articles.compactMap({ NewsTableViewCellModel(title: $0.title, subtitle: $0.description ?? "No Description", imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.delegate?.reloadData()
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchNews(with query: String) {
        guard !query.isEmpty else { return }
        APICaller.shared.search(with: query) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.newsArray = articles.compactMap({ article in NewsTableViewCellModel(title: article.title, subtitle: article.description ?? "No Description", imageURL: URL(string: article.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.delegate?.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func filterArticlesLocally(by query: String) {
        if query.isEmpty {
            // Show all articles
            newsArray = articles.map {
                NewsTableViewCellModel(
                    title: $0.title,
                    subtitle: $0.description ?? "No Description",
                    imageURL: URL(string: $0.urlToImage ?? "")
                )
            }
        } else {
            // Filter based on title (or description)
            let filtered = articles.filter {
                $0.title.lowercased().contains(query.lowercased())
            }
            newsArray = filtered.map {
                NewsTableViewCellModel(
                    title: $0.title,
                    subtitle: $0.description ?? "No Description",
                    imageURL: URL(string: $0.urlToImage ?? "")
                )
            }
        }
        
        DispatchQueue.main.async {
            self.delegate?.reloadData() // 🔁 this triggers the tableView to reload
        }
    }
    
}
