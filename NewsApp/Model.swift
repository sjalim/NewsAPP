//
//  Model.swift
//  NewsApp
//
//  Created by bjit on 14/1/23.
//

import Foundation


struct CoreDataArticle{
    
    let source: String
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    let category: String
    let bookmarked: Bool
}

struct BookmarkedArticleModel{
    let author: String?
    let category: String
    let content: String?
    let desc: String?
    let id: String?
    let publishedAt: String?
    let source: String?
    let title: String?
    let url: String?
    let urlToImage: String?
    
}


struct Source: Encodable, Decodable{
    
    let id : String?
    let name: String?
}

struct ArticleModel: Encodable, Decodable{
    
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
}

struct ApiResposeModel : Encodable, Decodable{
    
    let status: String
    let totalResults: Int
    let articles: [ArticleModel]
}
