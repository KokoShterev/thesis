//
//  HomeViewController.swift
//  thesis
//
//  Created by Constantine Shterev on 13.02.24.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView = UITableView()
    var apartments: [Apartment] = []
    var databaseRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Apartment Finder"

        databaseRef = Database.database().reference() //  Initialize database reference

        configureUI()
        fetchApartments()
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
    }

    // MARK: - UI Configuration
    func configureUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // TableView Layout Constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ApartmentTableViewCell.self, forCellReuseIdentifier: "ApartmentCell")
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(apartments.count)
        return apartments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Configuring cell at index path: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApartmentCell", for: indexPath) as! ApartmentTableViewCell
        cell.configure(with: apartments[indexPath.row])
        return cell
    }
    

    // MARK: Optional
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedApartment = apartments[indexPath.row]
//        let detailsViewController = ApartmentDetailsViewController(apartment: selectedApartment)
//        navigationController?.pushViewController(detailsViewController, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    func fetchApartments() {
        FirebaseManager.shared.fetchApartments { apartments in
            self.apartments = apartments
            self.tableView.reloadData()
        }
    }

    func printApartments(includeImages: Bool = false, includeLandlord: Bool = false) {
        for apartment in apartments {
            print("*** Apartment ***")
//            print("ID: \(apartment.id)")
            print("Location: \(apartment.location)")
            print("Address: \(apartment.address ?? "Not available")") // Handle optional address
            print("Rooms: \(apartment.numRooms)")
            print("Square Meters: \(apartment.squareMeters)")
            print("Floor: \(apartment.floorNumber)")
            print("Utilities: \(apartment.utilities)")

//            if includeImages && !apartment.photos.isEmpty {
//                print("Photos:")
//                for photoUrl in apartment.photos {
//                    print("- \(photoUrl)")
//                }
//            }
            print("Landlord ID: \(apartment.landlordID)")
            print("----------------") // Separator
        }
    }
    
}
