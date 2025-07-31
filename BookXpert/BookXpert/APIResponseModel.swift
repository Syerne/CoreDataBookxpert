//
//  APIResponseModel.swift
//  BookXpert
//
//  Created by Shubham  Yerne on 29/07/25.
//

import Foundation
import UIKit
import SwiftUI

struct APIResponseModel: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}

struct Source: Codable {
    let name: String
}




