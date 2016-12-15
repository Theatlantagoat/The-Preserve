//
//  PreserveUITests.swift
//  PreserveUITests
//
//  Created by The Atlanta Goat on 12/14/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import XCTest

class PreserveUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        
        continueAfterFailure = false
        
        XCUIApplication().launch()

        
    }
    
    override func tearDown() {

        super.tearDown()
    }
    
    func testExample() {
        
        XCUIDevice.shared().orientation = .faceUp
        
        let app = XCUIApplication()
        app.navigationBars["ToDo.ItemListView"].buttons["Add"].tap()
        let titleTextField = app.textFields["Title"]
        titleTextField.tap()
        titleTextField.typeText("Meeting")
        let dateTextField = app.textFields["Date"]
        dateTextField.tap()
        dateTextField.typeText("02/22/2016")
        let locationNameTextField = app.textFields["Location"]
        locationNameTextField.tap()
        locationNameTextField.typeText("Office")
        let addressTextField = app.textFields["Address"]
        addressTextField.tap()
        addressTextField.typeText("Infinite Loop 1, Cupertino")
        let descriptionTextField = app.textFields["Description"]
        descriptionTextField.tap()
        descriptionTextField.typeText("Bring iPad")
        app.buttons["Save"].tap()
        
    }
    
}
