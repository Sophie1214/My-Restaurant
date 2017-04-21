//
//  RestaurantPickingViewController.swift
//  My Restaurants
//
//  Created by 苏菲 on 2017-03-26.
//  Copyright © 2017 Sophie. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class RestaurantPickingViewController: UIViewController {

    var pickingView: PickingView!
    var pickedView = PickedView(frame: CGRect.zero)
    let leftDoor = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    let rightDoor = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    var audioPlayer: AVAudioPlayer!
    var audioPlayer2: AVAudioPlayer!
    
    var openNowStatus: Bool?
    var distance: Int?
    var filterdTags = [String]()
    
    var restaurants = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = #imageLiteral(resourceName: "filter").maskWithColor(color: .white)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addFilter))
        
        pickingView = PickingView(frame: self.view.frame)
        self.view.addSubview(pickingView)
        pickingView.controller = self
        
        pickedView.frame = self.view.frame
        self.view.addSubview(pickedView)
        pickedView.controller = self
        pickedView.isHidden = true
        
        self.view.addSubview(leftDoor)
        leftDoor.frame = CGRect(x: 0, y: -UIScreen.main.bounds.height/2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
        
        self.view.addSubview(rightDoor)
        rightDoor.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
        
//        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: "slide-rock", ofType: "aif")!)
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        do{
            let url = URL(string: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_begin.caf")
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.prepareToPlay()
            
            let url2 = URL(string: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_end.caf")
            audioPlayer2 = try AVAudioPlayer(contentsOf: url2!)
            audioPlayer2.prepareToPlay()

        } catch{
            print("erorr")
        }
        // Do any additional setup after loading the view.
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        animationAndFetch()
    }
    
    func animationAndFetch(){
        if audioPlayer != nil{
            self.audioPlayer.play()
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.leftDoor.frame = CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
            self.rightDoor.frame = CGRect(x: 0, y: UIScreen.main.bounds.height/2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
        }, completion: { (finished: Bool) in
            self.fetchFromCoreData()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                if self.audioPlayer2 != nil{
                    self.audioPlayer2.play()}
            }
            UIView.animate(withDuration: 0.3, delay: 0.4, options: [.curveEaseInOut], animations: {
                self.leftDoor.frame = CGRect(x: 0, y: -UIScreen.main.bounds.height/2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                self.rightDoor.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
            })
        })
    }
    
    func buttonTapped(){
        animationAndFetch()
    }
    
    func fetchFromCoreData(){
        let managedObject = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = managedObject.persistentContainer.viewContext
        
        do{
            
            let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Restaurant")
            request.sortDescriptors = [NSSortDescriptor(
                key: "initial",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            let results = try managedObjectContext.fetch(request) as! [NSManagedObject]
            if results.count == 0{
                
                let alert = UIAlertController(title: "Alert", message: "No restaurant found", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            else{
                let randomIndex = Int(arc4random_uniform(UInt32(results.count)))
                pickedView.restaurant = results[randomIndex]
                self.pickedView.isHidden = false
            }
            
        } catch{
            print("error")
        }
        
    }

    func addFilter(){
        let filterTable = FilterTableViewController()
        filterTable.pickingController = self
        filterTable.highlightedTags = filterdTags
        if openNowStatus != nil{
            filterTable.openNowStatus = self.openNowStatus!
        }
        if distance != nil{
            filterTable.distance = self.distance!
        }
        self.navigationController?.pushViewController(filterTable, animated: true)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
