//
//  Client.swift
//  Second Hand Inventory
//
//  Created by Ladislav Szolik on 01.10.17.
//  Copyright © 2017 Ladislav Szolik. All rights reserved.
//

import Foundation

struct Client: Codable {
    var firstName: String
    var lastName: String
    var adress: String?
    var Telephone: String?
    var emailAddress: String?
    var clothesList: [Clothes]?
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("clients").appendingPathExtension("plist")
    
    static func saveClients(_ clients: [Client]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedClients = try? propertyListEncoder.encode(clients)
        try? codedClients?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadClients() -> [Client]? {
        guard let codedClients = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Client>.self, from: codedClients)
    }
    
    static func loadSampleClients() -> [Client] {
        let cloatsList = [Clothes(qrcode: "1", category: Category(id:0, name: "Bodies" ), price:11 , size: 22, dateOfCreation: Date()) ]
        return [ Client(firstName: "Henny", lastName: "Katzmann", adress: nil, Telephone: nil, emailAddress: nil, clothesList: cloatsList)
        ]
    }
    
}
