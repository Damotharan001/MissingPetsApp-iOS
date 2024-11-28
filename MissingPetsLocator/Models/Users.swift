//
//  Users.swift
//  MissingPetsLocator
//
//  Created by Damotharan KG on 27/11/24.
//

import Foundation
import UIKit

struct MissingPet: Codable {
    var description: String
    var location: String
    var petImage: String
    var petName: String
    var species: String
    var contactNo: String
    var uID: String
    
    enum CodingKeys: String, CodingKey{
        case description = "Description"
        case location = "Location"
        case petImage = "PetImage"
        case petName = "PetName"
        case species = "Species"
        case contactNo = "ContactNo"
        case uID = "uID"
    }
    
    static let dump = MissingPet()
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.location = try container.decodeIfPresent(String.self, forKey: .location) ?? ""
        self.petImage = try container.decodeIfPresent(String.self, forKey: .petImage) ?? ""
        self.petName = try container.decodeIfPresent(String.self, forKey: .petName) ?? ""
        self.species = try container.decodeIfPresent(String.self, forKey: .species) ?? ""
        self.contactNo = try container.decodeIfPresent(String.self, forKey: .contactNo) ?? ""
        self.uID = try container.decodeIfPresent(String.self, forKey: .uID) ?? ""
    }
    
    init() {
        self.description = ""
        self.location = ""
        self.petImage = ""
        self.petName = ""
        self.species = ""
        self.contactNo = ""
        self.uID = ""
    }
}

struct User: Codable {
    var emailID: String
    var password: String
//    var missingPetList: [MissingPet]?
    
    enum CodingKeys: String, CodingKey {
        case emailID = "EmailID"
        case password = "Password"
//        case missingPetList = "missingPetList"
    }
    
    static let dump = User()
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.emailID = try container.decode(String.self, forKey: .emailID)
        self.password = try container.decode(String.self, forKey: .password)
//        self.missingPetList = try container.decodeIfPresent([MissingPet].self, forKey: .missingPetList)
    }
    
    init() {
        self.emailID = ""
        self.password = ""
//        self.missingPetList = []
    }
}

