//
//  BookmarkCollectionViewCell.swift
//  NewsApp
//
//  Created by bjit on 13/1/23.
//

import UIKit

class BookmarkCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var categoryLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.configView()
    }
    
    private func configView() {
        self.clipsToBounds = false
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.2
    }
//    override func prepareForReuse() {
//
//        containerView.backgroundColor = .black
//        categoryLbl.textColor = .white
//    }


}
