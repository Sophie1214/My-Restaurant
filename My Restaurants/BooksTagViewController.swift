//
//  BooksTagViewController.swift
//  eadate
//
//  Created by 苏菲 on 2017-02-07.
//  Copyright © 2017 Somoplay Inc. All rights reserved.
//

import UIKit
import EasyPeasy



class BooksTagViewController: UIViewController {
    var buttons = [String]()
    
    var tagCollectionView = TagsCollectionView(frame: CGRect(x:0, y:0, width:0, height:0), buttonName: [""])
    weak var controller: FilterTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tagCollectionView.buttonName = buttons

        self.view.backgroundColor = UIColor.white
        self.title = "Saved Tags"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.done, target: self, action: #selector(dismiss(sender:)))
        
        tagCollectionView.addView()
        self.view.addSubview(tagCollectionView)
        tagCollectionView <- [
            Top(20),
            Left(),
            Right(),
            Height(350)
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func dismiss(sender: UIBarButtonItem){
        _ = self.navigationController?.popViewController(animated: true)

        let tags = tagCollectionView.highlightedTagArray
        controller?.highlightedTags = tags

    }
}
