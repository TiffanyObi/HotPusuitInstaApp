//
//  NewsFeedViewController.swift
//  HotPusuitInstaApp
//
//  Created by Tiffany Obi on 3/9/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    @IBOutlet weak var newsFeedCollectionView: UICollectionView!
    
    var imageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        newsFeedCollectionView.dataSource = self
        newsFeedCollectionView.delegate = self
        
        
    }
    

    

}

extension NewsFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? NewsFeedCell else {
            fatalError("Could not downcast to NewsFeedCell")
        }
    
        postCell.configureCell(with: Post(postID: "", listedDate: Date(), userName: "TestingUsername", userID: "", postText: "Testing Caption TextView", imageURL: nil))
        return postCell
    }
    
    
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 340, height: 540)
    }
}
