//
//  ViewController.swift
//  thesis
//
//  Created by Constantine Shterev on 7.02.24.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseAuth



class LoginViewController: UIViewController {
    
    var notificationHandler: CommentNotificationHandler?

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

//    let logoImageView: UIImageView = {
//        let imageView = UIImageView(image: UIImage(named: "logo"))
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftViewMode = .always
        textField.leftView =  UIView(frame:  CGRect(origin: .zero, size: CGSize(width: 10, height: 0)))
        textField.translatesAutoresizingMaskIntoConstraints = false
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let attributedPlaceholder = NSAttributedString(string: "Email", attributes: placeholderAttributes)

        textField.attributedPlaceholder = attributedPlaceholder

        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftViewMode = .always
        textField.leftView =  UIView(frame:  CGRect(origin: .zero, size: CGSize(width: 10, height: 0)))
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let attributedPlaceholder = NSAttributedString(string: "Password", attributes: placeholderAttributes)

        textField.attributedPlaceholder = attributedPlaceholder

        return textField
    }()

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        button.backgroundColor = UIColor(named: "primaryColor")
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.systemBlue
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.systemBlue
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViews()
    }

    // MARK: - Actions

    @objc func handleLogin() {
       guard let email = emailTextField.text, let password = passwordTextField.text else { return }

       // Authenticate user with Firebase
       Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
           if let error = error {
               // error handling
               return
           }

           // Authentication Successful - Set up observer and start comments listening
           print("Logged in successfully!")

           // Add observer for Auth state changes
           NotificationCenter.default.addObserver(self, selector: #selector(self.userDidLogin), name: Notification.Name.AuthStateDidChange, object: nil)

           // Attempt to start comment observation (you might move this into the userDidLogin function)
           if let userId = Auth.auth().currentUser?.uid {
               self.startObservingComments(userId: userId)
           }

           // Go to home screen
           let tabBarView = UIHostingController(rootView: TabBarView())
           let navigationController = UINavigationController(rootViewController: tabBarView)
           navigationController.modalPresentationStyle = .fullScreen
           self.present(navigationController, animated: true) // Use 'self.present' here
        }
    }

    @objc func userDidLogin() {
       if let userId = Auth.auth().currentUser?.uid {
           startObservingComments(userId: userId)
       }
    }

    func startObservingComments(userId: String) {
        // Initialize notificationHandler (if not already done)
        if notificationHandler == nil {
            notificationHandler = CommentNotificationHandler(currentUserId: userId)
        }
        notificationHandler?.startObservingComments()
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification Authorization Status:", settings.authorizationStatus.rawValue)
        }

    }
    
    // Helper function to display an alert
//    func showAlert(title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//    }

    @objc func handleSignUp() {
        // Present sign up screen
        let signUpViewController = SignUpViewController()
            signUpViewController.modalPresentationStyle = .fullScreen
        present(signUpViewController, animated: true, completion: nil)

    }

    // MARK: - Helper methods

    private func setupViews() {
        view.addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true

        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(signUpButton)
    }
}


