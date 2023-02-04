//
//  CoreDataHelper.swift
//  NewsApp
//
//  Created by bjit on 15/1/23.
//

import Foundation
import UIKit
import CoreData


class CoreDataHelper{
    
    
    static let shared = CoreDataHelper()
    
    private init() {
        
        //        self.totalDataCount = APIRequestManager.shared.totalSize
    }
    
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchSize = 10
    var fetchSizeCategory = 5

    var fetchOffset = 0
    var totalDataCount = 140
    var totalDataCountCategory = 20
    
    
    /*
     - storeNewFetchedDataAll()*
     
     - getAllData()*
     
     - getAllBookmarkedData()*
     
     - setAllBookmarkedDataIntoMain()*
     
     - removeAllData()*
     
     - getNextSerial()*
     
     - appendNewBookmarkedData()*
     
     - deleteBookmarkedData(at)*
     
     - removeBookmarkFromMain(url)*
     
     - getDataCatergoryWise(category)*
     
     - getSearchDataCategoryWise(searchText)*
     
     - getSearchDataAll()*
     
     - getSearchBookmarkedData(searchText)*
     
     - setBookmark(url)*
     
     - getAllDataExceptBookmarked()
     
     - appendNewFetchDataAll()
     
     - storeNewFetchedData(category)
     
     - appendNewFetchData(category)
     
     - getAllDataPagination()
     
     - getAllDataPagination(category)
     
     
     */
    
    func setBookmark(bookmarkedId: String)
    {
        guard let result = CoreDataHelper.shared.getAllData() else { return }
        
        for x in result{
            if x.id == bookmarkedId{
                
                //                print("Bookmark seted: \(x.id)")
                x.bookmarked = true
                let item = BookmarkedArticle(context: context)
                item.author = x.author
                item.category = x.category
                item.content = x.content
                item.desc = x.desc
                item.id = x.id
                item.publishedAt = x.publishedAt
                item.source = x.source
                item.title = x.title
                item.url = x.url
                item.urlToImage = x.urlToImage
                break
            }
        }
        
        do{
            try context.save()
            
        }
        catch{
            print("Error: setBookmark()")
        }
    }
    
    
    
    func getSearchBookmarkedDataAll(searchText: String) -> [BookmarkedArticle]?
    {
        let fetchRequest = NSFetchRequest<BookmarkedArticle>(entityName: "BookmarkedArticle")
        let predicate = NSPredicate(format: "title CONTAINS[c] %@", searchText)
        fetchRequest.predicate = predicate
        
        var result = [BookmarkedArticle]()
        
        do {
            result = try context.fetch(fetchRequest)
            
            return result
        } catch {
            print(error)
            return nil
        }
    }
    
    
    func getSearchDataAll(searchText: String) -> [Article]?{
        let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
        let predicate = NSPredicate(format: "title CONTAINS[c] %@", searchText)
        fetchRequest.predicate = predicate
        
        var result = [Article]()
        
        do {
            result = try context.fetch(fetchRequest)
            
            return result
        } catch {
            print(error)
            return nil
        }
    }
    
    func getSearchDataCategoryWise(searchText: String, category: String) -> [Article]?
    {
        
        let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
        let predicate = NSPredicate(format: "category == %@ AND title CONTAINS[c] %@", category, searchText)
        fetchRequest.predicate = predicate
        
        var result = [Article]()
        
        do {
            result = try context.fetch(fetchRequest)
            
            return result
        } catch {
            print(error)
            return nil
        }
    }
    
    func getSearchBookmarkedDataCategoryWise(searchText: String, category: String) -> [BookmarkedArticle]?
    {
        let fetchRequest = NSFetchRequest<BookmarkedArticle>(entityName: "BookmarkedArticle")
        let predicate = NSPredicate(format: "category == %@ AND title CONTAINS[c] %@", category, searchText)
        fetchRequest.predicate = predicate
        
        var result = [BookmarkedArticle]()
        
        do {
            result = try context.fetch(fetchRequest)
            
            return result
        } catch {
            print(error)
            return nil
        }
    }
    
    func getBookmarkedDataCatergoryWise(category: String) -> [BookmarkedArticle]?{
        
        let fetchRequest = NSFetchRequest<BookmarkedArticle>(entityName: "BookmarkedArticle")
        let predicate = NSPredicate(format: "category == %@", category)
        fetchRequest.predicate = predicate
        
        var result = [BookmarkedArticle]()
        
        do {
            result = try context.fetch(fetchRequest)
            
            return result
        } catch {
            print(error)
            return nil
        }
    }
    
    func getDataCatergoryWise(category: String, offset: Int) -> [Article]?{
        
        var result = [Article]()
        if offset < self.totalDataCountCategory{
            
            
            let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
            fetchRequest.fetchLimit = self.fetchSizeCategory
            fetchRequest.fetchOffset = offset
            let predicate = NSPredicate(format: "category == %@", category)
            fetchRequest.predicate = predicate
            
            do {
                result = try context.fetch(fetchRequest)
                
                return result
            } catch {
                print(error)
                return nil
            }
            
        }
        
        return []
    }
    
    
    
    
    func removeBookmarkFromMain(id: String)
    {
        guard let results = CoreDataHelper.shared.getAllData() else { return }
        
        var item: Article? = nil
        
        for x in results{
            
            if x.id == id {
                item = x
                break
            }
        }
        
        if item != nil{
            item?.bookmarked = false
            
            do{
                
                try context.save()
            }
            catch{
                print("Error: In removeBookmarkFromMain()")
            }
        }
        
    }
    
    func deleteBookmarkedData(at: IndexPath)
    {
        guard let bookmarkList = CoreDataHelper.shared.getAllBookmarkedData() else
        {
            return
        }
        
        let item = bookmarkList[at.row]
        
        CoreDataHelper.shared.removeBookmarkFromMain(id: item.url!)
        
        do{
            
            context.delete(item)
            try context.save()
        }
        catch{
            print("Error: In deleteBookmarkedData()")
        }
        
    }
    
    
    func appendNewBookmarkedData(bookmarkedArticle: BookmarkedArticleModel, article: Article){
        if article.bookmarked == false{
            
            let bArticle = BookmarkedArticle(context: context)
            
            
            bArticle.id = bookmarkedArticle.id
            bArticle.author = bookmarkedArticle.author
            bArticle.category = bookmarkedArticle.category
            bArticle.content = bookmarkedArticle.content
            bArticle.desc = bookmarkedArticle.desc
            bArticle.publishedAt = bookmarkedArticle.publishedAt
            bArticle.source = bookmarkedArticle.source
            bArticle.title = bookmarkedArticle.title
            bArticle.url = bookmarkedArticle.url
            bArticle.urlToImage = bookmarkedArticle.urlToImage
            
            article.bookmarked = true
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
    }
    
    
    
    
    func setAllBookmarkedDataIntoMain()
    {
        
        guard let results = getAllData() else {
            
            print("Error: setAllBookmarkedDataIntoMain()")
            return
            
        }
        var bookmarkedUrls = [String]()
        var fetchedBookmarkedData = [BookmarkedArticle]()
        var fetchedData = results
        
        if let resultsBookmarked = getAllBookmarkedData() {
            
            
            if resultsBookmarked.count != 0 {
                
                fetchedBookmarkedData = resultsBookmarked
                
                for x in fetchedBookmarkedData{
                    bookmarkedUrls.append(x.url!)
                }
                
                for (i,_) in fetchedData.enumerated(){
                    
                    if bookmarkedUrls.contains(fetchedData[i].url!){
                        fetchedData[i].bookmarked = true
                    }
                }
                
                do{
                    try context.save()
                }
                catch{
                    print("Error: In setAllBookmarkedDataIntoMain()")
                }
            }
            else
            {
                print("Acknowledge: No bookmarks")
                
            }
        }
        else
        {
            print("Error: No bookmarks table")
            
        }
        
    }
    
    func getAllBookmarkedData() -> [BookmarkedArticle]?{
        var result = [BookmarkedArticle]()
        
        do{
            let fetchRequest = NSFetchRequest<BookmarkedArticle>(entityName: "BookmarkedArticle")
            result = try context.fetch(fetchRequest)
            return result
        }
        catch {
            print("Error: getAllBookmarkedData()")
            return nil
        }
        
    }
    
    func getAllData(offset: Int) -> [Article]?{
        
        
        print("Position: getAllData(offset) offset:\(offset) totalSize:\(totalDataCount)")
        var result = [Article]()
        
        do{
            if offset < totalDataCount{
                let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
                fetchRequest.fetchLimit = self.fetchSize
                fetchRequest.fetchOffset = offset
                result = try context.fetch(fetchRequest)
                
            }
            return result
            
        }
        catch {
            print("Error: In getAllData()")
            return nil
        }
        
        
    }
    
    func getAllData() -> [Article]?{
        
        var result = [Article]()
        
        do{
            let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
            result = try context.fetch(fetchRequest)
            return result
            
        }
        catch {
            print("Error: In getAllData()")
            return nil
        }
        
    }
    
    func removeAllData(){
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "Article")
        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )
        
        deleteRequest.resultType = .resultTypeObjectIDs
        
        do{
            
            let batchDelete = try context.execute(deleteRequest)
            as? NSBatchDeleteResult
            guard let deleteResult = batchDelete?.result
                    as? [NSManagedObjectID]
            else { return }
            
            let deletedObjects: [AnyHashable: Any] = [
                NSDeletedObjectsKey: deleteResult
            ]
            
            // Merge the delete changes into the managed
            // object context
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: deletedObjects,
                into: [context]
            )
        }
        catch{
            print("Error: In removeAllData()")
            
        }
        
    }
    
    
    func storeNewFetchedDataAll(articles: [ArticleModel], category: String){
        
        
        var tempCount: Int64
        
        if let count = getNextSerial(){
            tempCount = count
        }
        else
        {
            tempCount = 0
        }
        
        for x in articles{
            
            tempCount += 1
            let item = Article(context: context)
            
            item.serialNo = tempCount
            item.id = x.url
            item.author = x.author
            item.category = category
            item.content = x.content
            item.desc = x.description
            item.publishedAt = x.publishedAt
            item.source = x.source?.name
            item.title = x.title
            item.url = x.url
            item.urlToImage = x.urlToImage
            item.bookmarked = false
            
            do{
                try context.save()
            }
            catch{
                print("Error: In storeNewFetchedDataAll()")
            }
        }
        
        
    }
    
    func getNextSerial() -> Int64?{
        let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
        let predicate = NSPredicate(format: "serialNo == max(serialNo)")
        fetchRequest.predicate = predicate
        
        var maxSerialNo: Int64? = nil
        do{
            
            let result = try context.fetch(fetchRequest).first
            maxSerialNo = result?.serialNo
            
        }
        catch{
            print("Error: Int getNextSerial()")
        }
        
        return maxSerialNo
        
        
    }
}
