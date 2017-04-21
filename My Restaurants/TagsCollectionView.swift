//
//  TagsCollectionView.swift
//  eadate
//
//  Created by 苏菲 on 2017-02-01.
//  Copyright © 2017 Somoplay Inc. All rights reserved.
//

import UIKit
import EasyPeasy



class TagsCollectionView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    var myCollectionView : UICollectionView!
    let identifierOfTagCollectView = "identifierOfTagCollectView"
    var buttonName = [String]()
    
    var highlightedTagArray = [String]()
    
    init(frame: CGRect, buttonName: [String]) {
        super.init(frame: frame)
        self.buttonName = buttonName
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView(){
        
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: 70, height: 50)
        layout.minimumInteritemSpacing = 8

        self.myCollectionView = UICollectionView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:200), collectionViewLayout: layout)
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        self.myCollectionView.isScrollEnabled = false
        self.myCollectionView.register(TagsCollectionViewCell.self, forCellWithReuseIdentifier: identifierOfTagCollectView)
        self.addSubview(myCollectionView)
        self.myCollectionView.backgroundColor = UIColor.white
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView <- [Top(0), Left(0), Right(0), Bottom(0)]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: identifierOfTagCollectView, for: indexPath) as! TagsCollectionViewCell
        cell.maxWidth = collectionView.bounds.size.width
        cell.text = buttonName[(indexPath as NSIndexPath).row]
        if highlightedTagArray.contains(cell.text){
            cell.layer.backgroundColor = #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1).withAlphaComponent(0.8).cgColor
            cell.tagButton.textColor = .white
        }
        else{
            cell.layer.backgroundColor = #colorLiteral(red: 0.9373082519, green: 0.9373301864, blue: 0.9373183846, alpha: 1).cgColor
        }
        
        cell.layer.borderWidth = 0        
        cell.layer.cornerRadius = 3
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = TagsCollectionViewCell.sizeForContentString(buttonName[indexPath.row],
                                                          forMaxWidth: collectionView.bounds.size.width)
        let width = size.width + 20
        let height = size.height + 20
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath){
        let currentCell = self.myCollectionView.cellForItem(at: indexPath) as! TagsCollectionViewCell
        if currentCell.layer.backgroundColor == #colorLiteral(red: 0.9373082519, green: 0.9373301864, blue: 0.9373183846, alpha: 1).cgColor {
            currentCell.layer.backgroundColor = #colorLiteral(red: 0.9373082519, green: 0.9373301864, blue: 0.9373183846, alpha: 1).withAlphaComponent(0.5).cgColor
        } else {
            currentCell.layer.backgroundColor = #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1).withAlphaComponent(0.5).cgColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let currentCell = self.myCollectionView.cellForItem(at: indexPath) as! TagsCollectionViewCell
        if currentCell.layer.backgroundColor == #colorLiteral(red: 0.9373082519, green: 0.9373301864, blue: 0.9373183846, alpha: 1).withAlphaComponent(0.5).cgColor {
            currentCell.layer.backgroundColor = #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1).withAlphaComponent(0.8).cgColor
            currentCell.tagButton.textColor = UIColor.white
            
            highlightedTagArray.append(currentCell.tagButton.text!)
        } else {
            currentCell.layer.backgroundColor = #colorLiteral(red: 0.9373082519, green: 0.9373301864, blue: 0.9373183846, alpha: 1).cgColor
            currentCell.tagButton.textColor = UIColor.darkGray
            
            if let index = highlightedTagArray.index(of: currentCell.tagButton.text!){
                highlightedTagArray.remove(at: index)
            }
        }
    }
    
}
