//
//  Barbers.swift
//  HaircutApp
//
//  Created by CheckoutUser on 3/5/18.
//  Copyright © 2018 CheckoutUser. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Barbers : Codable {
    
    let venues : [Barber]
    
    struct Barber : Codable {
        var name : String?
        var contact : Contact?
        var location : Location?
        var categories : [Categories]?
        
        struct Contact : Codable {
            var formattedPhone : String?
        }
        
        struct Location : Codable {
            var address : String?
            var lat : Double?
            var lng : Double?
            var postalCode : String?
            var city : String?
            var state : String?
            var country : String?
        }
        
        struct Categories : Codable {
            var name : String?
        }
    
        func toAnyObject() -> Any {
            let validName = name ?? ""
            let vaidContact = contact?.formattedPhone ?? ""
            let validAddress = location?.address ?? ""
            let validLat = location?.lat ?? 0.0
            let validLng = location?.lng ?? 0.0
            let validPostalCode = location?.postalCode ?? ""
            let validCity = location?.city ?? ""
            let validState = location?.state ?? ""
            let validCountry = location?.country ?? ""
            
            
            return [
                "name" : validName,
                "contact" :  vaidContact,
                "address" : validAddress,
                "lat" : validLat,
                "lng" : validLng,
                "postalCode" : validPostalCode,
                "city" : validCity,
                "state" : validState,
                "country" : validCountry
            ]
        }
    
    }
    
    
}
