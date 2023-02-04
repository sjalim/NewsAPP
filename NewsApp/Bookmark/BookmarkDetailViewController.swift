//
//  BookmarkDetailViewController.swift
//  NewsApp
//
//  Created by bjit on 17/1/23.
//

import UIKit

class BookmarkDetailViewController: UIViewController {

    @IBOutlet weak var categoryLbl: UILabel!
    

    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var contentLbl: UILabel!

    
    var item : BookmarkedArticle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let article = item else { return }
        
        
        categoryLbl.text = article.category?.uppercased()
        titleLbl.text = article.title
        imgView.layer.cornerRadius = 20
        imgView.sd_setImage(with: URL(string: article.urlToImage ?? ""), placeholderImage: UIImage(named: "placeholderNews.jpg"))
        
        descLbl.attributedText = Utilities.shared.attributedText(withString: article.desc)
        
        contentLbl.text = article.content
    }
    

    @IBAction func continueReadTapped(_ sender: Any) {
        
        
        performSegue(withIdentifier: Constants.segueIdentifierBookmarkedWebView, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == Constants.segueIdentifierBookmarkedWebView) {
            
            if let dest = segue.destination as? BookmarkWebViewController{
                
                guard let url = item?.url else { return }
                
                
                dest.urlString = url
            }
        }
    }
    
    
}
