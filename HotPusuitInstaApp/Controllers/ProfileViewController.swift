//
//  ProfileViewController.swift
//  HotPusuitInstaApp
//
//  Created by Tiffany Obi on 3/9/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var displayNameTextfield: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var userPostCountLabel: UILabel!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage? {
        didSet{
        userProfileImage.image = selectedImage
        }
    }
    private let storageService = StorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfo()
        displayNameTextfield.delegate = self
    }
    
    
       func userInfo() {
           guard let user = Auth.auth().currentUser else {return}
           
           emailLabel.text = user.email
           displayNameTextfield.text = user.displayName
        if user.displayName != nil { userProfileImage.kf.setImage(with: user.photoURL)
           
        } else {
    userProfileImage.image = UIImage(systemName: "person.fill")
        }
        
        userPostCountLabel.text = "You've Posted "
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose photo option", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default){ [weak self] alertAction in
            self?.imagePickerController.sourceType = .camera
            self?.present(self!.imagePickerController, animated: true, completion: nil)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self]alertAction in
            self?.imagePickerController.sourceType = .photoLibrary
            self?.present(self!.imagePickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alertController.addAction(cameraAction)
        }
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    

    @IBAction func updateProfileButtonPressed(_ sender: UIButton) {
        guard let displayName = displayNameTextfield.text, !displayName.isEmpty, let selectedImage = selectedImage else {
                print("Missing Fields")
                return
            }
            
            guard let user = Auth.auth().currentUser else {
                return
            }
            
            let request = Auth.auth().currentUser?.createProfileChangeRequest()
            
            // resize image before uploading to Firebase.
            let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: userProfileImage.bounds)
            
            print("Original Image Size: \(selectedImage.size)")
            print("Resized Image Size: \(resizedImage.size)")
            
            storageService.updatePhoto(userId: user.uid, image: resizedImage) { [weak self] (result) in
                switch result{
                case .failure(let error):
                    self?.showAlert(title: "Error", message: "Could not load retrieve photo URL: \(error).")
                case .success(let url):
                    request?.photoURL = url
                    request?.displayName = displayName
                    request?.commitChanges(completion: { [weak self] error in
                        if let error = error {
                            DispatchQueue.main.async {
                                
                                self?.showAlert(title: "Profile Update", message: "Error updating profile: \(error)")
                            }
                        } else {
                            DispatchQueue.main.async {
                                
                                self?.showAlert(title: "Profile Update", message: "Profile was successfully updated.")
                            }
                        }
                    })
                }
            }
        }
        
    

    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            self.showAlert(title: "Error Signing Out", message: " \(error.localizedDescription)")
            
        }
        UIViewController.showViewController(storyboardName: "LoginPage", viewControllerID: "LoginViewController")
        
        print(Auth.auth().currentUser?.email ?? "not current user because your not logged in or signed up")
    }
    
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}
