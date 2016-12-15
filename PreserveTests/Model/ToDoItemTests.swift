//
//  ToDoItemTests.swift
//  Preserve
//
//  Created by The Atlanta Goat on 11/15/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import XCTest
//import the Preserve module for testing
//keep tests on the left and production code on the right
@testable import Preserve
class ToDoItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit_InitToDoItem(){
        
        let firstToDoItem = ToDoItem(title: "First Item", itemDescription: nil)
        
        let secondToDoItem = ToDoItem(title: "First Item", itemDescription: nil)
        
        XCTAssertEqual(firstToDoItem.title, secondToDoItem.title)
    }
    
    func testInit_ShouldTakeTitle(){
        
        let item = ToDoItem(title: "Test title")
        
        XCTAssertNotNil(item, "item should not be nil")
        
        //XCTAssertNil(item.itemDescription)
    }
    
    func testInit_ShouldTakeTitleAndDescription(){
        
        let item = ToDoItem(title: "Test title", itemDescription: "Test description")
        
        XCTAssertEqual(item.itemDescription, "Test description")
    }
    
    func testInit_ShouldSetTitleAndDescriptionAndTimestamp(){
        
        let item = ToDoItem(title: "Test title", itemDescription: "Test description", timestamp: nil)
        
        XCTAssertEqual(nil, item.timestamp, "Initializer should set the timestamp")
    }
    
    func testInit_ShouldSetTitleAndDescriptionAndTimestampAndLocation(){
        
        let location = Location(name: "Test name")
        
        let item = ToDoItem(title: "Test title", itemDescription: "Test description", timestamp: nil, location: location)
        
        XCTAssertEqual("Test name", item.location?.name)
    }
    
    func testEqualItems_ShouldBeEqual(){
        
        let firstItem = ToDoItem(title: "First")
        
        let secondItem = ToDoItem(title: "First")
        
        XCTAssertEqual(firstItem, secondItem)
        
       
    }
    
    func testWhenLocationDifferes_ShouldBeNotEqual(){
        
        let firstItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 0.0, location: Location(name: "Home"))
        
        let secondItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 0.0, location: Location(name: "Office"))
        
        XCTAssertNotEqual(firstItem, secondItem)
        
    }
    
    func testWhenTwoTimestampValuesAreDifferent_ShouldBeNotEqual(){
        
        let firstItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 10, location: Location(name: "Home"))
        
        let secondItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 15, location: Location(name: "Home"))
        
        XCTAssertNotEqual(firstItem, secondItem)
        
    }
    
    func testWhenTwoItemDescriptionValuesAreDifferent_ShouldBeNotEqual(){
        
        let firstItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: nil, location: nil)
        
        let secondItem = ToDoItem(title: "First title", itemDescription: "Second description", timestamp: nil, location: nil)
        
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func testWhenTwoTitleValuesAreDifferent_ShouldBeNotEqual(){
        
        let firstItem = ToDoItem(title: "First")
        
        let secondItem = ToDoItem(title: "Second")
        
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func test_HasPlistDictionaryProperty(){
        
        let item = ToDoItem(title: "First")
        
        let dictionary = item.plistDict
        
        XCTAssertNotNil(dictionary)
        
        XCTAssertTrue(dictionary is [String:Any])
    }
    
    func test_CanBeCreatedFromPlistDictionary(){
        
        let location = Location(name: "Bar")
        
        let item = ToDoItem(title: "Foo", itemDescription: "Baz", timestamp: 1.0, location: location)
        
        let dict = item.plistDict
        
        let recreatedItem = ToDoItem(dict:dict)
        
        XCTAssertEqual(item, recreatedItem)
    }
}
