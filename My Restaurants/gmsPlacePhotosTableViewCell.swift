//
//  gmsPlacePhotosTableViewCell.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-11.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import EasyPeasy
import SVProgressHUD

class gmsPlacePhotosTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    weak var controller: NextViewController?
    let scroll = UIScrollView()
    var pageControl : UIPageControl = UIPageControl(frame:CGRect(x: 150,y: 250,width: 100,height: 30))
    //    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
    //        super.init(style: style, reuseIdentifier: reuseIdentifier)
    //
    //    }
    
    init(controller: NextViewController, style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.controller = controller
        addView()
        configurePageControl()
    }
    
    func addView(){
        self.addSubview(scroll)
        scroll.backgroundColor = UIColor.black
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true
        //        scroll.contentSize = CGSize(width:(self.view.frame.size.width*CGFloat(imageURL.count)), height:(self.view.frame.size.height))
        scroll.bounces = false
        scroll.delegate = self
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        
        var con = [NSLayoutConstraint]()
        var previousView : UIImageView? = nil
        
        con.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:|[scroll]|",
                                           metrics:nil,
                                           views:["scroll":scroll]))
        con.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat:
                "V:|[scroll(300)]|",
                                           metrics:nil,
                                           views:["scroll":scroll]))
        
        let w = UIScreen.main.bounds.width

        if controller?.photos != nil{
            if controller?.photos.count != 0{
                for photo in (controller?.photos)! {
                    let imageView = UIImageView()
                    scroll.addSubview(imageView)
                    imageView.image = photo
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    
                    con.append(contentsOf:
                        NSLayoutConstraint.constraints(withVisualFormat:
                            "V:|[imageView(300)]|",
                                                       metrics:nil,
                                                       views:["imageView":imageView]))
                    if previousView == nil { // first one, pin to top
                        con.append(contentsOf:
                            NSLayoutConstraint.constraints(withVisualFormat:
                                "H:|[imageView(w)]",
                                                           metrics:["w":w],
                                                           views:["imageView":imageView]))
                    } else { // all others, pin to previous
                        con.append(contentsOf:
                            NSLayoutConstraint.constraints(withVisualFormat:
                                "H:[prev][imageView(w)]",
                                                           metrics:["w":w],
                                                           views:["imageView":imageView, "prev":previousView!]))
                    }
                    previousView = imageView
                }
                con.append(contentsOf:
                    NSLayoutConstraint.constraints(withVisualFormat:
                        "H:[imageView(w)]|",
                                                   metrics:["w":w],
                                                   views:["imageView":previousView!]))
                
                NSLayoutConstraint.activate(con)
            }else {
                self.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func configurePageControl(){
        pageControl.numberOfPages = (controller?.photos.count)!
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.bringSubview(toFront: pageControl)
        self.addSubview(pageControl)
        
        pageControl <- [Bottom(0), CenterX(0), Width(100), Height(50)]
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
