//
//  Clothes.swift
//  Second Hand Inventory
//
//  Created by Ladislav Szolik on 30.09.17.
//  Copyright © 2017 Ladislav Szolik. All rights reserved.
//

import Foundation

struct Clothes: Codable {
    var qrcode: String
    var category: Category
    var price: Double
    var size: Double
    var dateOfCreation: Date
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("clothes").appendingPathExtension("plist")
    
    static func saveClothes(_ clothesList: [Clothes]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedClothes = try? propertyListEncoder.encode(clothesList)
        try? codedClothes?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadClothes() -> [Clothes]? {
        guard let codedClothes = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Clothes>.self, from: codedClothes)
    }
}

struct Category: Equatable, Codable {
    var id: Int
    var name: String
    
    static var all: [Category] {
        return [ Category(id:0, name: "Bodies" ), Category(id:1, name: "T-Shirt, Langarm" ), Category(id:2, name: "Oberteile" ),Category(id:3, name: "Hosen" ), Category(id:4, name: "Röckli" ) ]
    }
    
    static func ==(lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
