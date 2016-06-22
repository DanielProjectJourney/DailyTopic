//
//  DailyTopicTests.swift
//  DailyTopicTests
//
//  Created by Daniel on 29/04/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import XCTest
@testable import DailyTopic

class DailyTopicTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    //Test Email by Email format
    func testIsEmailValid(){
        let validEmails = ["daniel@gmail.com","prajeet@yahoo.com"]
        let inValidEmails = ["123!@.com","asdfads","12345","#test@gmail"]
        for validEmail in validEmails{
            XCTAssertEqual(Validator.isEmailValid(validEmail),true)
        }
        for invalidEmail in inValidEmails{
            XCTAssertEqual(Validator.isEmailValid(invalidEmail),false)
        }
        
    }
    
    //Test post topic by Topic Title Value
    func testPostTopic(){
        let validTopicTitle = "The Title With Text"
        let inValidTopicTitle = ""
        
        XCTAssertEqual(CreateTopicViewController.canPostTopic(validTopicTitle), true)
        XCTAssertEqual(CreateTopicViewController.canPostTopic(inValidTopicTitle), false)
    }
    
    //Test Login by email and password
    func testLogin(){
        
        //Right Email and Password
        let validEmail = "daniel@gmail.com"
        let validPassword = "daniel"
        
        
        //Email is null
        let inValidEmailNull = ""
        
        //Password is null
        let inValidPasswordNull = ""
        
        //Right Email and Password
        XCTAssertEqual(LoginViewController.canLogIn(validEmail, password: validPassword), true)
        
        //Email is Null
        XCTAssertEqual(LoginViewController.canLogIn(inValidEmailNull, password: validPassword),false)
        
        //Password is Null
        XCTAssertEqual(LoginViewController.canLogIn(validEmail, password: inValidPasswordNull), false)
    }
    
   
    //Test Topic Type (Message < 20 is Secret  &&  Message =>20 is Published )
    func testTopicType()
    {
        XCTAssertEqual(HomeViewController.identifyTopicType("Secret"), true)
        XCTAssertEqual(HomeViewController.identifyTopicType("Published"), true)
    }
    
}


















