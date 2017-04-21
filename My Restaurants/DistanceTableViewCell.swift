//
//  DistanceTableViewCell.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-27.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import EasyPeasy

class DistanceTableViewCell: UITableViewCell {

    let leftlabel = UILabel()
    let rightLabel = UILabel()
    let slider = UISlider()
    weak var controller: FilterTableViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(leftlabel)
        leftlabel.text = "Distance"
        leftlabel.textColor = UIColor.gray
        leftlabel.font = UIFont(name: "Optima-Regular", size: 18)
        leftlabel.translatesAutoresizingMaskIntoConstraints = false
        leftlabel <- [Top(10), Left(15), Height(20)]
        
        self.addSubview(rightLabel)
        rightLabel.textColor = #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1)
        rightLabel.text = "Any Distance"
        rightLabel.font = UIFont(name: "Optima-Bold", size: 18)
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel <- [Top().to(leftlabel, .top), Right(15)]

        self.addSubview(slider)
        slider.isContinuous = false
        slider.maximumValue = 3
        slider.minimumValue = 0
        slider.value = 3
        slider.tintColor = #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider <- [Left(30), Right(30), Top(10).to(leftlabel, .bottom), Height(30), Bottom(10)]
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    func sliderValueChanged(sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        let value = Int(roundedValue)
        if value == 0{
            rightLabel.text = "1 Km"
            controller?.distance = 1000
        }
        else if value == 1{
            rightLabel.text = "10 Km"
            controller?.distance = 10000
        }else if value == 2{
            rightLabel.text = "20 Km"
            controller?.distance = 20000
        }else if value == 3{
            rightLabel.text = "Any Distance"
            controller?.distance = 30000
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
