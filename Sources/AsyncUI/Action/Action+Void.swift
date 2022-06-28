import Foundation
import Combine

extension Action where Input == Void {    
    public func callAsFunction() {
        self.callAsFunction(())
    }
}
