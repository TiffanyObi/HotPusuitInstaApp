//
//  DatabaseService.swift
//  HotPusuitInstaApp
//
//  Created by Tiffany Obi on 3/9/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    
    static let postsCollection = "post" // convention is using lowercase - we make a static let to prevent misspelling.
    
    
    //get a reference to the Firebsae Firestore database
    private let database = Firestore.firestore()
    
    public func createItem(userName: String,postText: String, completion: @escaping (Result<String, Error>) ->()) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        //generate a document ID for the item collection - note that document could ANYTHING you make it
        
        let documentRef = database.collection(DatabaseService.postsCollection).document()
        
        //create a document in our posts collection
        database.collection(DatabaseService.postsCollection).document(documentRef.documentID).setData(["userName": userName, "postID": documentRef.documentID, "listedDate" : Timestamp(date: Date()), "postText": postText, "userID":user.uid ]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(documentRef.documentID))
                print("item was created \(documentRef.documentID) ")
            }
        }
        
    }
    
}
