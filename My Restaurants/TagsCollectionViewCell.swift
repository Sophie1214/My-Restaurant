//
//  TagsCollectionViewCell.swift
//  eadate
//
//  Created by 苏菲 on 2017-02-01.
//  Copyright © 2017 Somoplay Inc. All rights reserved.
//

import UIKit
import EasyPeasy

class TagsCollectionViewCell: UICollectionViewCell {
        
        let tagButton = UILabel()
        var maxWidth: CGFloat!
        var text: String! {
            get {
                return tagButton.text
            }
            set(newText) {
                tagButton.text = newText
            }
        }
        override init(frame: CGRect) {
            super.init(frame: frame)

            tagButton.sizeToFit()
            contentView.addSubview(tagButton)
            tagButton.textColor = UIColor.darkGray
            tagButton.font = UIFont.systemFont(ofSize: 15)
            tagButton <- [
                CenterX(),
                CenterY(),
                Height(25)
            ]
            
            
        }
        
        class func defaultFont() -> UIFont {
            return UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        }
        
        
        class func sizeForContentString(_ s: String,
                                        forMaxWidth maxWidth: CGFloat) -> CGSize {
            let maxSize = CGSize(width: maxWidth, height: 1000)
            let opts = NSStringDrawingOptions.usesLineFragmentOrigin
            
            let style = NSMutableParagraphStyle()
            style.lineBreakMode = NSLineBreakMode.byCharWrapping
            let attributes = [ NSFontAttributeName: self.defaultFont(),
                               NSParagraphStyleAttributeName: style]
            
            let string = s as NSString
            let rect = string.boundingRect(with: maxSize, options: opts,
                                           attributes: attributes, context: nil)
            
            return rect.size
        }
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
}
