//
//  Trip.swift
//  iTrips
//
//  Created by Pavan Gopal on 16/10/16.
//  Copyright © 2016 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces
import GoogleMaps

let kAPIKEY1 = "AIzaSyAkYAO1gIUKAxnSg-goQyRDRvU8uj61ZVk"
let kAPIKEY2 = "AIzaSyAI7k38l_qxvzEOmBfg3uoutWZZmDT4zjY"
let kAPIKEY3 = "AIzaSyBiGeC0sSMzO9-TDl8Wt1RJs_VfA7u0cvo"

let kApiKeyUsed = kAPIKEY2

let kEmptyString: String = ""
let types = "zoo|amusement_park|art_gallery|church|hindu_temple|mosque|museum|night_club|park|place_of_worship|shopping_mall"


let topPlaces = "zoo|art_gallery|park"
let temples = "church|hindu_temple|mosque"
let outDoors = "casino|amusement_park|art_gallery|museum|park|shopping_mall"
let inDoors = "art_gallery|museum|night_club|place_of_worship|shopping_mall"
let kidFriendly = "zoo|amusement_park|park"

let radius = "50000" // 50km


class Map :NSObject{
    
    static let instance = Map()
    var mapViewInstance = GMSMapView()
    var marker = GMSMarker()
    
    private  override init() {
    }
    
    func createMapWithFrame(frame:CGRect){
        let camera = GMSCameraPosition.cameraWithLatitude(12.9716, longitude: 77.5946, zoom: 13)

        let mapView = GMSMapView.mapWithFrame(frame, camera: camera)
        
        self.mapViewInstance = mapView
    }
}

struct ConstantColor {
    static let CWBlue = UIColor(red: 0/255.0, green: 132/255.0, blue: 255/255.0, alpha: 1.0)
    static let CWOrange = UIColor(red: 255/255.0, green: 165/255.0, blue: 0/255.0, alpha: 1.0)
    static let CWGreen = UIColor(red: 32/255.0, green: 169/255.0, blue: 117/255.0, alpha: 1.0)
    static let CWYellow = UIColor(red: 255/255.0, green: 211/255.0, blue: 92/255.0, alpha: 1.0)
    static let CWRed = UIColor(red: 212/255.0, green: 73/255.0, blue: 66/255.0, alpha: 1.0)
    static let CWButtonGray = UIColor.grayColor()
    static let CWLightGray = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
    static let CWBlackWithAlpa = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    
}

