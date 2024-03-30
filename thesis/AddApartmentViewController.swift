//
//  AddApartmentViewController.swift
//  thesis
//
//  Created by Constantine Shterev on 28.03.24.
//

import UIKit
import Firebase

class AddApartmentViewController: UIViewController {
    
    // Text fields
    let locationTextField = UITextField()
    let addressTextField = UITextField()
    let numRoomsTextField = UITextField()
    let squareMetersTextField = UITextField()
    let floorNumberTextField = UITextField()
    let utilitiesTextField = UITextField()
    let descriptionTextField = UITextField()
    let pricePerNightTextField = UITextField()

    // Confirm button
    let confirmButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Apartment"
        view.backgroundColor = .systemBackground
        setupUI()
    }

    func setupUI() {
        locationTextField.placeholder = "City, Region"
        addressTextField.placeholder = "Street Address (Optional)"
        numRoomsTextField.placeholder = "Number of Rooms"
        squareMetersTextField.placeholder = "Square Meters"
        floorNumberTextField.placeholder = "Floor Number"
        utilitiesTextField.placeholder = "Utilities (e.g., WiFi, AC)"
        descriptionTextField.placeholder = "Description"
        pricePerNightTextField.placeholder = "Price per Night"

        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        
        // Stack View for layout
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Add elements to stack view
        stackView.addArrangedSubview(locationTextField)
        stackView.addArrangedSubview(addressTextField)
        stackView.addArrangedSubview(numRoomsTextField)
        stackView.addArrangedSubview(squareMetersTextField)
        stackView.addArrangedSubview(floorNumberTextField)
        stackView.addArrangedSubview(utilitiesTextField)
        stackView.addArrangedSubview(descriptionTextField)
        stackView.addArrangedSubview(pricePerNightTextField)
        stackView.addArrangedSubview(confirmButton)

        // Add stack view to main view and set constraints
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc func handleConfirm() {
        guard let location = locationTextField.text, !location.isEmpty,
              let numRoomsText = numRoomsTextField.text, let numRooms = Int(numRoomsText),
              let squareMetersText = squareMetersTextField.text, let squareMeters = Int(squareMetersText),
              let floorNumText = floorNumberTextField.text, let floorNumber = Int(floorNumText),
              let utilitiesText = utilitiesTextField.text,
              let description = descriptionTextField.text, !description.isEmpty,
              let priceText = pricePerNightTextField.text, let pricePerNight = Double(priceText)
              else {
                // Show error: Missing/invalid fields
                return
        }

        let utilities = utilitiesText.components(separatedBy: ", ") // Split utilities string

        // Get landlordID
        guard let landlordID = Auth.auth().currentUser?.uid else { return }

        // Create Apartment object
        let apartment = Apartment(
            data: ["location": location,
            "address": addressTextField.text,
            "numRooms": numRooms,
            "squareMeters": squareMeters,
            "floorNumber": floorNumber,
            "utilities": utilities,
            "description": description,
            "availableDates": [], // No initial dates
            "pricePerNight": pricePerNight,
            "landlordID": landlordID]
        )!

        // Convert to dictionary for Firebase
        let apartmentDict = apartmentToDictionary(apartment: apartment)

        // Save to Firebase Realtime Database
        let databaseRef = Database.database().reference()
        databaseRef.child("apartments").child(apartment.id).setValue(apartmentDict) { error, ref in
            if let error = error {
                print("Error saving data: \(error)")
            } else {
                print("Apartment saved successfully")
                self.dismiss(animated: true)
            }
        }
    }
}
