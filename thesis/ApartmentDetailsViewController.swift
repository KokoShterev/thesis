//
//  ApartmentDetailsViewController.swift
//  thesis
//
//  Created by Constantine Shterev on 28.03.24.
//

import UIKit
import Firebase
import FirebaseDatabase

class ApartmentDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    var apartment: Apartment

    // UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let locationLabel = UILabel()
    private let addressLabel = UILabel()
    private let roomsLabel = UILabel()
    private let squareMetersLabel = UILabel()
    private let floorLabel = UILabel()
    private let utilitiesLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    private let availabilityLabel = UILabel()
    
    let commentInputView = UIView()
    let commentTextField = UITextField()
    let sendButton = UIButton()

    private var commentsRef: DatabaseReference?

    private let commentsTableView = UITableView()

    private var comments: [Comment] = []
    
    
    // Initializer
    init(apartment: Apartment) {
        self.apartment = apartment
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentsRef = Database.database().reference(withPath: "apartments/\(apartment.id)/comments")
        setupViews()
        configureWithApartmentData()
        fetchComments()
//        print("commentsTableView Frame:", commentsTableView.frame)
//        printViewHierarchy()

    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        scrollView.backgroundColor = .systemBackground
        view.addSubview(scrollView)
//        print("scrollView's superview:", scrollView.superview)

        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
//        print("contentView frame after constraints: \(contentView.frame)")

        // Add UI Elements to Content View with Constraints
        let labelStackView = UIStackView(arrangedSubviews: [
            locationLabel, addressLabel, roomsLabel, squareMetersLabel, floorLabel, utilitiesLabel, availabilityLabel, descriptionLabel, priceLabel
        ])
        labelStackView.axis = .vertical
        labelStackView.spacing = 8
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelStackView)

        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        commentsTableView.backgroundColor = .systemBackground
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        contentView.addSubview(commentsTableView)
//        print("commentsTableView's superview:", commentsTableView.superview)
        
        contentView.backgroundColor = .systemBackground
        commentsTableView.backgroundColor = .systemBackground
        
        commentsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentsTableView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 20),
            commentsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            commentsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            commentsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -80),
            commentsTableView.heightAnchor.constraint(equalToConstant: 200)

        ])

        commentInputView.backgroundColor = .lightGray

        commentTextField.placeholder = "Write a comment..."
        commentTextField.borderStyle = .roundedRect

        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSendComment), for: .touchUpInside)

        commentInputView.addSubview(commentTextField)
        commentInputView.addSubview(sendButton)

        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentTextField.topAnchor.constraint(equalTo: commentInputView.topAnchor, constant: 8),
            commentTextField.leadingAnchor.constraint(equalTo: commentInputView.leadingAnchor, constant: 8),
            commentTextField.bottomAnchor.constraint(equalTo: commentInputView.bottomAnchor, constant: -8),
            commentTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8), // Leaves space for button

            sendButton.trailingAnchor.constraint(equalTo: commentInputView.trailingAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor), // Align button vertically
        ])

        contentView.addSubview(commentInputView)
//        print("commentInputView's superview:", commentInputView.superview)
        commentInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentInputView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            commentInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            commentInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            commentInputView.heightAnchor.constraint(equalToConstant: 60)
        ])
//        print("commentTextField.isUserInteractionEnabled: \(commentTextField.isUserInteractionEnabled)")
//        print("commentsTableView constraints: \(commentsTableView.constraints)")
    }

    func fetchComments() {
        FirebaseManager.shared.fetchComments(forApartmentID: apartment.id) { comments in
            self.comments = comments
            self.commentsTableView.reloadData()
        }
    }

    private func configureWithApartmentData() {
        title = "Apartment Details"
        locationLabel.text = "Location: \(apartment.location)"
        addressLabel.text = "Address: \(apartment.address ?? "N/A")"
        roomsLabel.text = "Rooms: \(apartment.numRooms)"
        squareMetersLabel.text = "Square Meters: \(apartment.squareMeters)"
        floorLabel.text = "Floor: \(apartment.floorNumber)"
        utilitiesLabel.text = "Utilities: \(apartment.utilities.joined(separator: ", "))"
        descriptionLabel.text = "Description: \(apartment.description)"

        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        if let formattedPrice = priceFormatter.string(from: NSNumber(value: apartment.pricePerNight)) {
            priceLabel.text = "Price: \(formattedPrice) per night"
        }

        // Add logic for formatting availableDates
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("Number of comments: \(comments.count)")
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
            
//        print("Configuring cell at index: \(indexPath.row)")
        
        let comment = comments[indexPath.row]
        cell.configure(with: comment)
        return cell
    }
    
    @objc private func handleSendComment() {
        guard let commentText = commentTextField.text, !commentText.isEmpty else { return }

        // Get current user's ID
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }

        // Fetch username from database
        Database.database().reference(withPath: "users/\(currentUserID)/username").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self, let username = snapshot.value as? String else { return }
            
            let newCommentRef = self.commentsRef?.childByAutoId()
            let newCommentData = [
                "userID": currentUserID,
                "username": username,
                "text": commentText,
                "timestamp": ServerValue.timestamp()
            ]
            newCommentRef?.setValue(newCommentData)

            // Clear the text field
            self.commentTextField.text = ""
        }
    }
    
    private func printViewHierarchy() {
        func printSubviews(of view: UIView, indent: String = "") {
            print("\(indent)\(view)")
            for subview in view.subviews {
                printSubviews(of: subview, indent: indent + "  ")
            }
        }

        printSubviews(of: view)
    }

}
