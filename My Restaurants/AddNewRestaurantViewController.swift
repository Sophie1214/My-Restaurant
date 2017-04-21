//
//  AddNewRestaurantViewController.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-19.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import EasyPeasy

class AddNewRestaurantViewController: UIViewController, UIScrollViewDelegate {
    
    let scroll = UIScrollView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePlace))
        
        self.view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll <- [Top(), Left(), Right(), Bottom()]
        scroll.delegate = self
        
        
        
        
        
    }
    
    func savePlace(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
