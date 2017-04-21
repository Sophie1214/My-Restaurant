//
//  MySavedRestaurantsViewController.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-01.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import CoreData
import EasyPeasy
import TBEmptyDataSet
import SVProgressHUD

class MySavedRestaurantsViewController: CoreDataTableViewController, TBEmptyDataSetDelegate, TBEmptyDataSetDataSource, UISearchBarDelegate {

    var controller : ViewController?
    var managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var myRestaurants = [NSManagedObject]()
    let searchBar = UISearchBar()
    var filteredRestaurants = [PlaceDetail]()
    
    var openNowStatus: Bool?
    var distance: Int?
    var filterdTags = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = #imageLiteral(resourceName: "filter").maskWithColor(color: .white)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addFilter))
        
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
        searchBar.frame = CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: 40)
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = .white
        self.tableView.emptyDataSetDataSource = self
        self.tableView.emptyDataSetDelegate = self
        
        updateUI()
        
    }
    
    fileprivate func updateUI() {
        let request : NSFetchRequest<NSFetchRequestResult>= NSFetchRequest(entityName: "Restaurant")
    
        request.sortDescriptors = [NSSortDescriptor(
            key: "initial",
            ascending: true,
            selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
            )]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: "initial",
            cacheName: nil
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MySavedRestaurantsTableViewCell

        if let restaurant = fetchedResultsController?.object(at: indexPath) as? Restaurant {
            
            var name: String?
            var location: String?
            var type: String?
            var image:Data?
            var openingHours = [String]()
            var classicTags = [String]()
            var customTags = [String]()
            var photo1: UIImage?
            var hours:String?
            
            restaurant.managedObjectContext?.performAndWait {

                name = restaurant.value(forKey: "name") as? String
                location = restaurant.value(forKey: "location") as? String
                type = restaurant.value(forKey: "type") as? String
                image = restaurant.value(forKey: "image") as? Data
                classicTags = (restaurant.value(forKey:"classicTags") as? [String])!
                customTags = (restaurant.value(forKey:"customTags") as? [String])!
                if restaurant.value(forKey:"openingHours") as? [String] != nil{
                    openingHours = (restaurant.value(forKey:"openingHours") as? [String])!
                }
            }
            if let imageData = image{
                let photo : UIImage = UIImage(data: imageData)!
                    photo1 = photo
            }else{
                photo1 = #imageLiteral(resourceName: "emptyTable").maskWithColor(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
            }
            if !openingHours.isEmpty{
                var weekDay = getDayOfWeek()
                if weekDay == 1{
                    weekDay = weekDay + 5
                }else{
                    weekDay = weekDay - 2
                }
                let day = openingHours[weekDay]
                let result = day.characters.split(separator: " ", maxSplits: 1).map(String.init)
                hours = result[1]
            }
            
            cell.photo.image = photo1
            if hours != nil{
                cell.openTime.text = hours!
            }else{
                cell.openTime.text = nil
            }
            cell.nameLabel.text = name!
            cell.address.text = location!
            cell.type.text = "  \(type!)  "
            if type! == "Fine Dining"{
                cell.type.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
            }
            else if type! == "Casual Dining"{
                cell.type.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            }
            else if type! == "Fast Food"{
                cell.type.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
            }
            else if type! == "Bar"{
                cell.type.backgroundColor = UIColor.purple.withAlphaComponent(0.2)
            }
            else if type! == "Cafe"{
                cell.type.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).withAlphaComponent(0.4)
            }
            else if type! == "Take-out/Delivery"{
                cell.type.backgroundColor = #colorLiteral(red: 0.8817588687, green: 0.7895740867, blue: 0, alpha: 1).withAlphaComponent(0.4)
            }
            else if type == "Buffet"{
                cell.type.backgroundColor = #colorLiteral(red: 0.1309205592, green: 0.7881350517, blue: 0.822279036, alpha: 1).withAlphaComponent(0.5)
            }
            cell.tagLabel.text = (classicTags + customTags).joined(separator:", ")
        }
 
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        restaurantTapped(indexPath: indexPath)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        updateFilteredUI(name: searchText)
        
    }
    
    fileprivate func updateFilteredUI(name: String) {
        let request : NSFetchRequest<NSFetchRequestResult>= NSFetchRequest(entityName: "Restaurant")
        if !name.isEmpty {
            request.predicate = NSPredicate(format: "any name contains[c] %@", name)
        }
        request.sortDescriptors = [NSSortDescriptor(
            key: "initial",
            ascending: true,
            selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
            )]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: "initial",
            cacheName: nil
        )
    }
    
    func updateFilteredPlaceId(id: [String], address: [String]) {
        let request : NSFetchRequest<NSFetchRequestResult>= NSFetchRequest(entityName: "Restaurant")
        request.predicate = NSPredicate(format: "placeId IN %@ OR location IN %@", id, address)
        request.sortDescriptors = [NSSortDescriptor(
            key: "initial",
            ascending: true,
            selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
            )]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: "initial",
            cacheName: nil
        )
    }

    
    func restaurantTapped(indexPath:IndexPath){
        
        let myActionSheet = UIAlertController()
        let photoAction = UIAlertAction(title: "Show on Map", style: .default, handler: { [weak self]
            action in
            
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.black)
            
            if let indexPath = self?.tableView.indexPathForSelectedRow {
                let restaurant = self?.fetchedResultsController?.object(at: indexPath) as! NSManagedObject
                let location = restaurant.value(forKey:"location") as! String
                if let placeId = restaurant.value(forKey: "placeId") as? String {
                    self?.controller?.showRestaurantOnMap(placeId: placeId, location: "")
                } else{
                    self?.controller?.showRestaurantOnMap(placeId: "", location: location)
                }
            }
            _ = self?.navigationController?.popViewController(animated: true)
        })
        
        let selectAction = UIAlertAction(title: "Edit", style: .default, handler: {[weak self]
            action in
            if let indexPath = self?.tableView.indexPathForSelectedRow {
                // Fetch Record
                let restaurant = self?.fetchedResultsController?.object(at: indexPath) as! NSManagedObject
                
                let addNewController = AddNewTableViewController()
                // Configure View Controller
                addNewController.restaurantObject = restaurant
                self?.navigationController?.pushViewController(addNewController, animated: true)
            }
            
        })
        
        let saveAction = UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self]
            action in
            
            let msg = "Delete this restaurant?"
            let controller2 = UIAlertController(
                title:"Alert",
                message: msg, preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Confirm", style: .destructive, handler: { [weak self] action in
                do{
                    if let indexPath = self?.tableView.indexPathForSelectedRow {
                        let restaurant = self?.fetchedResultsController?.object(at: indexPath) as! NSManagedObject
                        self?.managedObjectContext?.delete(restaurant)
                        try self?.managedObjectContext?.save()
                    }
                }catch{
                    print("delete failed")
                }
                
            })
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel) {[weak self] action -> Void in
                                                //Just dismiss the action sheet
                                                self?.tableView.deselectRow(at: indexPath, animated: true)
            }

            controller2.addAction(cancelAction)
            controller2.addAction(deleteAction)
            self?.present(controller2, animated: true,
                          completion: nil)
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) {[weak self] action -> Void in
            //Just dismiss the action sheet
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }
        
        cancelAction.index(ofAccessibilityElement: 3)
        myActionSheet.addAction(photoAction)
        myActionSheet.addAction(selectAction)
        myActionSheet.addAction(saveAction)
        myActionSheet.addAction(cancelAction)
        present(myActionSheet, animated: true, completion: nil)
        
    }

    func addFilter(){
        let filterTable = FilterTableViewController()
        filterTable.controller = self
        filterTable.highlightedTags = filterdTags
        if openNowStatus != nil{
            filterTable.openNowStatus = self.openNowStatus!
        }
        if distance != nil{
            filterTable.distance = self.distance!
        }
        self.navigationController?.pushViewController(filterTable, animated: true)
    }
    
    func getDayOfWeek()->Int {
        let todayDate = Date()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))
        let myComponents = myCalendar?.components(.weekday, from: todayDate)
        let weekDay = myComponents?.weekday
        return weekDay!
    }


}

extension MySavedRestaurantsViewController {
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        // return the image for EmptyDataSet
        return #imageLiteral(resourceName: "emptyTable")
    }
    
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        // return the title for EmptyDataSet
        let title = "No saved restaurants"
        return NSAttributedString(string: title)
    }
    
    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        // return the description for EmptyDataSet
        let description = "Add new restaurants in the side menu, or directly from the map"
        return NSAttributedString(string: description)
    }
    
    func imageTintColorForEmptyDataSet(in scrollView: UIScrollView) -> UIColor? {
        // return the image tint color for EmptyDataSet
        
        return #colorLiteral(red: 0.6795738339, green: 0.67707932, blue: 0.6821792722, alpha: 1)
    }
    
    func backgroundColorForEmptyDataSet(in scrollView: UIScrollView) -> UIColor? {
        // return the backgroundColor for EmptyDataSet
        return #colorLiteral(red: 0.9105593562, green: 0.9072803855, blue: 0.9139841199, alpha: 1)
    }

}




class MySavedRestaurantsTableViewCell: UITableViewCell{
    
    let photo = UIImageView()
    let nameLabel = UILabel()
    let address = UILabel()
    let type = UILabel()
    let openTime = UILabel()
    let tagLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(photo)
        photo.contentMode = .scaleAspectFill
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo <- [Left(8), Width(70), Height(70), Top(8)]
        photo.layer.cornerRadius = 5
        photo.clipsToBounds = true
        
        self.addSubview(nameLabel)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel <- [Left(10).to(photo, .right), Top().to(photo, .top), Right(130)]
        
        self.addSubview(type)
        type.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
        type.sizeToFit()
        type.textColor = .white
        type.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        type.layer.cornerRadius = 3
        type.clipsToBounds = true
        type.translatesAutoresizingMaskIntoConstraints = false
        type <- [Left().to(nameLabel, .left), Top(3).to(nameLabel, .bottom)]
        
        self.addSubview(address)
        address.textColor = .darkGray
        address.numberOfLines = 0
        address.lineBreakMode = .byWordWrapping
        address.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
        address.translatesAutoresizingMaskIntoConstraints = false
        address <- [Top(5).to(type, .bottom), Left().to(nameLabel, .left), Right(12)]
        
        self.addSubview(tagLabel)
        tagLabel.textColor = .lightGray
        tagLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel <- [Top(2).to(address, .bottom), Left().to(nameLabel, .left), Right(12), Height(>=12), Bottom(5)]

        
        self.addSubview(openTime)
        openTime.textColor = .gray
        openTime.numberOfLines = 0
        openTime.lineBreakMode = .byWordWrapping
        openTime.textAlignment = .right
        openTime.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
        openTime.sizeToFit()
        openTime.translatesAutoresizingMaskIntoConstraints = false
        openTime <- [Right(12), CenterY().to(nameLabel, .centerY), Width(130)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
