//
//  OpenNowTableViewCell.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-27.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import Foundation
import EasyPeasy

class OpenNowTableViewCell: UITableViewCell {

    let label = UILabel()
    let openSwitch = UISwitch()
    weak var controller = FilterTableViewController()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(label)
        label.text = "Open Now"
        label.textColor = UIColor.gray
        label.font = UIFont(name: "Optima-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label <- [CenterY(), Left(15)]
        
        self.addSubview(openSwitch)
        openSwitch.onTintColor = #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1)
        openSwitch.isOn = false
        openSwitch.translatesAutoresizingMaskIntoConstraints = false
        openSwitch.addTarget(self, action: #selector(openNowSwitched), for: .valueChanged)
        openSwitch <- [CenterY(), Right(15)]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openNowSwitched(){
        if openSwitch.isOn == true{
            controller?.openNowStatus = true
        } else {
            controller?.openNowStatus = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
