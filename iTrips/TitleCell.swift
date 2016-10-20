//
//  TitleCell.swift
//  iTrips
//
//  Created by Pavan Gopal on 20/10/16.
//  Copyright © 2016 Pavan Gopal. All rights reserved.
//

import UIKit
import Cosmos
import GooglePlaces
import GoogleMaps

protocol TitleCellDelegate {
    func direction()
    func call()
    func website()
}

class TitleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var cosmosView: CosmosView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBOutlet weak var mapView: UIView!
    
    var delegate : TitleCellDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func updateCellWithData(place:GMSPlace){
        
        titleLabel.text = place.name
        if place.rating > 0{
            cosmosView.hidden = false
            ratingLabel.hidden = false
            let numberOfRatings = Int(place.rating * 25)
            cosmosView.text = "(\(numberOfRatings))"
            cosmosView.rating = Double(place.rating)
            ratingLabel.text = String(place.rating)
        }else{
            cosmosView.hidden = true
            ratingLabel.hidden = true
            
        }
        descriptionLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged"
      
        let mapFrame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 177)
        
        Map.instance.createMapWithFrame(mapFrame)
        Map.instance.mapViewInstance.myLocationEnabled = true
        mapView.addSubview(Map.instance.mapViewInstance)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
        Map.instance.mapViewInstance.myLocationEnabled = true
        marker.title = place.name
        marker.snippet = place.phoneNumber
        marker.map = Map.instance.mapViewInstance
        marker.map?.animateToCameraPosition(GMSCameraPosition.init(target: Map.instance.marker.position, zoom: 13, bearing: 0, viewingAngle: 0))
        mapView.userInteractionEnabled = false
        
    }
    
    
    
    @IBAction func directionButtonPressed(sender: UIButton) {
        delegate?.direction()
    }
    @IBAction func callButtonPressed(sender: UIButton) {
        delegate?.call()
    }
    
    @IBAction func webisteButtonPressed(sender: AnyObject) {
        delegate?.website()
    }
    
    

}
