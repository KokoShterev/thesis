//
//  FirebaseManager.swift
//  thesis
//
//  Created by Constantine Shterev on 13.02.24.
//

import Firebase
import FirebaseDatabase
import FirebaseAuth


class FirebaseManager {
    static let shared = FirebaseManager()
    private let databaseRef = Database.database().reference()

    func fetchApartments(completion: @escaping ([Apartment]) -> Void) {
        databaseRef.child("apartments").observe(.value, with: { snapshot in
            var apartments: [Apartment] = []

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let apartmentData = childSnapshot.value as? [String: Any] {
//                    print(apartmentData)
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
    
    func fetchFilterdApartments(completion: @escaping ([Apartment]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // Handle the case where there's no current user
            print("Error: No current user signed in")
            completion([])  // Return an empty array
            return
        }

        databaseRef.child("apartments").observe(.value, with: { snapshot in
            var apartments: [Apartment] = []

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let apartmentData = childSnapshot.value as? [String: Any] {

                    if var apartment = Apartment(data: apartmentData),
                       apartment.landlordID == currentUserID {

                        // Add the apartment ID
                        apartment.id = childSnapshot.key

                        apartments.append(apartment)
                    }
                }
            }
            completion(apartments)
        })
    }
    
    func fetchComments(forApartmentID apartmentID: String, completion: @escaping ([Comment]) -> Void) {
        let commentsRef = databaseRef.child("apartments/\(apartmentID)/comments") // Reference to the comments section

        commentsRef.observe(.value, with: { snapshot in
            var comments: [Comment] = []

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let commentData = childSnapshot.value as? [String: Any] {
//                    print(commentData)
                    if let comment = Comment(data: commentData) {
                        comments.append(comment)
                    } else {
                        print("Error parsing comment data")
                    }
                }
            }
            completion(comments)
        })
    }

}
