//
//  NewsFeedCell.swift
//  HotPusuitInstaApp
//
//  Created by Tiffany Obi on 3/9/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import Kingfisher

class NewsFeedCell: UICollectionViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postTextView: UITextView!
    
    
    
    public func configureCell(with details: Post) {
        
        userNameLabel.text = "@\(details.userName)"
        
        postImageView.kf.setImage(with: URL(string: details.imageURL ?? ""))
        
        postTextView.text = details.postText
    }
}
