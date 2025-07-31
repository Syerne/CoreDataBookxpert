//
//  ArticleDetail+CoreDataProperties.swift
//  BookXpert
//
//  Created by Shubham  Yerne on 31/07/25.
//
//

import Foundation
import CoreData


extension ArticleDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleDetail> {
        return NSFetchRequest<ArticleDetail>(entityName: "ArticleDetail")
    }

    @NSManaged public var newsDetail: Data?
    @NSManaged public var id: String?

}

extension ArticleDetail : Identifiable {

}
