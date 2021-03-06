//
//  ItemListDataProviderTests.swift
//  Preserve
//
//  Created by The Atlanta Goat on 12/12/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import XCTest
@testable import Preserve

extension ItemListDataProviderTests{
    
    class MocktableView: UITableView {
        
        var cellGotDequeued = false
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            
            cellGotDequeued = true
            
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
    
        class func mockTableViewWithDataSourece(dataSourece: UITableViewDataSource) -> MocktableView{
            
            let mockTableView = MocktableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .plain)
            
            mockTableView.dataSource = dataSourece
            
            mockTableView.register(MockItemCell.self, forCellReuseIdentifier: "ItemCell")
            
            return mockTableView
        }
    }
}

class MockItemCell: ItemCell {
    
    var toDoItem: ToDoItem?
    
    override func configCellWithItem(item: ToDoItem, checked: Bool = false){
        
        toDoItem = item
    }
}

class ItemListDataProviderTests: XCTestCase {
    
    var sut: ItemListDataProvider!
    
    var tableView: UITableView!
    
    var controller: ItemListViewController!
    
    override func setUp() {
        
        super.setUp()
        
        sut = ItemListDataProvider()
        
        sut.itemManager = ItemManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        controller = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        
        _ = controller.view
        
        tableView = controller.tableView
        
        tableView.dataSource = sut
        
        tableView.delegate = sut
    }
    
    override func tearDown() {
        
        sut.itemManager?.removeAllItems()
        super.tearDown()
    }
    
    func testNumberOfSections_IsTwo(){
        
        let numberOfSections = tableView.numberOfSections
        
        XCTAssertEqual(numberOfSections, 2)
        
    }
    
    func test_DelegateNumberRowsInFirstSection_IsToDoCount(){
        
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.itemManager?.addItem(item: ToDoItem(title: "Second"))
        
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
        
    }
    
    func testNumberRowsInSecondSection_IsDoneCount(){
        
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        
        sut.itemManager?.addItem(item: ToDoItem(title: "Second"))
        
        sut.itemManager?.checkItemAtIndex(index: 0)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        
        sut.itemManager?.checkItemAtIndex(index: 0)
        
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }
    
    func testCellForRow_ReturnsItemCell(){
        
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell is ItemCell)
    }
    
    func testCellForRow_DequeuesCell(){
        
        let mockTableView = MocktableView.mockTableViewWithDataSourece(dataSourece: sut)
        
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockTableView.cellGotDequeued)
    }
    
    func testConfigCell_GetsCalledInCellForRow(){
        
        let mockTableView = MocktableView.mockTableViewWithDataSourece(dataSourece: sut)
        
        let toDoItem = ToDoItem(title: "First", itemDescription: "First description")
        
        sut.itemManager?.addItem(item: toDoItem)
        
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockItemCell
        
        XCTAssertEqual(cell.toDoItem, toDoItem)
    }
    
    func testCellinSectionTwo_GetsConfiguredWithDoneItem(){
        
       let mockTableView = MocktableView.mockTableViewWithDataSourece(dataSourece: sut)
        
        let firstItem = ToDoItem(title: "First", itemDescription: "First description")
        
        let secondItem = ToDoItem(title: "Second", itemDescription: "Second description")
        
        let thirdItem = ToDoItem(title: "Third", itemDescription: "Third description")
        
        sut.itemManager?.addItem(item: firstItem)
        
        sut.itemManager?.addItem(item: secondItem)
        
        sut.itemManager?.addItem(item: thirdItem)
        
        sut.itemManager?.checkItemAtIndex(index: 2)
        
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockItemCell
                
        XCTAssertEqual(cell.toDoItem, thirdItem)
        
    }
    
    func testDeletionButtonInFirstSection_ShowsTitleCheck(){
        
        let deletButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(deletButtonTitle, "Check")
    }
    
    func testDeletionButtonFirstSection_ShowsTitleUncheck(){
        
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(deleteButtonTitle, "Uncheck")
    }
    
    func testCheckingAnItem_ChecksItInTheItemManager(){
        
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sut.itemManager?.toDoCount, 0)
        
        XCTAssertEqual(sut.itemManager?.doneCount, 1)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        
    }
    
    func testUncheckingAnItem_UnchecksItInTheItemManager(){
        
        sut.itemManager?.addItem(item: ToDoItem(title: "First"))
        
        sut.itemManager?.checkItemAtIndex(index: 0)
        
        tableView.reloadData()
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(sut.itemManager?.toDoCount, 1)
        
        XCTAssertEqual(sut.itemManager?.doneCount, 0)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 0)
    }
    //starts on page 156
    func Removed_test_SelectingACell_SendNotification() {
        
        let item = ToDoItem(title: "First")
        
        sut.itemManager?.addItem(item: item)
        
        expectation(forNotification: "ItemSelectedNotification", object: nil) { (notification) -> Bool in
            
            guard let index = notification.userInfo?["index"] as? Int else { return false }
            
            return index == 0
        }
        
    
        
        tableView.delegate?.tableView!(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}
