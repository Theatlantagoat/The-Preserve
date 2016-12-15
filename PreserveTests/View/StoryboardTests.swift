//
//  StoryboardTests.swift
//  Preserve
//
//  Created by The Atlanta Goat on 12/13/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import XCTest
@testable import Preserve

class StoryboardTests: XCTestCase {
    
    override func setUp() {
        
        
        super.setUp()
            }
    
    override func tearDown() {
        
        
        super.tearDown()
    }
    
    func test_InitialViewController_IsItemListViewController() {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        
        let rootViewController = navigationController.viewControllers[0]
        
        XCTAssertTrue(rootViewController is ItemListViewController)
    }
    
}
