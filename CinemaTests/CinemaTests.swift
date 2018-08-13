//
//  CinemaTests.swift
//  CinemaTests
//
//  Created by Water Su on 2018/8/6.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import XCTest
@testable import Cinema

class CinemaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddMovie() {
        // test for duplicate movie
        let aMovie = Movie(data: [:])
        aMovie.id = "12345"
        _ = MovieManager.shared.exposeAppendMovie(aMovie)
        _ = MovieManager.shared.exposeAppendMovie(aMovie)
        _ = MovieManager.shared.exposeAppendMovie(aMovie)
        XCTAssert(MovieManager.shared.objectCount() == 1, "append movie function cause duplicate")
    }
    func testAPIKey(){
        if let apiKey = Secrets.shared.getSecret(for: .APIKey){
            XCTAssert(apiKey.count > 0, "API Key length = 0")
        }else{
            XCTAssert(false, "Missing API Key")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
