//
//  SignUpViewController.swift
//  thesis
//
//  Created by Constantine Shterev on 8.02.24.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftUI

class SignUpViewController: UIViewController {

    // MARK: - Properties

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

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

    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftViewMode = .always
        textField.leftView =  UIView(frame:  CGRect(origin: .zero, size: CGSize(width: 10, height: 0)))

        textField.translatesAutoresizingMaskIntoConstraints = false
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let attributedPlaceholder = NSAttributedString(string: "Username", attributes: placeholderAttributes)
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

    let confirmPasswordTextField: UITextField = {
            let textField = UITextField()
            textField.layer.cornerRadius = 8
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.leftViewMode = .always
            textField.leftView =  UIView(frame:  CGRect(origin: .zero, size: CGSize(width: 10, height: 0)))
            textField.isSecureTextEntry = true
            textField.translatesAutoresizingMaskIntoConstraints = false
            let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            let attributedPlaceholder = NSAttributedString(string: "Confirm password", attributes: placeholderAttributes)

            textField.attributedPlaceholder = attributedPlaceholder

            return textField
        }()
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.systemBlue
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
    }

    // MARK: - Actions

    @objc func handleSignUp() {
        guard let email = emailTextField.text,
              let username = usernameTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text
        else { return }

        // Basic input validation
        if password != confirmPassword {
            print("Passwords do not match")
            // Show an error message to the user
            return
        }

        // Create user with Firebase
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user:", error)
                // Show an error message to the user
                return
            }
            guard let authResult = authResult else { return }

            let databaseRef = Database.database().reference()
            let usersRef = databaseRef.child("users")

            let userData = [
                "username": username
            ] as [String : Any]

            usersRef.child(authResult.user.uid).setValue(userData) { error, ref in
                if let error = error {
                    print("Error saving user data:", error)
                    // Show an error message to the user
                } else {
                    print("User data saved successfully!")
                    self.handleLogin()
                    print("User created successfully!")
                }
            }
        }
    }

    // MARK: - Helper methods
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        // Authenticate user with Firebase
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
            // Handle potential errors

                let errorCode = AuthErrorCode.Code(rawValue: error._code)
                // Handle other errors
                print("Login Error:", error._code)
            }
            return
        }

        print("Logged in successfully!")
        // TODO: Present home screen
        let tabBarView = UIHostingController(rootView: TabBarView())
        let navigationController = UINavigationController(rootViewController: tabBarView)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }

    private func setupViews() {
        view.addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true

        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(signUpButton)
    }
}
