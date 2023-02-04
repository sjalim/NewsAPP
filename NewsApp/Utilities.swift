//
//  Utilities.swift
//  NewsApp
//
//  Created by bjit on 15/1/23.
//

import Foundation
import UIKit


class Utilities{
    
    
    static let shared = Utilities()
    
    private init(){}
    
    
    func setLastFetchedTime(){
        
        let date = Date()
        UserDefaults.standard.set(date, forKey: Constants.LastFetchedTime)
        
    }
    
    func getLastFetchedTime() -> Date?{
        
        
        guard let date = UserDefaults.standard.object(forKey: Constants.LastFetchedTime)
        else{
            return nil
        }

        return date as? Date
        
    }
    
    func getLastFetchedTimeIntervalInMin() -> Double{
        
        guard let lastFetchedTime = Utilities.shared.getLastFetchedTime() else
        {
            print("Error: getLastFetchedTimeIntervalInMin()")
            return 0.0
        }
        
        let intervalInSecs = Date()  - lastFetchedTime
        
        return intervalInSecs/60
    }
    
    func formattedDate(date: String) -> String{
        if date != ""{
            
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        
        let newDate =  dateFormatter.date(from: date)!
        
        dateFormatter.dateFormat = "dd MMM yyy"
        
       let newDateString = dateFormatter.string(from: newDate)
        
        return newDateString
        }
        else
        {
            return ""
        }
    }
    
    func attributedText(withString: String?) -> NSAttributedString {
        
        guard let str = withString else { return NSMutableAttributedString(string: "") }
        
        let myMutableString = NSMutableAttributedString(string: str)
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.italicSystemFont(ofSize: 50), range: NSRange(location: 0, length: 1))
        
        return myMutableString
    }
    
    
}


extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
