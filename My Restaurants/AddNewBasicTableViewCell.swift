//
//  AddNewBasicTableViewCell.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-20.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import EasyPeasy

class AddNewBasicTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let textField = UITextField()
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addSubview(nameLabel)
        nameLabel.textColor = #colorLiteral(red: 0.4735156298, green: 0.4717208743, blue: 0.4753902555, alpha: 1)
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        nameLabel.sizeToFit()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel <- [Left(20), Top(15)]
        
        self.addSubview(textField)
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField <- [Left().to(nameLabel, .left), Top(10).to(nameLabel, .bottom), Height(20), Right(15), Bottom(10)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
