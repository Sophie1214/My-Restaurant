//
//  PickedView.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-29.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import EasyPeasy
import CoreData
import SVProgressHUD

class PickedView: UIView {
    
    let background = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let canvas = UIView()
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let statusLabel = UILabel()
    let addressLabel = UILabel()
    let tagLabel = UILabel()
    let refreshButton = UIButton()
    let mapButton = UIButton()
    let cancelButton = UIButton()
    var restaurant: NSManagedObject?{
        didSet{
            addView()
        }
    }
    weak var controller: RestaurantPickingViewController?
    weak var mainController: ViewController?

    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func addView(){
        let height = UIScreen.main.bounds.height
        
        self.addSubview(background)
        background.frame = self.frame
        
        background.addSubview(canvas)
        canvas.backgroundColor = .white
        canvas.translatesAutoresizingMaskIntoConstraints = false
        canvas <- [CenterX(), Top(height/5.5 - 50), Left(50), Right(50), Height(>=0)]
        canvas.layer.cornerRadius = 10
        // canvas.layer.masksToBounds = true
        canvas.layer.shadowColor = UIColor.black.cgColor
        canvas.layer.shadowOpacity = 0.5
        canvas.layer.shadowOffset = CGSize(width: 0, height: 5)
        canvas.layer.shadowRadius = 10
        
        canvas.addSubview(imageView)
        if let imageData = restaurant?.value(forKey: "image") as? Data{
            let image = UIImage(data: imageData)
            imageView.image = image
        }
        else{
            imageView.image = #imageLiteral(resourceName: "free")
        }
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView <- [Left(8), Right(8), Top(10), Height(height/4)]
        
        canvas.addSubview(nameLabel)
        if let name = restaurant?.value(forKey: "name") as? String{
            nameLabel.text = name
        } else{
            nameLabel.text = "Name Of Restaurant"
        }
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightUltraLight)
        nameLabel.sizeToFit()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel <- [Top(15).to(imageView, .bottom), Left().to(imageView, .left), Right(10), Height(>=0)]
        
        canvas.addSubview(statusLabel)
        //statusLabel.text = "Open Now"
        statusLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        statusLabel.sizeToFit()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel <- [Left().to(imageView, .left), Top(5).to(nameLabel, .bottom)]
        
        canvas.addSubview(addressLabel)
        if let address = restaurant?.value(forKey: "location") as? String{
            addressLabel.text = address
        } else{
            addressLabel.text = "Address Of Restaurant"
        }
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.textColor = .darkGray
        addressLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        addressLabel.sizeToFit()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel <- [Left().to(imageView, .left), Top(10).to(statusLabel, .bottom), Right().to(imageView, .right), Height(>=0)]
        
        canvas.addSubview(tagLabel)
        var classicTags = [String]()
        var customTags = [String]()
        if let tags = restaurant?.value(forKey: "classicTags") as? [String]{
            classicTags = tags
        }
        if let cusTags = restaurant?.value(forKey: "customTags") as? [String]{
            customTags = cusTags
        }
        
        tagLabel.text = (classicTags + customTags).joined(separator: ", ")
        tagLabel.numberOfLines = 0
        tagLabel.lineBreakMode = .byWordWrapping
        tagLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        tagLabel.textColor = UIColor.gray
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel <- [Left().to(imageView, .left), Top(5).to(addressLabel, .bottom), Right().to(imageView, .right), Height(>=0)]
        
        let buttonSpace = (UIScreen.main.bounds.width - 100 - 3*30)/4
        
        canvas.addSubview(refreshButton)
        refreshButton.setImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton <- [Left(buttonSpace), Top(50).to(tagLabel, .bottom), Height(30), Width(30), Bottom(20)]
        
        canvas.addSubview(mapButton)
        mapButton.setImage(#imageLiteral(resourceName: "map"), for: .normal)
        mapButton.addTarget(self, action: #selector(showOnMap), for: .touchUpInside)
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton <- [CenterX(), Top().to(refreshButton, .top), Height(30), Width(30), Bottom(20)]
        
        canvas.addSubview(cancelButton)
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        cancelButton <- [Right(buttonSpace), Top().to(refreshButton, .top), Height(30), Width(30), Bottom(20)]

    }
    
    func cancel(){
        self.isHidden = true
    }
    
    func refresh(){
        controller?.pickingView.buttonTapped()
    }
    
    func showOnMap(){
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        let location = restaurant?.value(forKey:"location") as! String
        if let placeId = restaurant?.value(forKey: "placeId") as? String {
            self.mainController?.showRestaurantOnMap(placeId: placeId, location: "")
        } else{
            self.mainController?.showRestaurantOnMap(placeId: "", location: location)
        }
        _ = controller?.navigationController?.popViewController(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
