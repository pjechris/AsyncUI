import Foundation
import Combine

/// An action with no input (nor output)
public typealias Action = InputAction<Void, Void>

extension InputAction where Input == Void {    
    public func callAsFunction() {
        self.callAsFunction(())
    }
}
