//
//  ItemListViewControllerTests.swift
//  Preserve
//
//  Created by The Atlanta Goat on 12/11/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import XCTest
@testable import Preserve

class ItemListViewControllerTests: XCTestCase {
    
    var sut: ItemListViewController!
    
    override func setUp() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        
        _ = sut.view
        
        super.setUp()
        
    }
    
    override func tearDown() {
        
        super.tearDown()
        
    }
    
    func test_TableViewIsNotNilAfterViewDidLoad(){
        
        XCTAssertNotNil(sut.tableView)
    }
    
    func testViewDidLoad_ShouldSetTableViewDataSource(){
        
        XCTAssertNotNil(sut.tableView.dataSource)
        
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
        
    }
    
    func testViewDidLoad_ShouldSetTableViewDelegate(){
        
        XCTAssertNotNil(sut.tableView.delegate)
        
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }
    
    func testViewDidLoad_ShouldSetDelegateAndDataSourceToTheSameObject(){
        
        XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider, sut.tableView.delegate as? ItemListDataProvider)
    }
    
    
    func test_ItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        
        let target = sut.navigationItem.rightBarButtonItem?.target
        
        XCTAssertEqual(target as? UIViewController, sut)
        
    }
    
    func test_AddItem_PresentAddItemViewController(){
        
        XCTAssertNil(sut.presentedViewController)
        
        guard let addButton = sut.navigationItem.rightBarButtonItem else { XCTFail(); return }
        
        guard let action = addButton.action else { XCTFail(); return }
        
        UIApplication.shared.keyWindow?.rootViewController = sut
        
        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)
        
        XCTAssertNotNil(sut.presentedViewController)
        
        XCTAssertTrue(sut.presentedViewController is InputViewController)
        
        let inputViewController = sut.presentedViewController as! InputViewController
        
        XCTAssertNotNil(inputViewController.titleTextField)
    }
    
    func testItemListVC_SharesItemManagerWithInputVC(){
        
        guard let addButton = sut.navigationItem.rightBarButtonItem else { XCTFail(); return }
        
        guard let action = addButton.action else { XCTFail(); return }
        
        UIApplication.shared.keyWindow?.rootViewController = sut
        
        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)
        
        guard let inputViewController = sut.presentedViewController as? InputViewController else { XCTFail(); return }
        
        guard let inputItemManager = inputViewController.itemManager else {XCTFail(); return }
        
        XCTAssertTrue(sut.itemManager === inputItemManager)
        
        //my assert
        XCTAssertEqual(sut.itemManager, inputItemManager)
    }
    
    func test_ViewDidLoad_SetsItemManagerToDataProvider() {
        
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }
    
    func testItemSelectedNotification_PushesDetailVC(){
        
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        
        _ = sut.view
        
        NotificationCenter.default.post(name: NSNotification.Name("ItemSelectedNotification"), object: self, userInfo: ["index": 1])
        
        guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else { XCTFail(); return }
        
        guard let detailItemManager = detailViewController.itemInfo?.0 else { XCTFail(); return }
        
        guard let index = detailViewController.itemInfo?.1 else { XCTFail(); return }
        
        _ = detailViewController.view
        
        XCTAssertNotNil(detailViewController.titleLabel)
        
        XCTAssertTrue(detailItemManager === sut.itemManager)
        
        XCTAssertEqual(index, 1)
        
    }
}

extension ItemListViewControllerTests {
    
    class MockNavigationController: UINavigationController {
        
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            
            pushedViewController = viewController
            
            super.pushViewController(viewController, animated: animated)
        }
    }
}
