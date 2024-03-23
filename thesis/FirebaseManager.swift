//
//  FirebaseManager.swift
//  diplomna
//
//  Created by Constantine Shterev on 13.02.24.
//

import Firebase
import FirebaseDatabase


class FirebaseManager {
    static let shared = FirebaseManager()
    private let databaseRef = Database.database().reference()

    func fetchApartments(completion: @escaping ([Apartment]) -> Void) {
        databaseRef.child("apartments").observe(.value, with: { snapshot in
            var apartments: [Apartment] = []

            // (Same parsing logic as in the 'fetchApartments' function)
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let apartmentData = childSnapshot.value as? [String: Any] {
                    print(apartmentData)
                    if let apartment = Apartment(data: apartmentData) {
                        apartments.append(apartment)
                    } else {
                        // MARK: - Handle potential parsing errors
                        print("bad")
                    }
                }
            }
            completion(apartments)
        })
    }
}
