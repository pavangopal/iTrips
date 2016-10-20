//
//  Trip.swift
//  iTrips
//
//  Created by Pavan Gopal on 16/10/16.
//  Copyright © 2016 Pavan Gopal. All rights reserved.
//

import Foundation
import Alamofire


enum Router : URLRequestConvertible {
    static let baseURLString = "https://maps.googleapis.com/maps/api/place/"

    case GetGoogleData(radius : String, query: String, ll: String)
    
    var method: Alamofire.Method{
        switch (self) {
        case .GetGoogleData:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .GetGoogleData(let radius, let query, let ll):
            return "nearbysearch/json?location=\(ll)&radius=\(radius)&type=\(query)&key=\(kApiKeyUsed)"
  
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        guard let URL = NSURL(string: Router.baseURLString) else{
            print("DEADLY ERROR : URL CREATION FAILED")
            return NSMutableURLRequest()
            
        }
        let encodedURL = path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        guard let url = NSURL(string: "\(encodedURL)", relativeToURL:URL) else{
            print("DEADLY ERROR : PATH CREATION FAILED")
            return NSMutableURLRequest()
        }
        
        let mutableURLRequest = NSMutableURLRequest(URL: url)
        mutableURLRequest.HTTPMethod = method.rawValue
        
        
        switch self {
        //More cases can be handled here
        default:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        }
    }
}