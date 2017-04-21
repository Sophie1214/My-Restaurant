//
//  ViewController.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-02-16.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import SideMenu
import MapKit
import CoreLocation
import EasyPeasy
import GooglePlaces
import SVProgressHUD

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate, GMSMapViewDelegate, GMSAutocompleteResultsViewControllerDelegate {

    let navigationController1 = UISideMenuNavigationController(rootViewController: TableViewController1())
    let searchBar = UISearchBar()
    
    var mapView : GMSMapView?
    fileprivate let locationManager = CLLocationManager()
    var didFindMyLocation = false
    fileprivate var resultSearchController:UISearchController? = nil
    //fileprivate var annotation:MKAnnotation!
    //var curLocation: CLLocation!
    let tapRecognizer = UILongPressGestureRecognizer()
    var locationMarker: GMSMarker!
    var locationMarker2: GMSMarker!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var resultView: UITextView?

    var disableInteractivePlayerTransitioning = false
    let bottomBar = BottomBar()
    var nextViewController: NextViewController!
    var presentInteractor: MiniToLargeViewInteractive!
    var dismissInteractor: MiniToLargeViewInteractive!
    let arrowButton = UIButton()
    
    static var userLocation: CLLocation?
    
    var gmsPlace: PlaceDetail?{
        didSet{
            if gmsPlace != nil{
                
                DispatchQueue.main.async { [weak self] in
                    self?.prepareView(name: (self!.gmsPlace?.name)!, address: (self!.gmsPlace?.formattedAddress)!)
                }
            }
        }
    }
    var gmsLocation: CLLocation?{
        didSet{
            if gmsLocation != oldValue && gmsLocation != nil{
                
                DispatchQueue.main.async {[weak self] in
                    self?.prepareView(name: (MapTasks.sharedInstance.name)!, address: (MapTasks.sharedInstance.fetchedFormattedAddress)!)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 1
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
        
        let theImage = #imageLiteral(resourceName: "hamburger")
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContext(size)
        theImage.draw(in: CGRect(x:0, y:0, width:size.width, height:size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let icon = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(pushTableView))
        icon.tintColor = .white
        navigationItem.leftBarButtonItem = icon
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchLocation))
        navigationItem.rightBarButtonItem = searchButton

        
        setupSideMenu()
        
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = 10.0
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 48.857165, longitude: 2.354613, zoom: 8.0)
        mapView = GMSMapView()
        mapView?.camera = camera
        mapView?.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView!)
        mapView! <- [Top(), Left(), Bottom(), Right()]
        mapView?.delegate = self
        mapView?.settings.consumesGesturesInView = false
        mapView?.settings.compassButton = true
        

        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        resultSearchController = UISearchController(searchResultsController: resultsViewController)
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = false
        resultSearchController?.searchResultsUpdater = resultsViewController
        definesPresentationContext = true
        
        arrowButton.setImage(#imageLiteral(resourceName: "down"), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pushTableView(){
        navigationController1.setNavigationBarHidden(true, animated: false)
        let controller = navigationController1.topViewController as! TableViewController1
        controller.viewController = self
        self.navigationController?.present(navigationController1, animated: true, completion: nil)
    }
    
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuLeftNavigationController = navigationController1
        SideMenuManager.menuAnimationBackgroundColor = UIColor.lightGray
        SideMenuManager.menuPresentMode = .viewSlideOut
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView?.isMyLocationEnabled = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)  {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
            ViewController.userLocation = myLocation
            mapView?.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 18.0)
            mapView?.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
    }
    
    func setupLongPressedAndSearchedLocationMarker(coordinate: CLLocationCoordinate2D) {
        if locationMarker2 != nil {
            locationMarker2.map = nil
        }
        
        if locationMarker != nil{
            locationMarker.map = nil
        }
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = mapView
        let string = "\(MapTasks.sharedInstance.fetchedFormattedAddress!)"
        locationMarker.snippet = string
        locationMarker.title = MapTasks.sharedInstance.name
        locationMarker.appearAnimation = .pop
        locationMarker.icon = GMSMarker.markerImage(with: #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1))
        

    }
    
    
    func setupPOILocationMarker(coordinate: CLLocationCoordinate2D, name: String, address: String) {
        if locationMarker2 != nil {
            locationMarker2.map = nil
        }
        
        if locationMarker != nil{
            locationMarker.map = nil
        }
        
        locationMarker2 = GMSMarker(position: coordinate)
        locationMarker2.map = mapView
        locationMarker2.snippet = address
        locationMarker2.title = name
        locationMarker2.appearAnimation = .pop
        locationMarker2.icon = GMSMarker.markerImage(with: #colorLiteral(red: 0.9146360755, green: 0.1813534796, blue: 0.2946964502, alpha: 1))
        

    }

    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        searchBar.resignFirstResponder()
        bottomBar.removeFromSuperview()
    }
    
    func searchLocation() {
        resultSearchController!.hidesNavigationBarDuringPresentation = false
        resultSearchController!.searchBar.delegate = self
        resultSearchController?.searchBar.placeholder = "Search for places"
        present(resultSearchController!, animated: true, completion: nil)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        SVProgressHUD.show(withStatus: "Loading Place")
        SVProgressHUD.setDefaultMaskType(.black)
        
        MapTasks.sharedInstance.geocodeAddress(address: searchBar.text!, withCompletionHandler: {[weak self] (status, success) -> Void in
            if !success {
                print(status)
                
                if status == "ZERO_RESULTS" {
                    self?.showAlertWithMessage(message: "The location could not be found.")
                }
            }
            else {
                let coordinate = CLLocationCoordinate2D(latitude: (MapTasks.sharedInstance.fetchedAddressLatitude)!, longitude: (MapTasks.sharedInstance.fetchedAddressLongitude)!)
                self?.gmsPlace = nil
                self?.gmsLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                SVProgressHUD.dismiss()
                
                self?.mapView?.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 14.0)
                self?.setupLongPressedAndSearchedLocationMarker(coordinate: coordinate)
                
            }
            
        })
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        //mapView.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 14.0)
        let latitude = "\(coordinate.latitude)"
        let longitude = "\(coordinate.longitude)"
        
        SVProgressHUD.show(withStatus: "Loading Place")
        SVProgressHUD.setDefaultMaskType(.black)

        
        MapTasks.sharedInstance.getAddressForLatLng(latitude: latitude, longitude: longitude, withCompletionHandler: {[weak self] (status, success) -> Void in
            
            if !success {
                print(status)
                
                if status == "ZERO_RESULTS" {
                    self?.showAlertWithMessage(message: "The location could not be found.")
                }
            }
            else {
                
                self?.gmsPlace = nil
                self?.gmsLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                self?.setupLongPressedAndSearchedLocationMarker(coordinate: coordinate)
                SVProgressHUD.dismiss()
                
            }
            
        })
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        if locationMarker2 != nil {
            locationMarker2.map = nil
        }
        
        if locationMarker != nil{
            locationMarker.map = nil
        }
        
        let latitude = location.latitude
        let longitude = location.longitude
        
        SVProgressHUD.show(withStatus: "Loading Place")
        SVProgressHUD.setDefaultMaskType(.black)

        
        MapTasks.sharedInstance.placeDetailRequest(placeId: placeID, success:
            {[weak self] userDetail in
                
                self?.gmsPlace = userDetail
                self?.gmsLocation = nil
                let name = self?.gmsPlace?.name
                let address = self?.gmsPlace?.formattedAddress
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                self?.setupPOILocationMarker(coordinate:coordinate, name: name!, address: address!)
                
            }, failure: { errorDescription in
                print(errorDescription)
        })
    }

    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        resultSearchController?.isActive = false

        let placeID = place.placeID
        
        if locationMarker2 != nil {
            locationMarker2.map = nil
        }
        
        if locationMarker != nil{
            locationMarker.map = nil
        }
        
        SVProgressHUD.show(withStatus: "Loading Place")
        SVProgressHUD.setDefaultMaskType(.black)

        
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude
        
        MapTasks.sharedInstance.placeDetailRequest(placeId: placeID, success:
            {[weak self] userDetail in
                
                self?.gmsPlace = userDetail
                let name = self?.gmsPlace?.name
                let address = self?.gmsPlace?.formattedAddress
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                self?.setupPOILocationMarker(coordinate:coordinate, name: name!, address: address!)
                
            }, failure: { errorDescription in
                print(errorDescription)
        })
        
        let target = place.coordinate
        mapView?.camera = GMSCameraPosition.camera(withTarget: target, zoom: 12)
        self.gmsLocation = nil
    }
    
    
    func prepareView(name: String, address: String) {
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        mapView?.addSubview(bottomBar)
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar <- [Left(), Right(), Bottom(), Height(BottomBar.bottomBarHeight)]
        bottomBar.layer.masksToBounds = false
        bottomBar.layer.shadowColor = UIColor.lightGray.cgColor
        bottomBar.layer.shadowOpacity = 1
        bottomBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        bottomBar.layer.shadowRadius = 2
        
        
        let myAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)]
        let myAttribute2 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular), NSForegroundColorAttributeName: UIColor.lightGray]
        let myString = NSMutableAttributedString(string: "\(name)\n", attributes: myAttribute)
        let attrString = NSMutableAttributedString(string: "\(address)", attributes: myAttribute2)
        myString.append(attrString)
        bottomBar.button.setAttributedTitle(myString, for: .normal)
        
        if self.gmsPlace != nil{
            bottomBar.addSubview(arrowButton)
            arrowButton <- [Right(10), CenterY(), Width(30), Height(30)]
            bottomBar.button.addTarget(self, action: #selector(self.bottomButtonTapped), for: .touchUpInside)
            nextViewController = NextViewController()
            nextViewController.gmsPlace = self.gmsPlace
            nextViewController.gmsLocation = self.gmsLocation
            nextViewController.rootViewController = self
            nextViewController.transitioningDelegate = self
            nextViewController.modalPresentationStyle = .fullScreen
            
            presentInteractor = MiniToLargeViewInteractive()
            presentInteractor.attachToViewController(self, withView: bottomBar, presentViewController: nextViewController)
            dismissInteractor = MiniToLargeViewInteractive()
            dismissInteractor.attachToViewController(nextViewController, withView: nextViewController.view, presentViewController: nil)
        } else {
            arrowButton.removeFromSuperview()
            nextViewController = nil
            presentInteractor = nil
        }
    }
    
    func bottomButtonTapped() {
        disableInteractivePlayerTransitioning = true
        if nextViewController != nil{
            self.present(nextViewController, animated: true) { [unowned self] in
                self.disableInteractivePlayerTransitioning = false
            }
            nextViewController = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        prepareView(name: marker.title!, address: marker.snippet!)
        return true
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    func showAlertWithMessage(message: String) {
        let alertController = UIAlertController(title: "GMapsDemo", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            
        }
        
        alertController.addAction(closeAction)
        
        present(alertController, animated: true, completion: nil)
    }

}

extension ViewController{
    func showRestaurantOnMap(placeId: String, location: String){
        
        if locationMarker2 != nil {
            locationMarker2.map = nil
        }
        
        if locationMarker != nil{
            locationMarker.map = nil
        }
        if !placeId.isEmpty{
            MapTasks.sharedInstance.placeDetailRequest(placeId: placeId, success:
                {[weak self] userDetail in
                    
                    self?.gmsPlace = userDetail
                    let name = self?.gmsPlace?.name
                    let address = self?.gmsPlace?.formattedAddress
                    let latitude = self?.gmsPlace?.latitude
                    let longitude = self?.gmsPlace?.longitude
                    let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                    
                    self?.setupPOILocationMarker(coordinate:coordinate, name: name!, address: address!)
                    
                    let target = coordinate
                    self?.mapView?.camera = GMSCameraPosition.camera(withTarget: target, zoom: 12)
                    self?.gmsLocation = nil
                    
                }, failure: { errorDescription in
                    print(errorDescription)
            })
        } else {
            MapTasks.sharedInstance.geocodeAddress(address: location, withCompletionHandler: {[weak self] (status, success) -> Void in
                if !success {
                    
                    if status == "ZERO_RESULTS" {
                        self?.showAlertWithMessage(message: "The location could not be found.")
                    }
                }
                else {
                    let coordinate = CLLocationCoordinate2D(latitude: (MapTasks.sharedInstance.fetchedAddressLatitude)!, longitude: (MapTasks.sharedInstance.fetchedAddressLongitude)!)
                    self?.gmsPlace = nil
                    self?.gmsLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    
                    self?.mapView?.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 14.0)
                    self?.setupLongPressedAndSearchedLocationMarker(coordinate: coordinate)
                    
                }
                
            })

        }
        
    }
    
}


extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MiniToLargeViewAnimator()
        animator.initialY = BottomBar.bottomBarHeight
        animator.transitionType = .present
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MiniToLargeViewAnimator()
        animator.initialY = BottomBar.bottomBarHeight
        animator.transitionType = .dismiss
        return animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard !disableInteractivePlayerTransitioning else { return nil }
        return presentInteractor
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard !disableInteractivePlayerTransitioning else { return nil }
        return dismissInteractor
    }
}


