//
//  DummyView.swift
//  DraggableViewController
//
//

import UIKit

class BottomBar: UIView {
    
    static let bottomBarHeight: CGFloat = 80
    var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubview() {
        self.backgroundColor = UIColor.white
        
        button = UIButton()
//        button.setTitle("Tap or drag me", for: UIControlState())
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = UIColor.white
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[button]-|", options: [], metrics: nil, views: ["button": button]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[button]-|", options: [], metrics: nil, views: ["button": button]))
    }
}
