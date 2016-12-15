//
//  APIClientTests.swift
//  Preserve
//
//  Created by The Atlanta Goat on 12/13/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import XCTest
@testable import Preserve


extension APIClientTests {

    class MockURLSession: SessionProtocol {
    
    var url: URL?
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        self.url = url
        
        return URLSession.shared.dataTask(with: url)
        
        }
    }
}



class APIClientTests: XCTestCase {
    
    override func setUp() {
        
        super.setUp()
       
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func test_Login_UsesExpectedURL(){
        
        let sut = APIClient()
        
        let mockURLSession = MockURLSession()
        
        sut.session = mockURLSession
        
        let completion = { (token: Token?, error: Error?) in }
        
        sut.loginUser(withName: "dasdom", password: "1234", completion: completion)
        
        guard let url = mockURLSession.url else { XCTFail(); return }
    
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        XCTAssertEqual(urlComponents?.host, "awesometodos.com")
        
        XCTAssertEqual(urlComponents?.path, "/login")
        
        XCTAssertEqual(urlComponents?.query, "username=dasdom&password=1234")
    

        
    }
    
}



