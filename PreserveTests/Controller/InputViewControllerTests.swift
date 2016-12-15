//
//  InputViewControllerTests.swift
//  Preserve
//
//  Created by The Atlanta Goat on 12/13/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Preserve


extension InputViewControllerTests {
    
    
    class MockGeocoder: CLGeocoder {
        
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            
            self.completionHandler = completionHandler
        }
    }
    
    class MockPlaceMark: CLPlacemark {
        
        var mockCoordinate: CLLocationCoordinate2D?
        
        override var location: CLLocation? {
            
            guard let coordinate = mockCoordinate else { return CLLocation() }
            
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        
    }
    
    class MockInputViewController: InputViewController {
        
        var dismissGotCalled = false
        
        var completionHandler: (() -> Void)?
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            
            dismissGotCalled = true
            
            completionHandler?()
        }
    }
    
}

class InputViewControllerTests: XCTestCase {
    
    var sut: InputViewController!
    
    var placemark: MockPlaceMark!
    
    override func setUp() {
        
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        
        _ = sut.view
        
    }
    
    override func tearDown() {
        
        sut.itemManager?.removeAllItems()
        super.tearDown()
    }
    
    func test_HasTextFieldsAndButtons() {
        
        XCTAssertNotNil(sut.titleTextField)
        
        XCTAssertNotNil(sut.dateTextField)
        
        XCTAssertNotNil(sut.locationTextField)
        
        XCTAssertNotNil(sut.addressTextField)
        
        XCTAssertNotNil(sut.descriptionTextField)
        
        XCTAssertNotNil(sut.saveButton)
        
        XCTAssertNotNil(sut.cancelButton)
        
    }
    
    func testSave_UsesGeocoderToGetCoordinateFromAddress(){
        
        let mockSut = MockInputViewController()
        mockSut.titleTextField = UITextField()
        mockSut.dateTextField = UITextField()
        mockSut.locationTextField = UITextField()
        mockSut.addressTextField = UITextField()
        mockSut.descriptionTextField = UITextField()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let timestamp = 1456095600.0
        let date = Date(timeIntervalSince1970: timestamp)
        mockSut.titleTextField.text = "Foo"
        mockSut.dateTextField.text = dateFormatter.string(from: date)
        mockSut.locationTextField.text = "Bar"
        mockSut.addressTextField.text = "Infinite Loop 1, Cupertino"
        mockSut.descriptionTextField.text = "Baz"
        let mockGeocoder = MockGeocoder()
        mockSut.geocoder = mockGeocoder
        mockSut.itemManager = ItemManager()
        let dismissExpectation = expectation(description: "Dismiss")
        mockSut.completionHandler = {
            dismissExpectation.fulfill()
        }
        mockSut.save()
        placemark = MockPlaceMark()
        
        let coordinate = CLLocationCoordinate2DMake(37.3316851,
                                                    -122.0300674)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        waitForExpectations(timeout: 1, handler: nil)
        let item = mockSut.itemManager?.itemAtIndex(index: 0)
        let testItem = ToDoItem(title: "Foo",
                                itemDescription: "Baz",
                                timestamp: timestamp,
                                location: Location(name: "Bar", coordinate: coordinate))
        
        XCTAssertEqual(item, testItem)
        mockSut.itemManager?.removeAllItems()
        
        
    }
    
    func test_SaveButtonHasSaveAction(){
        
        let saveButton: UIButton = sut.saveButton
        
        guard let actions = saveButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            
            XCTFail(); return
        }
        
        XCTAssertTrue(actions.contains("save"))
    }
    
    func Removed_test_GeocoderWorksAsExpected(){
        
        let expectationGeocodeTest = expectation(description: "Wait for geocode")
        
        CLGeocoder().geocodeAddressString("Infinite Loop 1, Cupertino", completionHandler: {
            
            (placemarks, error) -> Void in
            
            let placemark = placemarks?.first
            
            let coordinate = placemark?.location?.coordinate
            
            guard let latitude = coordinate?.latitude else {
                
                
                XCTFail()
                
                return
            }
            
            guard let longitude = coordinate?.longitude else {
                
                XCTFail()
                
                return
            }
            
            XCTAssertEqualWithAccuracy(latitude, 37.3316941, accuracy: 0.000001)
            
            
            XCTAssertEqualWithAccuracy(longitude, -122.030127, accuracy: 0.000001)
            
            
            expectationGeocodeTest.fulfill()
            
        })
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testSave_DismissesViewController() {
        
        let mockInputViewController = MockInputViewController()
        
        mockInputViewController.titleTextField = UITextField()
        
        mockInputViewController.dateTextField = UITextField()
        
        mockInputViewController.locationTextField = UITextField()
        
        mockInputViewController.addressTextField = UITextField()
        
        mockInputViewController.descriptionTextField = UITextField()
        
        mockInputViewController.titleTextField.text = "Test Title"
        
        mockInputViewController.save()
        
        XCTAssertTrue(mockInputViewController.dismissGotCalled)
        
    }
    
}


