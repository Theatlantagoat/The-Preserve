//
//  ToDoItem.swift
//  Preserve
//
//  Created by The Atlanta Goat on 11/15/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import Foundation
//This Object is a struct that consists of the properties for a To Do item.  A to do item has four properties: a title, an item description, a timestamp, and a location
//The title, itemdescription, and timestamp will be standard swift library types
//The location will be a custom object that uses the core location framework using CLLCoordinates
//This is the parent object which will serve as the blueprint where children are formed as each separate To Do Items

struct ToDoItem: Equatable{
    let title: String
    let itemDescription: String?
    let timestamp: Double?
    let location: Location?
    
    private let titleKey = "titleKey"
    
    private let itemDescriptionKey = "itemDescriptionKey"
    
    private let timestampKey = "timestampKey"
    
    private let locationKey = "locationKey"
    
    var plistDict: [String:Any] {
        
        var dict = [String:Any]()
        
        dict[titleKey] = title
        
        if let itemDescription = itemDescription {
            dict[itemDescriptionKey] = itemDescription
        }
        if let timestamp = timestamp {
            dict[timestampKey] = timestamp
        }
        if let location = location {
            let locationDict = location.plistDict
            dict[locationKey] = locationDict
        }
        return dict
    }
    
    init(title: String, itemDescription: String? = nil, timestamp: Double? = nil, location: Location? = nil) {
        
        self.title = title
        self.itemDescription = itemDescription
        self.timestamp = timestamp
        self.location = location
    }
    
    init?(dict: [String:Any]) {
        
        guard let title = dict[titleKey] as? String else { return nil }
        
        self.title = title
        
        self.itemDescription = dict[itemDescriptionKey] as? String
        self.timestamp = dict[timestampKey] as? Double
        if let locationDict = dict[locationKey] as? [String:Any] {
            self.location = Location(dict: locationDict)
        }else{
            self.location = nil
        }
    }


}

//This public function is required based on the Equatable protocol in order to check objects for equality.  We don't want two To Do Items to be same which would be in the same list.  That would be a bug.
func ==(lhs: ToDoItem, rhs: ToDoItem)-> Bool{
    
    if lhs.location != rhs.location{
        
        return false
    }
    
    if lhs.timestamp != rhs.timestamp{
        
        return false
    }
    
    if lhs.itemDescription != rhs.itemDescription{
        
        return false
    }
    
    if lhs.title != rhs.title{
        
        return false
    }
    
    return true
    
}
