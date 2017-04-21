//
//  AddCustomizeTagViewController.swift
//  eadate
//
//  Created by 苏菲 on 2017-02-02.
//  Copyright © 2017 Somoplay Inc. All rights reserved.
//

import UIKit
import EasyPeasy

class AddCustomizeTagViewController: UIViewController, UITextFieldDelegate {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
    let textview = TextField()
    var customizeTagCollectionView : CustomizeTagCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(onTapGestureRecognized(sender:)))
        self.view.addGestureRecognizer(tapRecognizer)

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.done, target: self, action: #selector(dismiss(sender:)))
        
        self.view.backgroundColor = #colorLiteral(red: 0.9373082519, green: 0.9373301864, blue: 0.9373183846, alpha: 1)
 
        self.view.addSubview(textview)
        textview.delegate = self
        textview.font = UIFont.systemFont(ofSize: 15)
        textview.backgroundColor = UIColor.white
        textview.placeholder = "Type one tag you want to add"
        textview.textColor = UIColor.gray
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview <- [Left(), Top(80), Right(), Height(50)]
        
        let label = UILabel()
        self.view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "examples： favourite, far, expensive"
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label <- [Left(10), Top(10).to(textview, .bottom), Right(10)]
        
        
    }

    func dismiss(sender: UIBarButtonItem){
        let text = textview.text
        if text?.isEmpty == false{
            self.customizeTagCollectionView?.updateTag(tag: text!)}
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onTapGestureRecognized(sender:AnyObject) {
        textview.resignFirstResponder()
    }

}

class TextField: UITextField, UITextFieldDelegate {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect{
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        self.resignFirstResponder()
    }
}
