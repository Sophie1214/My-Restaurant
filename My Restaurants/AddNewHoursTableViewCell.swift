//
//  AddNewHoursTableViewCell.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-21.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import EasyPeasy

class AddNewHoursTableViewCell: UITableViewCell {

    let timeLabel = UILabel()
    let symbolLabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(timeLabel)
        timeLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        timeLabel.sizeToFit()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel <- [CenterY(), Left(20)]
        
        self.addSubview(symbolLabel)
        symbolLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        symbolLabel.sizeToFit()
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel <- [Left(15).to(timeLabel, .right), CenterY()]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
