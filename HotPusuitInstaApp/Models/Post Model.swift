//
//  Post Model.swift
//  HotPusuitInstaApp
//
//  Created by Tiffany Obi on 3/9/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation

struct Post {
    
    
    let postID : String // document ID
    let listedDate: Date
    let userName: String
    let userID : String
    let postText: String?
    let imageURL: String
}

extension Post {
    
    init(_ dictionary: [String: Any]) {
         
         
        self.postID = dictionary["postID"] as? String ?? "no id"
        self.listedDate = dictionary["listedDate"] as? Date ?? Date()
         self.userName = dictionary["userName"] as? String ?? "no seller name"
         self.userID = dictionary["sellerId"] as? String ?? "no seller ID"
        self.postText = dictionary["postText"] as? String ?? "no postText"
        self.imageURL = dictionary["imageURL"] as? String ?? "no image"
    }
    

}
