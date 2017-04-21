//
//  POIModel.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-21.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import SwiftyJSON

struct PlaceDetail {

    var formattedAddress: String?
    var vicinity: String?
    var longitude: Double?
    var latitude: Double?
    var placeId: String?
    var name: String?
    var openStatus: Bool?
    var openingHours: [String]?
    var types: [String]?
    var rating: Double?
    var formattedPhoneNumber: String?
    var website: String?

    
    mutating func update(_ data: JSON){
        let result = data["result"]
        
        formattedAddress = result["formatted_address"].stringValue
        longitude = result["geometry"]["location"]["lng"].doubleValue
        latitude = result["geometry"]["location"]["lat"].doubleValue
        placeId = result["place_id"].stringValue
        name = result["name"].stringValue
        openStatus = result["opening_hours"]["open_now"].boolValue
        openingHours = result["opening_hours"]["weekday_text"].arrayObject as? Array<String>
        types = result["types"].arrayObject as? Array<String>
        rating = result["rating"].doubleValue
        formattedPhoneNumber = result["formatted_phone_number"].stringValue
        website = result["website"].stringValue
        vicinity = result["vicinity"].stringValue
    }
  
}

extension PlaceDetail{
    
    init(data: JSON) {
        update(data)
    }
}


