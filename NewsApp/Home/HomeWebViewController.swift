//
//  HomeWebViewController.swift
//  NewsApp
//
//  Created by bjit on 17/1/23.
//

import UIKit
import WebKit

class HomeWebViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    
    
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: urlString) else { return }
        
        webView.load(URLRequest(url:url))
        
    }
    


}
