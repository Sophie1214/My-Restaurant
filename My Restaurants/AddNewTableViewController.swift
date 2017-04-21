//
//  AddNewTableViewController.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-19.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import EasyPeasy
import CoreData

class AddNewTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var sections = [["", "Name", "Location"], ["Type", "Choose the type of the restaurant"], ["Tags", "Add tags to your restaurant"]]
    
    var restaurantObject: NSManagedObject?{
        didSet{
            name = restaurantObject?.value(forKey: "name") as! String
            location = restaurantObject?.value(forKey: "location") as! String
            type = restaurantObject?.value(forKey: "type") as! String
            if restaurantObject?.value(forKey: "openingHours") != nil{
                openingHours = restaurantObject?.value(forKey: "openingHours") as! [String]
            }
            customTags = restaurantObject?.value(forKey: "customTags") as! [String]
            normalTags = restaurantObject?.value(forKey: "classicTags") as! [String]
            
            //sections[3][1] = (normalTags + customTags).joined(separator: ", ")
        }
    }
    var customTags = [String]()
    var normalTags = [String](){
        didSet{
            tableView.reloadData()
        }
    }
    var type = "Choose the type of the restaurant"
    var openingHours = [String]()
    var image: UIImage? {
        didSet{
            if image != nil{
                imageData = UIImagePNGRepresentation(image!) as Data?
            }
        }
    }
    var imageData: Data?

    let types = ["Undefined", "Fine Dining", "Casual Dining", "Fast Food", "Bar", "Cafe", "Take-out/Delivery", "Buffet"]
    let picker = UIPickerView()
    //var times = [String]()
    var name = ""{
        didSet{
            if !name.isEmpty{
                if !String(describing: (name.characters.first)!).isChinese(){
                    initial = String(describing: (name.characters.first)!).uppercased()
                } else {
                    let str1:CFMutableString = CFStringCreateMutableCopy(nil, 0, name as CFString!);
                    CFStringTransform(str1, nil, kCFStringTransformToLatin, false)
                    CFStringTransform(str1, nil, kCFStringTransformStripCombiningMarks, false)
                    let str2 = CFStringCreateWithSubstring(nil, str1, CFRangeMake(0, 1))
                    initial = String(describing: str2!).uppercased()
                }
            }
        }
    }
    var location = ""
    var initial = ""
    var placeId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveRestaurant))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(AddNewBasicTableViewCell.self, forCellReuseIdentifier: "basic")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        picker.isHidden = true
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = #colorLiteral(red: 0.9373332858, green: 0.9379555583, blue: 0.9563199878, alpha: 1)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.selectRow(0, inComponent: 0, animated: false)
        self.view.addSubview(picker)
        self.view.bringSubview(toFront: picker)
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        picker <- [Left(), Width(width), Top(height-180-64), Height(180)]
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
//        
//        for i in 0...23{
//            let onTime = "\(i):00"
//            let halfTime = "\(i):30"
//            times.append(onTime)
//            times.append(halfTime)
//        }
//        times.insert("Unknown", at: 0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count - 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath) as! AddNewBasicTableViewCell
            if indexPath.row == 0{
                cell.nameLabel.text = sections[indexPath.section][1]
                cell.textField.placeholder = "Enter the name of the restaurant"
                cell.textField.delegate = self
                cell.textField.text = name
                //nameToStore = (cell.textField.text)!
            }
            else{
                cell.nameLabel.text = sections[indexPath.section][2]
                cell.textField.font = UIFont.systemFont(ofSize: 13)
                cell.textField.placeholder = "Enter the location of the restaurant"
                cell.textField.text = location
                cell.textField.delegate = self
                //locationToStore = (cell.textField.text)!
            }
            cell.selectionStyle = .none
            return cell
        }
            
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = type
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            let tags = (normalTags + customTags).joined(separator: ", ")
            if tags.isEmpty{
                cell.textLabel?.text = "Add tags to your restaurant"
            } else {
                cell.textLabel?.text = tags
            }
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
            return cell
        }
            
//        else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.accessoryType = .disclosureIndicator
//            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
//            if indexPath.row == 0{
//                cell.textLabel?.text = openTime
//            }
//            else{
//                cell.textLabel?.text = closingTime
//            }
//            return cell
//            
//        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section  == 1 {
            if picker.isHidden == true{
                picker.isHidden = false
                picker.reloadAllComponents()
            } else{
                picker.isHidden = true
            }
        }

        else if indexPath.section == 2{
            let tags = TagsCollecionViewController()
            tags.controller = self
            let string = "Add tags to your restaurant"
            if normalTags.contains(string){
                normalTags.remove(at: normalTags.index(of:"Add tags to your restaurant")!)
            }
            tags.tagCollectionView.highlightedTagArray = normalTags
            tags.customTagCollectionView.buttonName = customTags + ["+"]
            self.navigationController?.pushViewController(tags, animated: true)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section][0]
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        picker.isHidden = true
        let indexPath = IndexPath(row:0, section:0)
        if let cell = tableView.cellForRow(at: indexPath) as? AddNewBasicTableViewCell{
            cell.textField.resignFirstResponder()
        }
        
        let indexPath2 = IndexPath(row:1, section:0)
        if let cell2 = tableView.cellForRow(at: indexPath2) as? AddNewBasicTableViewCell {
            cell2.textField.resignFirstResponder()
        }
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return types.count
//        else{
//            return times.count
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return types[row]
//        else{
//            return times[row]
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let chosenType = types[row]
            let indexPath = IndexPath(row: 0, section: 1)
            if let cell = tableView.cellForRow(at: indexPath){
                cell.textLabel?.text = chosenType
                type = chosenType
        }
//        else if pickerView.tag == 1{
//            let time = times[row]
//            let indexPath = IndexPath(row: 0, section: 2)
//            if let cell = tableView.cellForRow(at: indexPath){
//                cell.textLabel?.text = time
//                openTime = time
//            }
//            
//        } else if pickerView.tag == 2{
//            let time = times[row]
//            let indexPath = IndexPath(row: 1, section: 2)
//            if let cell = tableView.cellForRow(at: indexPath){
//                cell.textLabel?.text = time
//                closingTime = time
//            }
//        }
    }
    
    func dismissPicker(){
        if picker.isHidden == false{
            picker.isHidden = true
        }
        let indexPath = IndexPath(row:0, section:0)
        if let cell = tableView.cellForRow(at: indexPath) as? AddNewBasicTableViewCell{
            cell.textField.resignFirstResponder()
        }
        let indexPath2 = IndexPath(row:1, section:0)
        if let cell2 = tableView.cellForRow(at: indexPath2) as? AddNewBasicTableViewCell {
            cell2.textField.resignFirstResponder()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        if textField.superview == cell{
            if !(textField.text?.isEmpty)! {
                name = textField.text!
            }
        }
        else{
            if !(textField.text?.isEmpty)! {
                location = textField.text!
            }
        }
    }
    
    
    
    
    func saveRestaurant(){
        addRestaurantToCoreData()
    }
    
    func cancel(){
        dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func addRestaurantToCoreData(){
        
        let managedObject = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = managedObject.persistentContainer.viewContext
        
        var restaurantName = ""
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! AddNewBasicTableViewCell
        restaurantName = (cell.textField.text)!
        
        var locationToStore = ""
        let indexPath2 = IndexPath(row: 1, section: 0)
        let cell2 = tableView.cellForRow(at: indexPath2) as! AddNewBasicTableViewCell
        locationToStore = (cell2.textField.text)!
        
        if restaurantName.isEmpty || locationToStore.isEmpty || type == "Choose the type of the restaurant"{
            let alert = UIAlertController(title: "Alert", message: "Please finish all fields before saving", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.navigationController?.topViewController?.present(alert, animated: true, completion: nil)
        }
        else{
            do {
                if restaurantObject != nil{
                    restaurantObject?.setValue(restaurantName, forKeyPath:"name")
                    restaurantObject?.setValue(locationToStore, forKeyPath:"location")
                    restaurantObject?.setValue(type, forKeyPath:"type")
//                    restaurantObject?.setValue(openTime, forKeyPath:"openTime")
//                    restaurantObject?.setValue(closingTime, forKeyPath:"closingTime")
                    restaurantObject?.setValue(customTags, forKeyPath:"customTags")
                    restaurantObject?.setValue(normalTags, forKeyPath:"classicTags")
                    restaurantObject?.setValue(initial, forKeyPath:"initial")
                    
                    if imageData != nil{
                        restaurantObject?.setValue(imageData!, forKeyPath:"image")
                    }
                }else{
                    let restaurant:NSManagedObject
                    let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Restaurant")
                    if placeId.isEmpty{
                        request.predicate = NSPredicate(format: "name == %@", restaurantName)
                    } else{
                        request.predicate = NSPredicate(format: "placeId == %@", placeId)
                    }
                    let results = try managedObjectContext.fetch(request) as! [NSManagedObject]
                    
                    if results.count == 0{//create user
                        let restaurantEntity = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedObjectContext)!
                        restaurant = NSManagedObject(entity: restaurantEntity, insertInto: managedObjectContext)
                        
                    }else{  //update User
                        restaurant = results[0]
                    }
                    
                    restaurant.setValue(restaurantName, forKeyPath:"name")
                    restaurant.setValue(locationToStore, forKeyPath:"location")
                    restaurant.setValue(type, forKeyPath:"type")
                    if !openingHours.isEmpty{
                        restaurant.setValue(openingHours, forKeyPath:"openingHours")
                    }
//                    restaurant.setValue(closingTime, forKeyPath:"closingTime")
                    restaurant.setValue(customTags, forKeyPath:"customTags")
                    restaurant.setValue(normalTags, forKeyPath:"classicTags")
                    restaurant.setValue(initial, forKeyPath:"initial")
                    
                    if imageData != nil{
                        restaurant.setValue(imageData!, forKeyPath:"image")
                    }
                    if !placeId.isEmpty {
                        restaurant.setValue(placeId, forKeyPath: "placeId")
                    }
                    
                }
                try managedObjectContext.save()
                dismiss(animated: true, completion: nil)
                _ = self.navigationController?.popViewController(animated: true)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
}
