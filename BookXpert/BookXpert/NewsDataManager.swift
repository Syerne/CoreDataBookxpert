//
//  NewsDataManager.swift
//  BookXpert
//
//  Created by Shubham  Yerne on 31/07/25.
//

import Foundation
import CoreData
import UIKit

class NewsDataManager {

    static let shared = NewsDataManager()

    // MARK: - Core Data Context
    private let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to get AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }()

    // MARK: - Save or Update
    func saveOrUpdate(newsData: Data, with identifier: String) {
        if let existingArticle = fetchArticle(by: identifier) {
            existingArticle.newsDetail = newsData
            print("Updating existing article")
        } else {
            let newArticle = ArticleDetail(context: context)
            newArticle.setValue(identifier, forKey: "id") // Make sure your model has an 'id' attribute
            newArticle.newsDetail = newsData
            print("Creating new article")
        }

        saveContext()
    }

    // MARK: - Retrieve
    func retrieveNewsData(by identifier: String) -> Data? {
        guard let article = fetchArticle(by: identifier) else { return nil }
        return article.newsDetail
    }

    // MARK: - Delete
    func deleteNewsData(by identifier: String) {
        guard let article = fetchArticle(by: identifier) else { return }
        context.delete(article)
        saveContext()
        print("Article deleted")
    }

    // MARK: - Private Helper
    private func fetchArticle(by identifier: String) -> ArticleDetail? {
        let request: NSFetchRequest<ArticleDetail> = ArticleDetail.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", identifier)
        request.fetchLimit = 1

        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Fetch error: \(error)")
            return nil
        }
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}
