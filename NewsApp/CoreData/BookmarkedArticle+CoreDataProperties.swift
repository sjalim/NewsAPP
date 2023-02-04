//
//  BookmarkedArticle+CoreDataProperties.swift
//  NewsApp
//
//  Created by bjit on 16/1/23.
//
//

import Foundation
import CoreData


extension BookmarkedArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkedArticle> {
        return NSFetchRequest<BookmarkedArticle>(entityName: "BookmarkedArticle")
    }

    @NSManaged public var author: String?
    @NSManaged public var category: String?
    @NSManaged public var content: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var source: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}

extension BookmarkedArticle : Identifiable {

}
