//
//  TableViewController.swift
//  SideMenu
//
//  Created by 苏菲 on 2017-02-27.
//  Copyright © 2017 jonkykong. All rights reserved.
//

import UIKit



class TableViewController1: UITableViewController {
    
    weak var viewController: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView()
        
        
    }

  
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row == 0{
            cell.textLabel?.text = "My Saved Restaurants"
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
        } else if indexPath.row == 1{
            cell.textLabel?.text = "Add New Restaurant"
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "What Should I Eat?"
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == 0{
            let controller = MySavedRestaurantsViewController()
            controller.controller = viewController
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else if indexPath.row == 1{
            let addNew = AddNewTableViewController()
            self.navigationController?.pushViewController(addNew, animated: true)
            
        } else if indexPath.row == 2{
            let picker = RestaurantPickingViewController()
            picker.pickedView.mainController = viewController
            self.navigationController?.pushViewController(picker, animated: true)
        //    self.navigationController?.pushViewController(, animated: true)
        }
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}


