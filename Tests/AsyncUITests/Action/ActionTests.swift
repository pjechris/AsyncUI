import XCTest
import AsyncUI
import Combine

class ActionTests: XCTestCase {
    func test_canExecute_notDefinedAtInit_returnTrue() {
        let action = Action {
            Empty<Void, Error>()
        }
        
        XCTAssertTrue(action.canExecute)
    }
    
    func test_execute_callMultipleTimes_executeOnlyOnce() {
        let expectation = XCTestExpectation()
        let nonFinishingPublisher = PassthroughSubject<Void, Error>()
        let action = Action { () -> PassthroughSubject<Void, Error> in
            expectation.fulfill()
            return nonFinishingPublisher
        }
        
        action()
        action()
        
        expectation.assertForOverFulfill = true
        wait(for: [expectation], timeout: 1)
    }
    
    func test_execute_actionIsMarkedAsExecuting() {
        let nonFinishingPublisher = PassthroughSubject<Void, Error>()
        let action = Action { () -> PassthroughSubject<Void, Error> in
            return nonFinishingPublisher
        }
        
        action()
        
        XCTAssertTrue(action.isExecuting)
    }
}
