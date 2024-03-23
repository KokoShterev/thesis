//
//  ProfileViewController.swift
//  diplomna
//
//  Created by Constantine Shterev on 18.02.24.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // UI Elements
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "User Name"
        return label
    }()

    let addApartmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Apartment", for: .normal)
//        button.addTarget(self, action: #selector(addApartmentTapped), for: .touchUpInside)
        return button
    }()

    let apartmentListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ApartmentTableViewCell.self, forCellReuseIdentifier: "apartmentCell")
        return tableView
    }()

    // Data
    var apartments: [Apartment] = [] // Replace 'Apartment' with your data model
//    var userProfile: UserProfile? // Example structure for user data

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
//        fetchUserData()
        fetchApartments()
//        addProfileImageTapGesture()

//        apartmentListTableView.dataSource = self
//        apartmentListTableView.delegate = self
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "person.fill"), tag: 0)
    }

    // MARK: - UI Setup
    func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(addApartmentButton)
        view.addSubview(apartmentListTableView)

        // Layout setup using Auto Layout (Constraints) - Example:
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        // Name Label Constraints
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: addApartmentButton.leadingAnchor, constant: -15).isActive = true // Allow name to adjust

        // Add Apartment Button Constraints
        addApartmentButton.translatesAutoresizingMaskIntoConstraints = false
        addApartmentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addApartmentButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true

        // Apartment List Table View Constraints
        apartmentListTableView.translatesAutoresizingMaskIntoConstraints = false
        apartmentListTableView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        apartmentListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        apartmentListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        apartmentListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    // MARK: - Data Handling
//    func fetchUserData() {
//        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
//        let userRef = Firestore.firestore().collection("users").document(currentUserID)
//
//        userRef.getDocument { [weak self] (snapshot, error) in
//            if let error = error {
//                print("Error fetching user data: \(error)")
//                return
//            }
//
//            guard let data = snapshot?.data() else { return }
//            // Populate 'userProfile' from data (Adapt based on your model)
//            self?.userProfile = UserProfile(data: data)
//            self?.nameLabel.text = self?.userProfile?.name
//
//            // Download profile image if available
//            if let profileImageUrl = self?.userProfile?.profileImageUrl {
//                self?.profileImageView.sd_setImage(with: URL(string: profileImageUrl))
//            }
//        }
//    }

    func fetchApartments() {
        // Implement fetch apartments for the user
    }

//    @objc func addApartmentTapped() {
//        let addApartmentVC = AddApartmentViewController() // Example
//        navigationController?.pushViewController(addApartmentVC, animated: true)
//    }

    @objc func handleImageTap() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }

}

// MARK: - Table View
//extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    // ... (Implementation from previous responses) ...
//}
