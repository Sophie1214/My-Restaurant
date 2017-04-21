//
//  gmsPlaceButtonTableViewCell.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-19.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import EasyPeasy

protocol DismissDelegate {
    func dismissController(_ sender: UIButton)
}

class gmsPlaceButtonTableViewCell: UITableViewCell {

    let button = UIButton()
    var delegate : DismissDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        
        button.setTitle("Add to My Restaurants", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(#colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1), for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 0.7548643947, blue: 0.7769028544, alpha: 1), for: .highlighted)
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button <- [CenterX(), Height(50), Top(30), Bottom(30), Width(300)]
        button.layer.borderColor = #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(dismissController(sender:)), for: .touchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissController(sender: UIButton){
        delegate?.dismissController(sender)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
