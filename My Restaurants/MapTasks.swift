//
//  MapTasks.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-03.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MapTasks: NSObject {
    static let sharedInstance = MapTasks()

    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    var lookupAddressResults: Dictionary<String, Any>!
    var fetchedFormattedAddress: String!
    var fetchedAddressLongitude: Double!
    var fetchedAddressLatitude: Double!
    var name: String!
    
    override init() {
        super.init()
    }
    
    
    ///////用alamofire下载web service的url，下载完了用swiftyjson放到poi struct里面去
    func placeDetailRequest(placeId: String, success: @escaping (_ _placeDetail: PlaceDetail)->(), failure: @escaping (_ errorDescription: String) -> ()){
        
        let path = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + placeId + "&key=" + "AIzaSyDP-_VOmpdjFLeYo_0ExCDAePf5JvG1t5c"
        
        Alamofire.request(path)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    if (json["error"] == JSON.null){
                        let info = PlaceDetail(data: json)
                        success(info)
                    }else{
                        failure(json["error"].stringValue)
                    }
                case .failure( _):
                    print("placeDetailRequest Failed")
                }
        }
    }

    
    
    func getAddressForLatLng(latitude: String, longitude: String, withCompletionHandler completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyDP-_VOmpdjFLeYo_0ExCDAePf5JvG1t5c")
        DispatchQueue.global().async(execute: { [weak self]() -> Void in
            
            let data = NSData(contentsOf: url! as URL)
            let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
            
            let status = json["status"] as! String
            
            if let result = json["results"] as? Array<Dictionary<String, Any>> {
                if let address = result[0]["address_components"] as? Array<Dictionary<String, Any>> {
                    self?.lookupAddressResults = result[0] as Dictionary<String, Any>
                    // Keep the most important values.
                    self?.fetchedFormattedAddress = self?.lookupAddressResults!["formatted_address"] as! String
                    
                    let number = address[0]["short_name"] as! String
                    let street = address[1]["short_name"] as! String
                    
                    self?.name = "\(number) \(street)"
                    
                    completionHandler(status, true)
                }
            }
        })
    }
    
    func geocodeAddress(address: String!, withCompletionHandler completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        if let lookupAddress = address {
            var geocodeURLString = baseURLGeocode + "address=" + lookupAddress
            geocodeURLString = geocodeURLString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            let geocodeURL = NSURL(string: geocodeURLString)
            
            DispatchQueue.global().async(execute: { [weak self]() -> Void in
                let geocodingResultsData = NSData(contentsOf: geocodeURL! as URL)
                
                do{
                    let dictionary: Dictionary<String, Any> = try JSONSerialization.jsonObject(with: geocodingResultsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                    
                    let status = dictionary["status"] as! String
                    
                    if status == "OK" {
                        let allResults = dictionary["results"] as! Array<Dictionary<String, AnyObject>>
                        self?.lookupAddressResults = allResults[0] as Dictionary<String, Any>
                        
                        // Keep the most important values.
                        self?.fetchedFormattedAddress = self?.lookupAddressResults!["formatted_address"] as! String
                        let geometry = self?.lookupAddressResults!["geometry"] as! Dictionary<String, Any>
                        self?.fetchedAddressLongitude = ((geometry["location"] as! Dictionary<String, Any>)["lng"] as! NSNumber).doubleValue
                        self?.fetchedAddressLatitude = ((geometry["location"] as! Dictionary<String, Any>)["lat"] as! NSNumber).doubleValue
                        
                        let address2 = allResults[0]["address_components"] as! Array<Dictionary<String, Any>>
                        let number = address2[0]["short_name"] as! String
                        let street = address2[1]["short_name"] as! String
                        
                        self?.name = "\(number) \(street)"
                        
                        
                        completionHandler(status, true)
                    }
                    else {
                        completionHandler(status, false)
                    }

                } catch{
                    print(error)
                    completionHandler("", false)
                }
                // Get the response status.
            })
        }
        else {
            completionHandler("No valid address.", false)
        }
    }
}
