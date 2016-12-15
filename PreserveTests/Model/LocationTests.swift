//
//  LocationTests.swift
//  Preserve
//
//  Created by The Atlanta Goat on 12/10/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Preserve

class LocationTests: XCTestCase {
    
    override func setUp() {
        
        super.setUp()
       
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testInit_ShouldSetNameAndCoordinate(){
        
        let testCoordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        
        let location = Location(name: "", coordinate: testCoordinate)
        
        XCTAssertEqual(location.coordinate?.latitude, testCoordinate.latitude)
        
        XCTAssertEqual(location.coordinate?.longitude, testCoordinate.longitude)
    }
    
    func testWhenLatitudeDifferes_ShouldBeNotEqual(){
        
        let firstCoordinate = CLLocationCoordinate2D(latitude: 1.0, longitude: 0.0)
        
        let firstLocation = Location(name: "Home", coordinate: firstCoordinate)
        
        let secondCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        
        let secondLocation = Location(name: "Home", coordinate: secondCoordinate)
        
        XCTAssertNotEqual(firstLocation, secondLocation)
    }
    
    func testWhenLongitudeDifferes_ShouldBeNotEqual(){
        
        let firstCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 1.0)
        
        let firstLocation = Location(name: "Home", coordinate: firstCoordinate)
        
        let secondCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 2.0)
        
        let secondLocation = Location(name: "Home", coordinate: secondCoordinate)
        
        XCTAssertNotEqual(firstLocation, secondLocation)
    }
    
    func testLocationItemsWhoHaveDifferentNames_ShouldBeNotEqual(){
        
        let firstLocation = Location(name: "Atlanta")
        
        let secondLocation = Location(name: "Charlotte")
        
        XCTAssertNotEqual(firstLocation, secondLocation)
        
    }
    
    func test_CanBeSerializedAndDeserialized(){
        
        let location = Location(name: "Home", coordinate: CLLocationCoordinate2DMake(50.0, 6.0))
        
        let dict = location.plistDict
        
        XCTAssertNotNil(dict)
        
        let recreatedLocation = Location(dict: dict)
        
        XCTAssertEqual(location, recreatedLocation)
    }
    
    
}
