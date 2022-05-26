import Foundation
import Combine

/// An action with no input (nor output)
public typealias Action = InputAction<Void, Void>

extension Action {    
    public func callAsFunction() {
        self.callAsFunction(())
    }
}
