//
//  Location.swift
//  Preserve
//
//  Created by The Atlanta Goat on 12/10/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import Foundation
//This Location Object is made of a struct that will hold the location properties for each To Do item
//This Object will be used as a property for the Item Object

import CoreLocation

struct Location: Equatable{
    
    let name: String
    let coordinate: CLLocationCoordinate2D?
    
    private let nameKey = "nameKey"
    
    private let latitudeKey = "latitudeKey"
    
    private let longitudeKey = "longitudeKey"

    
    var plistDict: [String:Any] {
            
            var dict = [String:Any]()
            
            dict[nameKey] = name
            
            if let coordinate = coordinate {
                
                dict[latitudeKey] = coordinate.latitude
                dict[longitudeKey] = coordinate.longitude
            }
            return dict
        }
    
    init(name: String, coordinate: CLLocationCoordinate2D? = nil) {
        
        self.name = name
        self.coordinate = coordinate
        
    }
    
    init?(dict: [String:Any]) {
        
        guard let name = dict[nameKey] as? String else { return nil}
        
        let coordinate: CLLocationCoordinate2D?
        
        if let latitude = dict[latitudeKey] as? Double,
            let longitude = dict[longitudeKey] as? Double {
            
            coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        } else {
            
            coordinate = nil
        }
        
        self.name = name
        self.coordinate = coordinate
 
    }
    
}


//This is a public function that is required by the Equatable protocol in order to check if two location objects are the same or not.
//You have to break objects down to their core and by that I mean this function provides an if statement for the Location.coordinate.latitude and also an if statement for Location.coordinate.longitude to check for equality
//Equality isn't automatic for custom created objects but may be found in cocoa touch framework ojbects.  See documentation for confirmation
func ==(lhs: Location, rhs: Location) -> Bool{
    
    if lhs.name != rhs.name{
        
        return false
    }
    
    if lhs.coordinate?.latitude != rhs.coordinate?.latitude{
        
        return false
    }
    
    if lhs.coordinate?.longitude != rhs.coordinate?.longitude{
        
        return false
    }
    
    return true
    
}
