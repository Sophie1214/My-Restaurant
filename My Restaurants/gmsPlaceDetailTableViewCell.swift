//
//  gmsPlaceDetailTableViewCell.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-13.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import EasyPeasy

class gmsPlaceDetailTableViewCell: UITableViewCell {

    let addressView = IconAndDescription(frame: CGRect(x:0, y:0, width:0, height:0))
    let timeView = IconAndDescription(frame: CGRect(x:0, y:0, width:0, height:0))
    let phoneView = IconAndDescription(frame: CGRect(x:0, y:0, width:0, height:0))
    let websiteView = IconAndDescription(frame: CGRect(x:0, y:0, width:0, height:0))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(addressView)
        addressView.iconView.image = #imageLiteral(resourceName: "locationIcon").maskWithColor(color: #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1))
        addressView.translatesAutoresizingMaskIntoConstraints = false
        addressView <- [Top(), Left(), Right(), Height(>=0)]
        
        self.addSubview(timeView)
        timeView.iconView.image = #imageLiteral(resourceName: "clockIcon").maskWithColor(color: #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1))
        timeView.translatesAutoresizingMaskIntoConstraints = false
        timeView <- [Left(), Right(), Top().to(addressView, .bottom), Height(>=0)]
        
        self.addSubview(phoneView)
        phoneView.iconView.image = #imageLiteral(resourceName: "phoneIcon").maskWithColor(color: #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1))
        phoneView.translatesAutoresizingMaskIntoConstraints = false
        phoneView <- [Left(), Right(), Top().to(timeView, .bottom), Height(>=0)]
        
        self.addSubview(websiteView)
        websiteView.iconView.image = #imageLiteral(resourceName: "website").maskWithColor(color: #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1))
        websiteView.translatesAutoresizingMaskIntoConstraints = false
        websiteView <- [Left(), Right(), Top().to(phoneView, .bottom), Height(>=0), Bottom()]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class IconAndDescription: UIView {
    let iconView = UIImageView()
    var image: UIImage?
    let wordLabel = UILabel()
    var text: String?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.addSubview(iconView)
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView <- [Top(20), Left(20), Width(20), Height(20)]
        
        self.addSubview(wordLabel)
        wordLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        wordLabel.numberOfLines = 0
        wordLabel.lineBreakMode = .byWordWrapping
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel <- [Top().to(iconView, .top), Bottom(15), Left(80), Right(20), Height(>=0)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}
