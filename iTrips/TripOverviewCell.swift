//
//  TripOverviewCell.swift
//  iTrips
//
//  Created by Pavan Gopal on 16/10/16.
//  Copyright © 2016 Pavan Gopal. All rights reserved.
//

import UIKit
import GooglePlaces
import Cosmos

class TripOverviewCell: UICollectionViewCell {
    
    @IBOutlet weak var placeImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var ratingsCountLabel: UILabel!
    
    @IBOutlet weak var cosmosRatingView: CosmosView!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
//        let imageView = UIImageView()
////        imageView.image = UIImage(named: "card background")
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.backgroundColor = UIColor.whiteColor()
        
    }
    
    func updateCellData(data:GMSPlace){
        placeImage.image = UIImage()
        
        self.getphotosForPlaceId((data.placeID))
        titleLabel.text = data.name.capitalizedString
        descriptionLabel.text = data.formattedAddress
        
        if data.openNowStatus == .Yes{
            statusLabel.text = "OPEN UNTIL 6:00 PM"
            statusLabel.textColor = ConstantColor.CWGreen
        }else if data.openNowStatus == .No{
            statusLabel.text = "Closed NOW"
            statusLabel.textColor = ConstantColor.CWRed
        }else{
            statusLabel.text = "OPEN UNTIL 6:00 PM"
            statusLabel.textColor = ConstantColor.CWGreen
        }
        if data.rating > 0{
            cosmosRatingView.hidden = false
            ratingLabel.hidden = false
            let numberOfRatings = Int(data.rating * 25)
            cosmosRatingView.text = "(\(numberOfRatings))"
            cosmosRatingView.rating = Double(data.rating)
            ratingLabel.text = String(data.rating)
        }else{
            cosmosRatingView.hidden = true
            ratingLabel.hidden = true
            
        }
        
    }
    
    func getphotosForPlaceId(placeId:String){
        let placesClient = GMSPlacesClient.sharedClient()
        placesClient.lookUpPhotosForPlaceID(placeId) { (photos, error) in
            if error == nil {
                if let firstPhoto = photos?.results.first{
                    self.loadImageForMetadata(firstPhoto)
                }
            }else{
                print("error getting photos")
            }
        }
        
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.sharedClient()
            .loadPlacePhoto(photoMetadata, constrainedToSize: placeImage.bounds.size,
                            scale: self.placeImage.window!.screen.scale) { (photo, error) -> Void in
                                if let error = error {
                                    // TODO: handle the error.
                                    print("Error: \(error.description)")
                                } else {
                                    self.placeImage.image = photo;
                                    self.placeImage.contentMode = .ScaleAspectFill
                                }
        }
    }
    
    
}
