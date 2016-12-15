//
//  ItemCellTests.swift
//  Preserve
//
//  Created by The Atlanta Goat on 12/12/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import XCTest
@testable import Preserve

extension ItemCellTests {
    
    class FakeDataSource: NSObject, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
    
}

class ItemCellTests: XCTestCase {
    
    var tableView: UITableView!
    
    override func setUp() {
        
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        
        _ = controller.view
        
        tableView = controller.tableView
        
        tableView?.dataSource = FakeDataSource()

    }
    
    override func tearDown() {
       
        super.tearDown()
    }
    
    func testSUT_HasNameLabel(){
        
        let cell = tableView?.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        
        XCTAssertNotNil(cell.titleLabel)
    }
    
    func testSUT_HasLocationLabel(){
        
        let cell = tableView?.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        
        XCTAssertNotNil(cell.locationLabel)
    }
    
    func testSUT_HasDateLabel(){
        
        let cell = tableView?.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        
        XCTAssertNotNil(cell.dateLabel)
    }
    
    func testConfigWithItem_SetsLabelTexts(){
        
        let cell = tableView?.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        
        cell.configCellWithItem(item: ToDoItem(title: "First", itemDescription: nil, timestamp: 1456150025, location: Location(name: "Home")))
        
        XCTAssertEqual(cell.titleLabel.text, "First")
        
        XCTAssertEqual(cell.locationLabel.text, "Home")
        
        XCTAssertEqual(cell.dateLabel.text, "02/22/2016")
    }
    
    func testTitle_ForCheckedTasks_IsStrokeThrough(){
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        
        let toDoItem = ToDoItem(title: "First", itemDescription: nil, timestamp: 1456150025, location: Location(name: "Home"))
        
        cell.configCellWithItem(item: toDoItem, checked: true)
        
        let attributedString = NSAttributedString(string: "First", attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        
        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
        
        XCTAssertNil(cell.locationLabel.text)
        
        XCTAssertNil(cell.dateLabel.text)
    }
}
