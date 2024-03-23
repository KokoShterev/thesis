//
//  ApartmentListViewController.swift
//  diplomna
//
//  Created by Constantine Shterev on 13.02.24.
//

import UIKit
import Firebase
import FirebaseDatabase

class ApartmentListViewController: UIViewController {

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // We'll replace this with fetched data later
    var apartments: [Apartment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        tableView.register(ApartmentTableViewCell.self, forCellReuseIdentifier: "apartmentCell") // Assuming you have this cell class

        setupViews()
        fetchApartments() // Replace with real data fetching function later
    }

    func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apartments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apartmentCell", for: indexPath) as! ApartmentTableViewCell

        let apartment = apartments[indexPath.row]
        // Configure your cell with data from 'apartment'

        return cell
    }

    // MARK: - Placeholder fetch function
    func fetchApartments() {
        let databaseRef = Database.database().reference()

        databaseRef.child("apartments").observeSingleEvent(of: .value) { snapshot in
            if let unwrappedData = snapshot.value {
                // Now work with 'unwrappedData' within this block
                print(unwrappedData) // Example - Inspect Data Structure
                var apartments: [Apartment] = []

                    for (key, value) in unwrappedData {
                        if let apartmentDict = value as? [String: Any] {
                            // Careful extraction with error handling for mismatches
                            guard let id = key as? String,
                                  let location = apartmentDict["location"] as? String,
                                  let numRooms = apartmentDict["numRooms"] as? Int,
                                  let squareMeters = apartmentDict["squareMeters"] as? Int,
                                  let floorNumber = apartmentDict["floorNumber"] as? Int,
                                  let utilities = apartmentDict["utilities"] as? [String],
                                  let description = apartmentDict["description"] as? String,
                                  let pricePerNight = apartmentDict["pricePerNight"] as? Double,
                                  let landlordID = apartmentDict["landlordID"] as? String else {
                                    print("Error parsing apartment with key: \(key)")
                                    continue // Skip malformed entry
                                }

                            let address = apartmentDict["address"] as? String
//                            let availableDates = parseAvailableDates(from: apartmentDict) // Assuming you have/create this function

//                            let apartment = Apartment(id: id, location: location, address: address, numRooms: numRooms, squareMeters: squareMeters, floorNumber: floorNumber, utilities: utilities, description: description, photos: [], availableDates: availableDates, pricePerNight: pricePerNight, landlordID: landlordID)

//                            apartments.append(apartment)
                        } else {
                            print("Error parsing apartment with key: \(key)")
                        }
                    }

                    self.apartments = apartments
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
            } else {
                print("Data snapshot value was nil")
            }
        }

//            var apartments: [Apartment] = []
//
//            for (key, value) in apartmentsData {
//                if let apartmentDict = value as? [String: Any],
//                   let apartment = Apartment(dictionary: apartmentDict) {
//                    apartments.append(apartment)
//                } else {
//                    print("Error parsing apartment with key: \(key)")
//                }
//            }
//
//            self.apartments = apartments // Update the apartments array
//
//            DispatchQueue.main.async {
//                self.tableView.reloadData() // Refresh the table view
//            }
    }

}
