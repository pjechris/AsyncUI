import XCTest
import AsyncUI
import Combine

class InputActionTests: XCTestCase {
    func test_canExecute_notDefinedAtInit_returnTrue() {
        let action = Action {
            Empty()
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
}
