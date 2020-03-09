//
//  NewsFeedViewController.swift
//  HotPusuitInstaApp
//
//  Created by Tiffany Obi on 3/9/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class NewsFeedViewController: UIViewController {
    
    @IBOutlet weak var newsFeedCollectionView: UICollectionView!
    
    private var listener: ListenerRegistration?
    private var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                self.newsFeedCollectionView.reloadData()
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        listener = Firestore.firestore().collection(DatabaseService.postsCollection).addSnapshotListener({ [weak self](snapshot, error) in
            if let error = error {
                
                DispatchQueue.main.async {
                    self?.showAlert(title: "Firestore Error (Cannot Retrieve Data)", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map { Post($0.data()) }
//                guard let user = Auth.auth().currentUser else {return}
                self?.posts = posts
                
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsFeedCollectionView.dataSource = self
        newsFeedCollectionView.delegate = self
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        listener?.remove()
    }
    

}

extension NewsFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? NewsFeedCell else {
            fatalError("Could not downcast to NewsFeedCell")
        }
    
        let post = posts[indexPath.row]
        postCell.configureCell(with: post)
        return postCell
    }
    
    
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 340, height: 540)
    }
}
