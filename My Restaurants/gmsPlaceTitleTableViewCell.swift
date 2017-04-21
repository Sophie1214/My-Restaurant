//
//  gmsPlaceTitleTableViewCell.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-11.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import EasyPeasy
import Cosmos

class gmsPlaceTitleTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let ratingNumber = UILabel()
    let typeLabel = UILabel()
    let stars = CosmosView()
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel <- [Left(20), Right(10), Top(15), Height(>=0)]
        
        self.addSubview(ratingNumber)
        ratingNumber.textColor = .white
        ratingNumber.font = UIFont.systemFont(ofSize: 13)
        ratingNumber.translatesAutoresizingMaskIntoConstraints = false
        ratingNumber <- [Left().to(titleLabel, .left), Top(10).to(titleLabel, .bottom), Height(20), Width(40)]
        
        self.addSubview(typeLabel)
        typeLabel.textColor = .white
        typeLabel.font = UIFont.systemFont(ofSize: 15)
        typeLabel.sizeToFit()
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel <- [Left().to(titleLabel, .left), Top(10).to(ratingNumber, .bottom), Bottom(10)]
        
        self.addSubview(stars)
        stars.settings.fillMode = .precise
        stars.settings.filledColor = .white
        stars.settings.emptyColor = #colorLiteral(red: 1, green: 0.7260294557, blue: 0.6782832742, alpha: 1)
        stars.settings.emptyBorderColor = #colorLiteral(red: 1, green: 0.7260294557, blue: 0.6782832742, alpha: 1)
        stars.settings.filledBorderColor = .white
        stars.settings.starSize = 15
        stars.translatesAutoresizingMaskIntoConstraints = false
        stars <- [Left(10).to(ratingNumber, .right), CenterY().to(ratingNumber, .centerY), Height(15), Width(100)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
