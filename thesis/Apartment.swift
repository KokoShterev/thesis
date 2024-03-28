//
//  Apartment.swift
//  thesis
//
//  Created by Constantine Shterev on 12.02.24.
//

struct Apartment {
//    let id: String // We'll generate a unique ID
    var location: String
    var address: String?
    var numRooms: Int
    var squareMeters: Int
    var floorNumber: Int
    var utilities: [String]
    var description: String
//    var photos: [String]
    var availableDates: [DateRange]?
    var pricePerNight: Double
    var landlordID: String
    
    init?(data: [String: Any]) {
        guard 
//            let id = data["id"] as? String,
              let location = data["location"] as? String,
              let numRooms = data["numRooms"] as? Int,
              let squareMeters = data["squareMeters"] as? Int,
              let floorNumber = data["floorNumber"] as? Int,
              let utilities = data["utilities"] as? [String],
              let description = data["description"] as? String,
//              let photos = data["photos"] as? [String],
              let pricePerNight = data["pricePerNight"] as? Double,
              let landlordID = data["landlordID"] as? String else { return nil }

//        self.id = id
        self.location = location
        self.address = data["address"] as? String
        self.numRooms = numRooms
        self.squareMeters = squareMeters
        self.floorNumber = floorNumber
        self.utilities = utilities
        self.description = description
//        self.photos = photos
        self.pricePerNight = pricePerNight
        self.landlordID = landlordID

        self.availableDates = data["availableDates"] as? [DateRange]
        print("init completed")
    }
}

struct DateRange {
    let startDate: String // "YYYY-MM-DD"
    let endDate: String
    
    init?(data: [String: String]) {
            guard let startDate = data["startDate"], let endDate = data["endDate"] else { return nil }
            self.startDate = startDate
            self.endDate = endDate
        }
}


func apartmentToDictionary(apartment: Apartment) -> [String: Any] {
    var result: [String: Any] = [
        "location": apartment.location,
        "address": apartment.address ?? "",
        "numRooms": apartment.numRooms,
        "squareMeters": apartment.squareMeters,
        "floorNumber": apartment.floorNumber,
        "utilities": apartment.utilities,
        "description": apartment.description,
//        "photos": apartment.photos,
        "pricePerNight": apartment.pricePerNight,
        "landlordID": apartment.landlordID
    ]
    
    if let dates = apartment.availableDates {
        result["availableDates"] = dates.map {
            ["startDate": $0.startDate, "endDate": $0.endDate]
        }
    }

    return result
}

