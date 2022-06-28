import Foundation
import Combine

extension Action where Input == Void {
    /// init the action by supplying when it is enabled or not and the closure to run
    public convenience init<K: Publisher, P: Publisher>(canExecute: K, execute: @escaping () -> P)
    where K.Output == Bool, K.Failure == Never, P.Output == Output, P.Failure == Error {

        self.init(canExecute: canExecute) { _ in
            execute()
        }
    }

    /// Convenience init to use when the action should always be enabled
    public convenience init<P: Publisher>(execute: @escaping () -> P) where P.Output == Output, P.Failure == Error {
        self.init { _ in execute() }
    }

    public func callAsFunction() {
        self.callAsFunction(())
    }
}

extension Action where Input == Void, Output == Void {
    /// init the action by supplying when it is enabled or not and run a synchronous closure
    public convenience init<K: Publisher>(canExecute: K, execute: @escaping () throws -> Void)
    where K.Output == Bool, K.Failure == Never {
        self.init(canExecute: canExecute) { _ in try execute() }
    }

    /// Creates an  action that should always be enabled and run a synchronous closure
    public convenience init(execute: @escaping () throws -> Void) {
        self.init { _ in try execute() }
    }
}
