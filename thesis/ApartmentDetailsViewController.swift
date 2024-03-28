//
//  ApartmentDetailsViewController.swift
//  thesis
//
//  Created by Constantine Shterev on 28.03.24.
//

import UIKit

class ApartmentDetailsViewController: UIViewController {

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
        setupViews()
        configureWithApartmentData()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never // Adjust if needed

        // Configure Scroll View and Content View
        view.addSubview(scrollView)
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
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Important for scrollable content
        ])

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

        // Add logic for formatting availableDates if needed
    }
}
