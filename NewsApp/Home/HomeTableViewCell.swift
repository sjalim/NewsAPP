//
//  HomeTableViewCell.swift
//  NewsApp
//
//  Created by bjit on 12/1/23.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bookmarkImgView: UIImageView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var authorLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
