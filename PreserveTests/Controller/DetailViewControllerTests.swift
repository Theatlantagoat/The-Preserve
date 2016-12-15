//
//  DetailViewControllerTests.swift
//  Preserve
//
//  Created by The Atlanta Goat on 12/12/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Preserve

class DetailViewControllerTests: XCTestCase {
    
    var sut: DetailViewController!
    
    override func setUp() {
        
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        _ = sut.view
        
    }
    
    override func tearDown() {
       
        sut.itemInfo?.0.removeAllItems()
        super.tearDown()
    }
    
    func test_HasLabels(){
        
        XCTAssertNotNil(sut.titleLabel)
        
        XCTAssertNotNil(sut.locationLabel)
        
        XCTAssertNotNil(sut.dateLabel)
        
        XCTAssertNotNil(sut.descriptionLabel)
    }
    
    func test_HasMapView(){
        
        XCTAssertNotNil(sut.mapView)
        
    }
    
    func testSettingItemInfo_SetsTextsToLabels(){
        
        let coordinate = CLLocationCoordinate2D(latitude: 51.2277, longitude: 6.7735)
        
        let itemManager = ItemManager()
        
        itemManager.addItem(item: ToDoItem(title: "The title", itemDescription: "The description", timestamp: 1456150025, location: Location(name: "Home", coordinate: coordinate)))
        
        sut.itemInfo = (itemManager, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        
        sut.endAppearanceTransition()
        
        XCTAssertEqual(sut.titleLabel.text, "The title")
        
        XCTAssertEqual(sut.descriptionLabel.text, "The description")
        
        XCTAssertEqual(sut.dateLabel.text, "02/22/2016")
        
        XCTAssertEqual(sut.locationLabel.text, "Home")
        
        XCTAssertEqualWithAccuracy(sut.mapView.centerCoordinate.latitude, coordinate.latitude, accuracy: 0.001)
        
        
    }
    
    func testCheckItem_ChecksItemInItemManager(){
        
        let itemManager = ItemManager()
        
        itemManager.addItem(item: ToDoItem(title: "The title"))
        
        sut.itemInfo = (itemManager, 0)
        
        sut.checkItem()
        
        XCTAssertEqual(itemManager.toDoCount, 0)
        
        XCTAssertEqual(itemManager.doneCount, 1)
    }
    
}
