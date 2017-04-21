//
//  FilterTableViewController.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-27.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

class FilterTableViewController: UITableViewController {
    
    var openNowStatus:Bool = false{
        didSet{
            controller?.openNowStatus = openNowStatus
            pickingController?.openNowStatus = openNowStatus
        }
    }
    var distance: Int?{
        didSet{
            controller?.distance = distance
            pickingController?.distance = distance

        }
    }
    
    var placeIds = [String]()
    var placeAddress = [String]()
    weak var controller: MySavedRestaurantsViewController?
    weak var pickingController: RestaurantPickingViewController?
    var allTags = [String]()
    var highlightedTags = [String](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var canStartFetch = false
    var addressReady = false
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply Filter", style: .plain, target: self, action: #selector(applyFilter))
        
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(OpenNowTableViewCell.self, forCellReuseIdentifier: "open")
        tableView.register(DistanceTableViewCell.self, forCellReuseIdentifier: "distance")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        } else{
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "open", for: indexPath) as! OpenNowTableViewCell
                cell.selectionStyle = .none
                if openNowStatus == true{
                    cell.openSwitch.isOn = true
                }
                cell.controller = self
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "distance", for: indexPath) as! DistanceTableViewCell
                cell.selectionStyle = .none
                cell.controller = self
                if distance != nil{
                    if distance == 1000{
                        cell.slider.value = 0
                        cell.rightLabel.text = "1 Km"
                    }
                    else if distance == 30000{
                        cell.slider.value = Float(distance!)/10000
                        cell.rightLabel.text = "Any Distance"
                    }
                    else {
                        cell.slider.value = Float(distance!)/10000
                        cell.rightLabel.text = "\(distance!/1000) Km"
                    }
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if highlightedTags.isEmpty{
                cell.textLabel?.text = "Choose from saved tags"
            } else{
                cell.textLabel?.text = highlightedTags.joined(separator: ", ")
            }
            cell.textLabel?.textColor = .gray
            cell.textLabel?.font = UIFont(name: "Optima-Regular", size: 18)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var string: String? = nil
        if section == 1{
            string = "(filter restaurant which contains any of the chosen tags)"
        }
        return string
    }
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1{
            let savedTags = BooksTagViewController()
            managedObjectContext.performAndWait{
                self.fetchTagsFromCoreData()
            }
            savedTags.controller = self
            savedTags.buttons = Array(Set(allTags)).sorted()
            savedTags.tagCollectionView.highlightedTagArray = highlightedTags
            self.navigationController?.pushViewController(savedTags, animated: true)
        }
    }
    
    func applyFilter(){
        SVProgressHUD.show(withStatus: "Filtering")
        SVProgressHUD.setDefaultMaskType(.black)
        fetchAndFilterFromCoreData()
    }
    
    func fetchAndFilterFromCoreData(){
        
        do{
            
            let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Restaurant")
            let results = try managedObjectContext.fetch(request) as! [NSManagedObject]
            if results.count == 0{
                let alert = UIAlertController(title: "Alert", message: "No restaurant found", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            else{
                var sameTag = [""]
                controller?.filterdTags = highlightedTags
                
                for result in results{
                    let classic = result.value(forKey: "classicTags") as! [String]
                    let custom = result.value(forKey: "customTags") as! [String]
                    let tagsInOneRestaurant = classic + custom
                    
                    if !highlightedTags.isEmpty{
                        sameTag = highlightedTags.filter({ tagsInOneRestaurant.contains($0) })
                    }
                    
                    if !sameTag.isEmpty{
                        if result.value(forKey: "placeId") != nil{
                            placeIds.append(result.value(forKey: "placeId") as! String)
                        }
                        else{
                            placeAddress.append(result.value(forKey: "location") as! String)
                        }
                    }
                    
                }
                
                
                if openNowStatus == true{
                    placeAddress.removeAll()
                    addressReady = true
                }
                
                if !placeAddress.isEmpty{
                    let firstCount = self.placeAddress.count
                    var counter = 0
                    
                    for address in placeAddress{
                        if self.distance != 30000 && self.distance != nil{
                            MapTasks.sharedInstance.geocodeAddress(address: address, withCompletionHandler: {[weak self] (status, success) -> Void in
                                if !success {
                                    
                                    if status == "ZERO_RESULTS" {
                                        print("location cannot be found")
                                    }
                                }
                                else {
                                    counter = counter + 1
                                    if counter == firstCount{
                                        self?.addressReady = true
                                    }
                                    
                                    let coordinate = CLLocationCoordinate2D(latitude: (MapTasks.sharedInstance.fetchedAddressLatitude)!, longitude: (MapTasks.sharedInstance.fetchedAddressLongitude)!)
                                    
                                    let userLocation = ViewController.userLocation
                                    let userLocationCoordinate = userLocation?.coordinate
                                    
                                    let distance = GMSGeometryDistance(userLocationCoordinate!, coordinate)
                                    if distance > Double((self?.distance)!) {
                                        if let index = self?.placeAddress.index(of: address){
                                            self?.placeAddress.remove(at: index)
                                        }
                                    }
                                    
                                    self?.prepareToReload()
                                }
                            })
                        }
                        else{
                            addressReady = true
                        }
                    }
                } else{
                    addressReady = true
                }
                
                
                let firstCount = self.placeIds.count
                var counter = 0
                
                if placeIds.isEmpty{
                    canStartFetch = true
                }
                for id in placeIds{
                    MapTasks.sharedInstance.placeDetailRequest(placeId: id, success: {[weak self] userDetail in
                        
                        counter = counter + 1
                        if counter == firstCount{
                            self?.canStartFetch = true
                        }
                        if self?.openNowStatus == true{
                            if let openNow = userDetail.openStatus {
                                if openNow == false{
                                    self?.placeIds.remove(at: (self?.placeIds.index(of: id)!)!)
                                }
                            }
                        }
                        
                        if self?.distance != 30000 && self?.distance != nil{
                            let placeLocation = CLLocationCoordinate2D(latitude: userDetail.latitude!, longitude: userDetail.longitude!)
                            let userLocation = ViewController.userLocation
                            let userLocationCoordinate = userLocation?.coordinate
                            
                            let distance = GMSGeometryDistance(userLocationCoordinate!, placeLocation)
                            if distance > Double((self?.distance)!) {
                                if let index = self?.placeIds.index(of: id){
                                    self?.placeIds.remove(at: index)
                                }
                            }
                        }
                        
                        self?.prepareToReload()
                        }
                        , failure: { errorDescription in
                            print(errorDescription)
                    })
                }
            }
        } catch{
            print("error")
        }
        
    }
    
    func prepareToReload(){
        let count = placeIds.count
        if count != 0 || placeAddress.count != 0{
            if canStartFetch == true && addressReady == true {
                controller?.updateFilteredPlaceId(id: placeIds, address: placeAddress)
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else{
            let controller2 = UIAlertController(title:"Alert", message: "No restaurants can be found, please reset your filter.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            controller2.addAction(cancelAction)
            present(controller2, animated: true, completion: nil)
            SVProgressHUD.dismiss()
        }
    }
    
    func fetchTagsFromCoreData(){
        do{
            
            let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Restaurant")
            let results = try managedObjectContext.fetch(request) as! [NSManagedObject]
            
            for result in results {
                if result.value(forKey: "classicTags") != nil{
                    let classicTag = result.value(forKey: "classicTags") as! [String]
                    allTags += classicTag
                }
                if result.value(forKey: "customTags") != nil{
                    let customTags = result.value(forKey: "customTags") as! [String]
                    allTags += customTags
                }
            }
        }
        catch{
            print("cannot fetch")
        }
    }
    
    
}
