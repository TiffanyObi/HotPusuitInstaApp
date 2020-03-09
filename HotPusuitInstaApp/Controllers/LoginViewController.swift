//
//  LoginViewController.swift
//  HotPusuitInstaApp
//
//  Created by Tiffany Obi on 3/6/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth

enum AccountState {
    case existingUser
    case newUser
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    var constraint: NSLayoutConstraint!
    
    private var accountState: AccountState = .existingUser
    private var authSession = AuthenticationSession()
    
    var keyboardIsVisible = false
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(keyboardWillHide(_:)))
        return gesture
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        messageLabel.isHidden = true
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(true)
            unregisterForKeyboardNotifications()
        }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextfield.text,
            !password.isEmpty else {
                print("missing feilds")
                return
        }
        continueLoginFlow(email: email, password: password)
        
    }
    
    private func continueLoginFlow(email:String,password:String) {
        if accountState == .existingUser {
            
            authSession.signInExistingUsingUser(email: email, password: password) { [weak self](result) in
                
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.messageLabel.text = "\(error.localizedDescription)"
                        self?.messageLabel.textColor = .systemRed
                    }
                    
                case .success:
                    DispatchQueue.main.async {
                        //navigate to main view
                        self?.navigateToMainView()
                    }
                }
            }
            
        } else {
            
            authSession.creatNewUser(email: email, password: password) { [weak self] (result) in
                
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.messageLabel.text = "\(error.localizedDescription)"
                        self?.messageLabel.textColor = .systemRed
                    }
                    
                case .success:
                    DispatchQueue.main.async {
                        self?.navigateToMainView()
                    }
                }
            }
            
        }
    }
    
    private func navigateToMainView() {
        UIViewController.showViewController(storyboardName: "Main", viewControllerID: "MainViewController")
    }
    
    private func clearErrorLabel() {
        messageLabel.text = ""
    }
    
    @IBAction func toggleAccountState(_ sender: UIButton) {
        // change the account login state
        accountState = accountState == .existingUser ? .newUser : .existingUser
        
        
        if accountState == .existingUser {
            
            loginButton.setTitle("LOGIN", for: .normal)
            messageLabel.text = "Don't have an account ? Click"
            signUpButton.setTitle("Sign Up", for: .normal)
        } else {
            
            loginButton.setTitle("SIGN UP", for: .normal)
            messageLabel.text = "Already have an account ?"
            signUpButton.setTitle("Login", for: .normal)
            
        }
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        print("keyboardWillShow")
        
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
            return
        }
        
        
        moveKeyboardUp(keyboardFrame.size.height)
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        emailTextField.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        resetUI()
    }
    
    func moveKeyboardUp(_ height: CGFloat) {
        if keyboardIsVisible {return}
        constraint = centerYConstraint
        centerYConstraint.constant -= (height+40)
        
        UIView.animate(withDuration: 1.0, delay: 0.2, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        keyboardIsVisible = true
    }
    
    
    func resetUI() {
        
        
        centerYConstraint.constant -= (constraint.constant-120)
        
        keyboardIsVisible = false
    }
    
    
}

