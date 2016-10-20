//
//  DetailViewController.swift
//  iTrips
//
//  Created by Pavan Gopal on 19/10/16.
//  Copyright © 2016 Pavan Gopal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class DetailViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var imagesArray = [UIImage]()
    var scrollViewWidth:CGFloat = 0
    var xPosition : CGFloat = 0
    
    var place : GMSPlace?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        scrollView.delegate = self
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
         scrollViewWidth = self.scrollView.frame.size.width
         xPosition = 0
        getphotosForPlaceId((place?.placeID)!)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func getphotosForPlaceId(placeId:String){
        let placesClient = GMSPlacesClient.sharedClient()
        LoadingController.instance.showLoadingForSender(self)
        placesClient.lookUpPhotosForPlaceID(placeId) { (photos, error) in
            if error == nil && photos != nil{
                self.pageControl.numberOfPages = photos!.results.count
                for index in 0..<photos!.results.count{
                        self.loadImageForMetadata(photos!.results[index])
                    
                }
            }else{
                print("error getting photos")
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
    
        GMSPlacesClient.sharedClient()
            .loadPlacePhoto(photoMetadata, constrainedToSize: self.scrollView.bounds.size,
                            scale: (UIApplication.sharedApplication().keyWindow?.screen.scale)!) { (photo, error) -> Void in
                                if let error = error {
                                    // TODO: handle the error.
                                    print("Error: \(error.description)")
                                } else if photo != nil{
                                    self.imagesArray.append(photo!)
                                    
                                    let imageView = UIImageView(frame:CGRectMake(self.xPosition, 0, (self.scrollView.frame.size.width), (self.scrollView.frame.size.height)))
                                    self.xPosition = self.xPosition + self.scrollView.frame.size.width
                                    self.scrollView.contentSize = CGSize(width: self.scrollViewWidth, height: self.scrollView.frame.size.height)
                                    self.scrollViewWidth = self.scrollViewWidth + self.scrollView.frame.size.width
                                    imageView.image = photo
                                    imageView.contentMode = .ScaleAspectFill
                                    self.scrollView.addSubview(imageView)
                                    
                                    
                                }
        }
        
        
        LoadingController.instance.hideLoadingView()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension DetailViewController : UITableViewDelegate,UITableViewDataSource,TitleCellDelegate{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let titleCell = tableView.dequeueReusableCellWithIdentifier(String(TitleCell), forIndexPath: indexPath) as! TitleCell
        titleCell.delegate = self
        titleCell.updateCellWithData(place!)
        
        return titleCell
    }
  
    
    func call() {
        let phoneNumber = place!.phoneNumber
            if let url = NSURL(string: "tel://\(phoneNumber)"){
                if UIApplication.sharedApplication().canOpenURL(url){
                    UIApplication.sharedApplication().openURL(url)
                }else{
                    let alertController = UIAlertController.init(title: "Error", message: "Cannot make this call", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }

            }else{
                let alertController = UIAlertController.init(title: "Error", message: "Cannot make this call", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func direction() {

        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?center=\(place?.coordinate.latitude),\(place?.coordinate.longitude)&zoom=14&views=traffic")!)
        } else {
            print("Can't use comgooglemaps://");
            let alertController = UIAlertController.init(title: "Error", message: "Cannot open google maps", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        
        }
    }

    func website() {
        
            let WebController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(String(WebViewController)) as! WebViewController
            WebController.url = place!.website
        self.navigationController?.pushViewController(WebController, animated: true)
    }
    
    
}