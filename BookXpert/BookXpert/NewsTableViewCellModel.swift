//
//  NewsTableViewCellModel.swift
//  BookXpert
//
//  Created by Shubham  Yerne on 29/07/25.
//

import Foundation

class NewsTableViewCellModel {
    
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(title: String, subtitle: String, imageURL: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}
