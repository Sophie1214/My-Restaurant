//
//  PickingView.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-29.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import EasyPeasy
import CoreData

class PickingView: UIView {

    let topLabel = UILabel()
    let bottomLabel = UILabel()
    let button = UIButton()
    var objects = [NSManagedObject]()
    var restaurant:NSManagedObject?{
        didSet{
            controller?.pickedView.restaurant = restaurant
        }
    }
    weak var controller: RestaurantPickingViewController?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.addSubview(button)
        button.setImage(#imageLiteral(resourceName: "pineapple"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button <- [CenterY(-20).to(self, .centerY), CenterX().to(self, .centerX), Width(130), Height(130)]
        
        self.addSubview(topLabel)
        let myAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 24, weight: UIFontWeightUltraLight)]
        let myAttribute2 = [NSFontAttributeName: UIFont.systemFont(ofSize: 24, weight: UIFontWeightUltraLight), NSForegroundColorAttributeName: #colorLiteral(red: 0.6768427491, green: 0.08792678267, blue: 0.0195481088, alpha: 1)] as [String : Any]
        let myString = NSMutableAttributedString(string: "Tap the\n", attributes: myAttribute)
        let attrString = NSMutableAttributedString(string: "PINEAPPLE\n", attributes: myAttribute2)
        let string1 = NSMutableAttributedString(string: "or\n", attributes: myAttribute)
        let string2 = NSMutableAttributedString(string: "SHAKE ", attributes: myAttribute2)
        let string3 = NSMutableAttributedString(string: "YOUR PHONE", attributes: myAttribute)
        
        myString.append(attrString)
        myString.append(string1)
        myString.append(string2)
        myString.append(string3)
        topLabel.numberOfLines = 4
        topLabel.lineBreakMode = .byWordWrapping
        topLabel.textAlignment = .center
        topLabel.attributedText = myString
        topLabel.sizeToFit()
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel <- [CenterX(), Bottom(65).to(button, .top)]
        
        self.addSubview(bottomLabel)
        bottomLabel.text = "A random (saved) restaurant will\n be picked out for you"
        bottomLabel.numberOfLines = 2
        bottomLabel.lineBreakMode = .byWordWrapping
        bottomLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightThin)
        bottomLabel.textColor = .darkGray
        bottomLabel.textAlignment = .center
        bottomLabel.sizeToFit()
        bottomLabel <- [Top(65).to(button, .bottom), CenterX()]
        
    }
    
    func buttonTapped(){
        controller?.buttonTapped()
    }
    
        
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
