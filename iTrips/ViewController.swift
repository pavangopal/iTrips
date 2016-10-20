//
//  ViewController.swift
//  iTrips
//
//  Created by Pavan Gopal on 15/10/16.
//  Copyright © 2016 Pavan Gopal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire


class ViewController: UIViewController,UIGestureRecognizerDelegate {

//    @IBOutlet weak var customMapView: UIView!
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var locationManager = CLLocationManager()
    var placeIDArray = [String]()
    var latLongInString = String()
    var placesArray = [GMSPlace]()
    var customMapView = UIView()
    let lineView = UIView(frame: CGRectMake(0, 48, 125, 3))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineView.backgroundColor = ConstantColor.CWBlue
        getcurrentLocation()
        self.collectionVIew.pagingEnabled = true
        setupSearchBar()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        createTabBar()
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        createMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSearchBar(){
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        self.definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        self.definesPresentationContext = true
        self.navigationController!.navigationBar.translucent = false
        searchController!.hidesNavigationBarDuringPresentation = false
        
        // This makes the view area include the nav bar even though it is opaque.
        // Adjust the view placement down.
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = UIRectEdge.Top
    }
    
    func getcurrentLocation(){
        let placesClient = GMSPlacesClient.sharedClient()
        locationManager.requestAlwaysAuthorization()
        
        placesClient.currentPlaceWithCallback({ (placeLikelihoods, error) -> Void in
            guard error == nil else {
                print("Current Place error: \(error!.localizedDescription)")
                return
            }
            
            if let placeLikelihoods = placeLikelihoods {
                let place = placeLikelihoods.likelihoods[0].place
                
                self.latLongInString = String(place.coordinate.latitude)
                self.latLongInString = self.latLongInString.stringByAppendingString(",")
                self.latLongInString = self.latLongInString.stringByAppendingString(String(place.coordinate.longitude))
                self.googleMapPlaceIdSearch(types)
                
            }
        })

    }
    
    func createMap(){
        let mapFrame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        
        Map.instance.createMapWithFrame(mapFrame)
        customMapView.frame = mapFrame
        Map.instance.mapViewInstance.myLocationEnabled = true
        customMapView.addSubview(Map.instance.mapViewInstance)
        self.view.addSubview(customMapView)
        self.view.bringSubviewToFront(collectionVIew)
    }
    
    func createTabBar(){
        
        let titleArray = ["TOP PLACES","TEMPLES","OUTDOORS","INDOORS","KID FRIENDLY"]
        
        let scrollViewWidth:CGFloat = 125*5
        
        for i in 0..<5{
            let xPosition = CGFloat(i*125)

            let view = UIButton(frame: CGRectMake(xPosition, 0, 125, 50))
            view.setTitle(titleArray[i], forState: .Normal)
            view.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            view.titleLabel?.font = UIFont.systemFontOfSize(14.0)
            view.tag = i
            view.addTarget(self, action: #selector(self.View1Pressed(_:)), forControlEvents: .TouchUpInside)
            scrollView.addSubview(view)
        }
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.whiteColor()
        self.scrollView.contentSize = CGSize(width: scrollViewWidth, height: 30)
        self.scrollView.addSubview(lineView)
        self.view.bringSubviewToFront(scrollView)
        
    }
    
    func View1Pressed(sender:UIButton){
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.lineView.frame.origin.x = sender.frame.origin.x
        })
        
        switch sender.tag{
        case 0:
            print("0")
            self.googleMapPlaceIdSearch(topPlaces)
            break
        case 1:
            print("1")
            self.googleMapPlaceIdSearch(temples)
            break
        case 2:
            print("2")
            self.googleMapPlaceIdSearch(outDoors)
            break
        case 3:
            print("3")
            self.googleMapPlaceIdSearch(inDoors)
            break
        case 4:
            print("4")
            self.googleMapPlaceIdSearch(kidFriendly)
        default:break
            
        }
        
    }

    
    func placeAutocomplete() {
        let placesClient = GMSPlacesClient.sharedClient()
        let filter = GMSAutocompleteFilter()
        filter.type = .Establishment
        
        placesClient.autocompleteQuery("", bounds: nil, filter: filter, callback: { (results, error: NSError?) -> Void in
            guard error == nil else {
                print("Autocomplete error \(error)")
                return
            }
            
            for result in results! {
                print("Result \(result.attributedFullText) with placeID \(result.placeID)")
            }
        })
    }

    func getAllPlaces(){
        let placesClient = GMSPlacesClient.sharedClient()
        let downloadGroup = dispatch_group_create()
        placesArray.removeAll()
        LoadingController.instance.showLoadingWithUserInteractionForSender(self)
        for i in placeIDArray{
            dispatch_group_enter(downloadGroup) // 3
            
            placesClient.lookUpPlaceID(i, callback: { (place, error) in
                if error == nil && place != nil {
                    
                    self.placesArray.append(place!)
                    
                }else{
                    print("error")
                }
                 dispatch_group_leave(downloadGroup)
            })
        }
        
        dispatch_group_notify(downloadGroup, dispatch_get_main_queue()) {
            print("Downloading finished")
            LoadingController.instance.hideLoadingView()
            self.collectionVIew.reloadData()
            if self.placesArray.count > 0 {
            self.collectionVIew?.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: .Left, animated: true)

            }
            
            
        }
    }
    
    
    func googleMapPlaceIdSearch(type :String){
        LoadingController.instance.showLoadingWithOverlayForSender(self, cancel: true)
        Alamofire.request(Router.GetGoogleData(radius: radius, query: type, ll: self.latLongInString)).responseJSON { response in
            switch response.result {
            case .Success(let JSON):
                print("Success with JSON1")
                
                guard let jsonData = JSON as? NSDictionary else{
                    print("Incorrect JSON from server : \(JSON)")
                    return
                }
                self.placeIDArray.removeAll()
                LoadingController.instance.hideLoadingView()
                var isSuccess = false
                if let response = jsonData.valueForKey("results") as? [NSDictionary]{
                    if  let array = response as NSArray? {
                        for item in array as! [NSDictionary] {
                            if let placeID = item.valueForKey("place_id") as? String {
                                self.placeIDArray.append(placeID)
                                isSuccess = true
                            }
                        }
                    }
                }
                
                if isSuccess == false {
                    let alertController = UIAlertController.init(title: kEmptyString, message: "Cannot retrieve data at the moment. Request quota exceeded.", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                self.getAllPlaces()
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                var message = error.localizedDescription
                if error.code == 403 {
                    message = "Session Expired"
                    NSLog(message)
                }
                let alertController = UIAlertController.init(title: kEmptyString, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}


extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let tripCell = collectionView.dequeueReusableCellWithReuseIdentifier(String(TripOverviewCell), forIndexPath: indexPath) as! TripOverviewCell
     tripCell.updateCellData(self.placesArray[indexPath.row])
        return tripCell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

            let detailController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(String(DetailViewController)) as! DetailViewController
            detailController.place = placesArray[indexPath.row]
            self.navigationController?.pushViewController(detailController, animated: true)

    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let place = placesArray[indexPath.row]
        
        Map.instance.marker.position = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
        
        Map.instance.marker.title = place.name
        Map.instance.marker.snippet = place.phoneNumber
        Map.instance.marker.map = Map.instance.mapViewInstance
        
        Map.instance.marker.map?.animateToCameraPosition(GMSCameraPosition.cameraWithTarget(Map.instance.marker.position, zoom: 13, bearing: 0, viewingAngle: 0))
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.width, height: 128)
    }
    
}


extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // User canceled the operation.
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}


extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWithPlace place: GMSPlace) {
        searchController?.active = false
        // Do something with the selected place.
        
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
    }
    
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: NSError){
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

