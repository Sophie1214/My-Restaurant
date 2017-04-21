//
//  NextViewController.swift
//  DraggableViewController
//
//

import UIKit
import GooglePlaces
import EasyPeasy
import SVProgressHUD

class NextViewController: UIViewController, DismissDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var rootViewController: ViewController?
    var gmsPlace: PlaceDetail? {
        didSet{
            if gmsPlace != nil{
                photos.removeAll()
                loadFirstPhotoForPlace(placeID: (gmsPlace?.placeId)!)
                namePlace = gmsPlace?.name
                ratingPlace = gmsPlace?.rating
                typePlace = gmsPlace?.types?[0]
                
                if gmsPlace?.openStatus != nil{
                    switch (gmsPlace?.openStatus)!{
                    case true:
                        time = "Open now"
                    case false:
                        time = "Closed"
                    }
                } else{
                    time = "Unknown"
                }
                if gmsPlace?.openingHours != nil {
                    for hour in (gmsPlace?.openingHours)!{
                        times += "\n\(hour)"
                    }
                }
            }
        }
    }
    var controller: NextViewController?
    var gmsLocation: CLLocation?{
        didSet{
            if gmsLocation != nil{
            SVProgressHUD.dismiss()
            }
        }
    }
    var namePlace: String?
    var ratingPlace: Double?
    var typePlace: String?
    let label = UILabel()
    var photos = [UIImage]()
    var time = ""
    var times = ""
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: self.view.frame)
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.backgroundColor = .white
        let button = UIButton()
        let arrow = #imageLiteral(resourceName: "left").maskWithColor(color: .white)
        button.setImage(arrow, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button <- [Left(20), Top(30), Height(30), Width(30)]
        
        if gmsPlace != nil && gmsLocation == nil{
            controller = self
            tableView.tableFooterView = UIView()
            tableView.isScrollEnabled  = true
            tableView.bounces = true
            tableView.register(gmsPlaceTitleTableViewCell.self, forCellReuseIdentifier: "title")
            tableView.register(gmsPlaceDetailTableViewCell.self, forCellReuseIdentifier: "detail")
            tableView.register(gmsPlaceButtonTableViewCell.self, forCellReuseIdentifier: "button")
            tableView.separatorStyle = .none
        }

        self.view.bringSubview(toFront: button)
    }
    
    
    func buttonTapped() {
        rootViewController?.disableInteractivePlayerTransitioning = true
        self.dismiss(animated: true) { [unowned self] in
            self.rootViewController?.disableInteractivePlayerTransitioning = false
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0{
            var cell = tableView.dequeueReusableCell(withIdentifier: "photo")
            if (cell == nil) {
                cell = gmsPlacePhotosTableViewCell.init(controller: controller!, style: .default, reuseIdentifier: "photo")
            }
            cell?.selectionStyle = .none
            return cell!
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath) as! gmsPlaceTitleTableViewCell
            cell.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            cell.selectionStyle = .none
            cell.titleLabel.text = namePlace
            if ratingPlace != nil{
                cell.ratingNumber.text = "\(ratingPlace!)"
                cell.stars.rating = Double(ratingPlace!)
            }
            if typePlace != nil{
                cell.typeLabel.text = typePlace
            }
            
            return cell
        }
        
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! gmsPlaceDetailTableViewCell
            cell.selectionStyle = .none
            cell.addressView.wordLabel.text = (gmsPlace?.formattedAddress)!
           
            cell.timeView.wordLabel.text = time + "\n" + times
            
            if gmsPlace?.formattedPhoneNumber != nil{
                cell.phoneView.wordLabel.text = (gmsPlace?.formattedPhoneNumber)!
            } else{
                cell.phoneView.wordLabel.text = "Unknown"
            }
            if gmsPlace?.website != nil || gmsPlace?.website != ""{
                cell.websiteView.wordLabel.text = "\((gmsPlace?.website)!)"
            } else{
                cell.websiteView.wordLabel.text = "Unknown"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath) as! gmsPlaceButtonTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { [weak self] (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let photos = photos?.results {
                    self?.count = photos.count
                    if photos.count == 0{
                        SVProgressHUD.dismiss()
                    }
                    for photo in photos{
                        self?.loadImageForMetadata(photoMetadata: photo)
                    }
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: { [weak self]
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let image = photo{
                    self?.photos.append(image)
                }
                if self?.photos.count == self?.count{
                    self?.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }

//                self.imageView.image = photo;
//                self.attributionTextView.attributedText = photoMetadata.attributions;
            }
        })
    }
    
    func dismissController(_ sender: UIButton){
        let controller = AddNewTableViewController()
        controller.name = (gmsPlace?.name)!
        controller.location = (gmsPlace?.vicinity)!
        controller.placeId = (gmsPlace?.placeId)!
        if gmsPlace?.openingHours != nil {
            controller.openingHours = (gmsPlace?.openingHours)!
        }
        if !photos.isEmpty {
            controller.image = photos[0]
        }
        let navigationController = UINavigationController(rootViewController: controller)
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    
}
