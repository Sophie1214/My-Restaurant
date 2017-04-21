//
//  CustomizeTagCollectionViewController.swift
//  eadate
//
//  Created by 苏菲 on 2017-02-02.
//  Copyright © 2017 Somoplay Inc. All rights reserved.
//

import UIKit
import EasyPeasy

class CustomizeTagCollectionViewController: UIViewController, AddTagDelegate{

    let tagCollectionView = CustomizeTagCollectionView()
    var tags = ["+"]
    
    override func viewWillAppear(_ animated: Bool) {
        tagCollectionView.myCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = UIScreen.main.bounds.height - 105
        tagCollectionView.addView()
        tagCollectionView.delegate = self
        self.view.addSubview(tagCollectionView)
        tagCollectionView <- [
            Top(64),
            Left(),
            Right(),
            Height(height)
        ]
        
        let title = UILabel()
        title.text = "自定义标签"
        title.textColor = UIColor.black
        title.font = UIFont.boldSystemFont(ofSize: 15)
        self.view.addSubview(title)
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
        title <- [Left(20), Top(90)]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func addTag() {
        let addTagController = AddCustomizeTagViewController()
        addTagController.customizeTagCollectionView = tagCollectionView
        self.navigationController?.pushViewController(addTagController, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
