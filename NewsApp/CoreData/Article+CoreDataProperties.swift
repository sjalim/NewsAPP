//
//  Article+CoreDataProperties.swift
//  NewsApp
//
//  Created by bjit on 16/1/23.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var author: String?
    @NSManaged public var bookmarked: Bool
    @NSManaged public var category: String?
    @NSManaged public var content: String?
    @NSManaged public var desc: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var id: String?
    @NSManaged public var source: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var serialNo: Int64

}

extension Article : Identifiable {

}
