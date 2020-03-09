//
//  StorageServices.swift
//  HotPusuitInstaApp
//
//  Created by Tiffany Obi on 3/9/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService{
    

    
    private let storageRef = Storage.storage().reference()
    
    // Default parameters in Swift e.g. userId: String? = nil
    public func updatePhoto(userId: String? = nil, itemId: String? = nil, image: UIImage, completion: @escaping (Result<URL,Error>) -> ()){
        
        // 1. Convert UIImage to Data because this is the object we are posting to Firebase Storage.
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        // We need to establish which bucket, or collection, or folder we will be saving the photo to
        var photoReference: StorageReference!
        
        if let userId = userId{ // Coming from profile view controller
            photoReference = storageRef.child("UserProfilePhotos/\(userId).jpeg")
        } else if let itemId = itemId{ // Coming from create item view controller
            photoReference = storageRef.child("ItemsPhoto/\(itemId).jpeg")
        }
        
        // Configure metadata for the object being uploaded.
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let _ = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                photoReference.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
}
