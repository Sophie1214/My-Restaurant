//
//  CustomizeTagCollectionView.swift
//  eadate
//
//  Created by 苏菲 on 2017-02-02.
//  Copyright © 2017 Somoplay Inc. All rights reserved.
//

import UIKit
import EasyPeasy

protocol AddTagDelegate : class {
    func addTag()
}

class CustomizeTagCollectionView: UIView,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    var myCollectionView : UICollectionView!
    let identifierOfTagCollectView = "identifierOfTagCollectView"
    var buttonName = ["+"]
    var delegate: AddTagDelegate?
    
    func addView(){
        
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.minimumInteritemSpacing = 5
        
        self.myCollectionView = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: layout)
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
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
        cell.layer.borderWidth = 0
        
        if indexPath.row == buttonName.count - 1 {
            cell.tagButton.textColor = #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1)
            cell.layer.backgroundColor = #colorLiteral(red: 0.9373082519, green: 0.9373301864, blue: 0.9373183846, alpha: 1).cgColor
        } else {
            cell.layer.backgroundColor = #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1).withAlphaComponent(0.8).cgColor
            cell.tagButton.textColor = UIColor.white
        }
        
        cell.layer.cornerRadius = 3
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = TagsCollectionViewCell.sizeForContentString(buttonName[indexPath.row],
                                                               forMaxWidth: collectionView.bounds.size.width)

        if indexPath.row == buttonName.count - 1{
            let width = size.width + 50
            let height = size.height + 20
            return CGSize(width: width, height: height)
        } else {
            let width = size.width + 20
            let height = size.height + 20
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath){
        let currentCell = self.myCollectionView.cellForItem(at: indexPath) as! TagsCollectionViewCell
        currentCell.layer.backgroundColor = #colorLiteral(red: 0.9373082519, green: 0.9373301864, blue: 0.9373183846, alpha: 1).withAlphaComponent(0.5).cgColor
        currentCell.tagButton.textColor = UIColor.gray
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath){
        let currentCell = self.myCollectionView.cellForItem(at: indexPath) as! TagsCollectionViewCell
        if indexPath.row == buttonName.count - 1 {
            currentCell.layer.backgroundColor = #colorLiteral(red: 0.9373082519, green: 0.9373301864, blue: 0.9373183846, alpha: 1).cgColor
            currentCell.tagButton.textColor = #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1)
        } else {
            currentCell.layer.backgroundColor = #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1).withAlphaComponent(0.8).cgColor
            currentCell.tagButton.textColor = UIColor.white
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let currentCell = self.myCollectionView.cellForItem(at: indexPath) as! TagsCollectionViewCell
        if currentCell.tagButton.text == "+"{
            delegate?.addTag()
        } else {
            let warningText = "提示"
            let messageText = "确定删除此自定义标签"
            let cancelText = "取消"
            let okText = "确定"
            let alert = UIAlertController(title: warningText, message: messageText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: okText, style: .destructive, handler: { [weak weakSelf = self]action in
                weakSelf?.buttonName.remove(at: indexPath.item)
                weakSelf?.myCollectionView.reloadData()}))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func updateTag(tag: String){
        buttonName.insert(tag, at: buttonName.count - 1)
    }


}
