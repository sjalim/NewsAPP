//
//  Constants.swift
//  NewsApp
//
//  Created by bjit on 13/1/23.
//

import Foundation


class Constants{
    
    static let shared = Constants()
    
    private init(){}
    
    static let segueIdentifierHomeDetail = "gotoHomeDetail"
    
    
    static let segueIdentifierBookmarkDetail = "gotoBookmarkDetail"
    
    static let segueIdentifierHomeWebView = "gotoHomeWebView"
    
    static let segueIdentifierBookmarkedWebView = "gotoBookmarkedWebView"
    
    
    static let HomeTableViewCell = "HomeTableViewCell"
    static let BookmarkTableViewCell = "BookmarkTableViewCell"
    static let HomeCollectionViewCell = "HomeCollectionViewCell"
    static let BookmarkCollectionViewCell = "BookmarkCollectionViewCell"
    static let LoaderTableViewCell = "LoaderTableViewCell"
    static var categories = ["All", "Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]
    
    static let Business = "business"
    static let Entertainment = "entertainment"
    static let General = "general"
    static let Health = "health"
    static let Science = "science"
    static let Sports = "sports"
    static let Technology = "technology"
    static let CurrentTime = "currentTime"
    static let LastFetchedTime = "lastFetchedTime"
    
//    static let newsApiUrlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=b2565b42cdba4b8aa5f687bfc6e79a5c"
    
    static let newsApiUrlString = "https://newsapi.org/v2/top-headlines"
    
    func newsCategoryApiUrlString(cateogy: String) -> String{
        "https://newsapi.org/v2/top-headlines?country=us&category=\(cateogy)&apiKey=b2565b42cdba4b8aa5f687bfc6e79a5c"
    }
    
    
    
//    static func timoutFetchData(){
//
//    }
}
