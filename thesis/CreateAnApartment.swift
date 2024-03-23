//
//  CreateAnApartment.swift
//  thesis
//
//  Created by Constantine Shterev on 13.02.24.
//

import Firebase
import FirebaseDatabase


//let sampleApartment = Apartment(
//    id: UUID().uuidString, // Generating a random unique ID
//    location: "Los Angeles, CA",
//    address: "456 Elm Street",
//    numRooms: 3,
//    squareMeters: 90,
//    floorNumber: 2,
//    utilities: ["gas", "water"],
//    description: "Spacious apartment with lots of natural light.",
//    photos: [], // Populate later with image URLs
//    availableDates: [
//        DateRange(startDate: "2024-03-12", endDate: "2024-03-16")
//    ],
//    pricePerNight: 180.0,
//    landlordID: "replaceWithLandlordID"
//)
//
//func createASampleApartment(){
//    let dbRef = Database.database().reference()
//
//    let apartmentData = apartmentToDictionary(apartment: sampleApartment)
//
//    dbRef.child("apartments").child(sampleApartment.id).setValue(apartmentData) { error, ref in
//        if let error = error {
//            print("Error saving apartment: \(error)")
//        } else {
//            print("Apartment added successfully!")
//        }
//    }
//}

