//
//  klant.swift
//  KRS
//
//  Created by Wessel Mel on 23/12/2018.
//  Copyright © 2018 Wessel Mel. All rights reserved.
//

import UIKit

struct Klant {
    var id: Int
    var naam: String
    var debnr: String
    var tel: String
    var mobiel: String
    var mail: String
    var straat: String
    var nr: String
    var postcode: String
    var woonplaats: String
    var notities: String
    
    var toestellen: [toestel]
    var onderhouden: [onderhoud]
}

struct Klant3 {
    var naam: String
    var debnr: String
    var tel: String
    var mobiel: String
    var mail: String
    var straat: String
    var nr: String
    var postcode: String
    var woonplaats: String
    var notities: String
    var klant_id: String
    
    var toestellen: [toestel3]
    var onderhouden: [onderhoud3]
}

struct Klant2: Codable {
    var naam: String
    var debnr: String
    var tel: String
    var mobiel: String
    var mail: String
    var straat: String
    var nr: String
    var postcode: String
    var woonplaats: String
    var notities: String
    var klant_id: String
    
    enum CodingKeys: String, CodingKey {
        case naam
        case debnr
        case tel
        case mobiel
        case mail
        case straat
        case nr
        case postcode
        case woonplaats
        case notities
        case klant_id
    }
}

struct toestel {
    var id: String
    var merk: String
    var type: String
    var bouwjaar: String
    var freq: String
    var garantie: String
    var datum: Date
    var serienr: String
    var OGP: String
}

struct toestel2: Codable {
    var klant_id: String
    var toestel_id: String
    var merk: String
    var type: String
    var bouwjaar: String
    var freq: String
    var garantie: String
    var datum: String
    var serienr: String
    var OGP: String
    
    enum CodingKeys: String, CodingKey {
        case klant_id
        case toestel_id
        case merk
        case type
        case bouwjaar
        case freq
        case garantie
        case datum
        case serienr
        case OGP
    }
}

struct toestel3 {
    var klant_id: String
    var toestel_id: String
    var merk: String
    var type: String
    var bouwjaar: String
    var freq: String
    var garantie: String
    var datum: Date
    var serienr: String
    var OGP: String
}

struct onderhoud {
    var toestelid: String
    var onderhoudsdatum: Date
    var monteur: String
    var werkzaamheden: String
    var opmerkingen: String
    var titel: String
    var onderhoud_id: String
}

struct onderhoud2: Codable {
    var klant_id: String
    var toestel_id: String
    var onderhoudsdatum: String
    var monteur: String
    var werkzaamheden: String
    var opmerkingen: String
    var onderhoud_id: String
    
    enum CodingKeys: String, CodingKey {
        case klant_id
        case toestel_id
        case onderhoudsdatum
        case monteur
        case werkzaamheden
        case opmerkingen
        case onderhoud_id
    }
}

struct onderhoud3 {
    var klant_id: String
    var toestel_id: String
    var onderhoudsdatum: Date
    var monteur: String
    var werkzaamheden: String
    var opmerkingen: String
    var onderhoud_id: String
}
