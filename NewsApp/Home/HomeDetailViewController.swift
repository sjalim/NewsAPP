//
//  HomeDetailViewController.swift
//  NewsApp
//
//  Created by bjit on 17/1/23.
//

import UIKit

class HomeDetailViewController: UIViewController {

    var item: Article?
    
    @IBOutlet weak var categoryLbl: UILabel!
    
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var contentLbl: UILabel!
    
    
    var isBookmarked: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        guard let article = item else { return }

        categoryLbl.text = article.category?.uppercased()
        titleLbl.text = article.title
        imgView.layer.cornerRadius = 20
        imgView.sd_setImage(with: URL(string: article.urlToImage ?? ""), placeholderImage: UIImage(named: "placeholderNews.jpg"))
        
        descLbl.attributedText = Utilities.shared.attributedText(withString: article.desc)
        
        contentLbl.text = article.content
        
        isBookmarked = article.bookmarked
        
        if article.bookmarked == true {
            bookmarkBtn.tintColor = UIColor(named: "GreenColor")
        }
        else
        {
            bookmarkBtn.tintColor = UIColor(named: "CustomGreyColor")

        }
        
    }
    
    @IBAction func continueReadTapped(_ sender: Any) {
        
        performSegue(withIdentifier: Constants.segueIdentifierHomeWebView, sender: nil)

    }
    
    @IBAction func bookmarkBtnTapped(_ sender: Any) {
        
        guard let item = item else { return }
        
        guard let id = item.id else { return }
        
        if isBookmarked == false{
            
            bookmarkBtn.tintColor = UIColor(named: "GreenColor")
            CoreDataHelper.shared.setBookmark(bookmarkedId: id)
            isBookmarked = true

        }
        else
        {
            let alert = UIAlertController(title: "Alert!", message: "News already added to bookmark", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .cancel)
            alert.addAction(closeAction)
            present(alert, animated: true)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == Constants.segueIdentifierHomeWebView) {
            
            if let dest = segue.destination as? HomeWebViewController{
                
                guard let url = item?.url else { return }
                
                
                dest.urlString = url
            }
        }
    }
    

}
