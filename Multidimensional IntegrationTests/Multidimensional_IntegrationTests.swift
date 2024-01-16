//
//  Multidimensional_IntegrationTests.swift
//  Multidimensional IntegrationTests
//
//  Created by Jeff_Terry on 1/15/24.
//

import XCTest

final class Multidimensional_IntegrationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testStringParsing() throws {
        
        let integrationLimitsText = "0.0, 1.0\n2.0, 3.0\n4.0, 5.0\n6.0, 7.0\n"
        
        let returnLimits = parseString(stringWithParameters: integrationLimitsText, separator: ", ")
        
        XCTAssertEqual(returnLimits.0[3], 6.0, accuracy: 1E-7, "Print does not match")
        XCTAssertEqual(returnLimits.1[1], 3.0, accuracy: 1E-7, "Print does not match")
        
        
        
    }
    
    func testVolume() throws {
        
        let myVolumeBox = BoundingBox()
        
        let dimensions = 5
        
        let lowerBound = [0.0, -2.0, 3.0, 4.0, 1.0]
        let upperBound = lowerBound.map{($0 + 2.0)}
        
        myVolumeBox.initWithDimensionsAndRanges(dimensions: dimensions, lowerBound: lowerBound, upperBound: upperBound)
        
        XCTAssertEqual(myVolumeBox.volume, pow(2.0, Double(dimensions)), accuracy: 1E-7, "Print does not match" )
        
        
    }
    
/*
    func testIntegrationOfEToTheMinusX() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var testValue = 3.14159
        var readout = "Bob"
        
        let myQueue = DispatchQueue(label:"etotheminusxTest")
        //let myContentView = ContentView()
        
        myContentView.dimensions = 1.0
        myContentView.exact = -exp(-1.0) + exp(0.0)
        myContentView.functionForIntegration = eToTheMinusX
        
       
        
        myQueue.sync{
            
             myContentView.integration(iterations: 16, guesses: 32000, lowerLimit: [0.0], upperLimit: [1.0], theQueue: myQueue)
            
            
            
        
            sleep(10)
            
            
        }
        
        myQueue.sync{
            
            testValue = myContentView.integral
            readout = myContentView.integralValue
        }
        
        
        XCTAssertEqual(testValue, myContentView.exact, accuracy: 1.5e-3, "Print it should have been closer.")
        
        
    
    }

    func testIntegrationOfEToTheX() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var testValue = 3.14159
        
        let myQueue = DispatchQueue(label:"etothexTest")
        
        myViewController.dimensions = 1.0
        myViewController.exact = exp(1.0) - exp(0.0)
        myViewController.functionForIntegration = eToTheX
        
        
        myQueue.sync{
            
           myViewController.integration(iterations: 16, guesses: 32000, lowerLimit: [0.0], upperLimit: [1.0], theQueue: myQueue)
            
            
        }
        
        myQueue.sync{
            
            testValue = self.myViewController.integral
            
        }
        
        
        XCTAssertEqual(testValue, self.myViewController.exact, accuracy: 1.5e-3, "Print it should have been closer.")
        
        
    
    }
    
    func testIntegrationOf10DIntegral() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var testValue = 3.14159
        
        let lowerLimit = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        let upperLimit = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]

        let myQueue = DispatchQueue(label:"10DIntegralTest")
        
        myViewController.dimensions = 10.0
        myViewController.exact = 155.0/6.0
        myViewController.functionForIntegration = tenDIntegral
        
        
        myQueue.sync{
            
            myViewController.integration(iterations: 16, guesses: 320001, lowerLimit: lowerLimit, upperLimit: upperLimit, theQueue: myQueue)
            
            
        }
        
        myQueue.sync{
            
            testValue = self.myViewController.integral
            
        }
        
        
        XCTAssertEqual(testValue, self.myViewController.exact, accuracy: 1.5e-2, "Print it should have been closer.")
        
        
    
    }
 
 */

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
