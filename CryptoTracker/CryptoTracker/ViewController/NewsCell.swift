//
//  NewsCell.swift
//  CryptoTracker
//
//  Created by Alexander Schüßling on 05.06.19.
//  Copyright © 2019 UTS. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsSource: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    func configureCell( newsTitle: String, newsSource: String) {
        //    self.newsImage.image = newsImage
        self.newsTitle.text = newsTitle
        self.newsSource.text = newsSource
    }
    
}
