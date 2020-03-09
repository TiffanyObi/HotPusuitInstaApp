//
//  CreatePostViewController.swift
//  HotPusuitInstaApp
//
//  Created by Tiffany Obi on 3/9/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreatePostViewController: UIViewController {
    
    
    @IBOutlet weak var doneButton: UIButton!
    
    
    @IBOutlet weak var createPostImageView: UIImageView!
    
    @IBOutlet weak var captionTextField: UITextField!
    
    private let dbService = DatabaseService()
    private let storageService = StorageService()
    
    private var selectedImage: UIImage? {
        didSet {
    createPostImageView.image = selectedImage
            doneButton.isHidden = false
        }
    }
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        return picker
        
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(showPhotoOptions))
        return gesture
        
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(dismissKeyboard))
        return gesture
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(tapGesture)
        doneButton.isHidden = true
        createPostImageView.isUserInteractionEnabled = true
        createPostImageView.addGestureRecognizer(longPressGesture)
    }
    

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        guard let caption = captionTextField.text,
        let selectedImage = selectedImage else {
                showAlert(title: "Missings Fields", message: "All feilds are required along with a phone")
                return
        }
        
        guard let displayName = Auth.auth().currentUser?.displayName else {
            showAlert(title: "Incomplete Profile", message: "Please complete your profile")
            return
        }
        
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: createPostImageView.bounds)
        
        dbService.createItem(userName: displayName, postText: caption) { [weak self] (result) in
            switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self?.showAlert(title: "Error creating item", message: "Sorry, something went wrong: \(error.localizedDescription)") }
        case .success(let documentID):
            self?.uploadPhoto(image: resizedImage, documentID: documentID)
            DispatchQueue.main.async {
            self?.showAlert(title: "Awesome!!", message: "Your item has been posted!") }
            }
        }
        
    }
    
    @objc private func dismissKeyboard() {
        captionTextField.resignFirstResponder()
    }
    
    @objc private func showPhotoOptions() {
        let alertController = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (alertAction) in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
            let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (alertAction) in
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true)

        }
        
        let cancelAction = UIAlertAction(title: "Camera", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        
        present(alertController, animated:  true)
    }
    
    
    private func uploadPhoto(image: UIImage, documentID: String){
            
            storageService.updatePhoto(itemId: documentID, image: image) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error!", message: "\(error.localizedDescription)")
                    }
                    
                case .success(let url):
                    self?.updateItemImageURL(url, documentID: documentID)
                
                    }
                }
            }
            
        
        
    private func updateItemImageURL(_ url: URL, documentID: String) {
        
        //upate an exisiting document on firebase
        
        Firestore.firestore().collection(DatabaseService.postsCollection).document(documentID).updateData(["imageURL": url.absoluteString]) { [weak self] (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(error.localizedDescription)")
                }
            } else {
                print("Everything well well with the update")
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
        
}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        
        createPostImageView.contentMode = .scaleToFill
        selectedImage = image
        dismiss(animated: true, completion: nil)
        
    }
}
