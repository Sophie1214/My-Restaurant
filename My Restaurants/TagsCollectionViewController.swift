//
//  BooksTagViewController.swift
//  eadate
//
//  Created by 苏菲 on 2017-02-07.
//  Copyright © 2017 Somoplay Inc. All rights reserved.
//

import UIKit
import EasyPeasy

let array = ["Chinese‎", "Canadian", "Korean", "Japanese", "Vietnamese", "Italian", "French", "Western", "Eastern", "Indian", "Halal", "All You Can Eat", "Hot Pot", "烤串", "烤肉", "Breakfast", "Lunch", "Dinner", "Noodles", "Ramen", "家常", "Seafood", "Bar&Grill", "Fusion", "茶餐厅", "Pizza", "Burgers", "Chicken Wings", "Lounges", "Sushi", "Dessert", "Bubble Tea", "Bar", "Cafe", "Dim Sum", "Thai", "Taiwanese", "Coffee&Tea", "Middle Easter", "Steakhouse"]
let sortedArray = array.sorted()

class TagsCollecionViewController: UIViewController, AddTagDelegate, UIScrollViewDelegate {
    
    let tagCollectionView = TagsCollectionView(frame: CGRect(x:0, y:0, width:0, height:0), buttonName: sortedArray)
    let customTagCollectionView = CustomizeTagCollectionView()
    var tags = ["+"]
    let scroll = UIScrollView()
    weak var controller: AddNewTableViewController?
    
    
    override func viewWillAppear(_ animated: Bool) {
        customTagCollectionView.myCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.main.bounds.width
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.done, target: self, action: #selector(dismiss(sender:)))
        
        self.view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll <- [Left(), Right(), Top(), Bottom()]
        scroll.delegate = self
        scroll.backgroundColor = .clear
        
        let title = UILabel()
        title.text = "Classic Tags"
        title.textColor = UIColor.black
        title.font = UIFont.boldSystemFont(ofSize: 15)
        scroll.addSubview(title)
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
        title <- [Left(20), Top(20)]
        
        tagCollectionView.addView()
        scroll.addSubview(tagCollectionView)
        tagCollectionView <- [
            Top(44),
            Left(),
            Right(),
            Height(560),
            Width(screenWidth)
        ]
        
        let title2 = UILabel()
        title2.text = "Customized Tags"
        title2.textColor = UIColor.black
        title2.font = UIFont.boldSystemFont(ofSize: 15)
        scroll.addSubview(title2)
        title2.sizeToFit()
        title2.translatesAutoresizingMaskIntoConstraints = false
        title2 <- [Left(20), Top(20).to(tagCollectionView, .bottom)]
        
        customTagCollectionView.addView()
        customTagCollectionView.delegate = self
        scroll.addSubview(customTagCollectionView)
        customTagCollectionView <- [
            Top(20).to(title2, .bottom),
            Left(),
            Right(),
            Height(200),
            Width(screenWidth),
            Bottom()
        ]    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addTag() {
        let addTagController = AddCustomizeTagViewController()
        addTagController.customizeTagCollectionView = customTagCollectionView
        self.navigationController?.pushViewController(addTagController, animated: true)
    }
    
    func dismiss(sender: UIBarButtonItem){
        _ = customTagCollectionView.buttonName.removeLast()
        
        let customTags = customTagCollectionView.buttonName
        let normalTags = tagCollectionView.highlightedTagArray
        controller?.normalTags = normalTags
        controller?.customTags = customTags
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
