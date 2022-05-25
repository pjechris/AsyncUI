import Foundation
import Combine

extension Action {
    /// Create an action using an object function as the action
    ///
    /// Because we cannot reference functions using keypath you'll have to pass it as a static non instance function.
    /// For instance `MyViewViewModel.doSomething(_:)`
    ///
    /// - Parameter canExecute: a signal saying whether the action is enabled or not
    /// - Parameter object: the object to execute the action on. Action do **NOT** keep a strong reference on it.
    public convenience init<T: AnyObject, P: Publisher, K: Publisher>(
        object: T,
        enabledIf: K,
        execute: @escaping (T) -> (Input) -> P
    ) where P.Output == Output, P.Failure == Error, K.Output == Bool, K.Failure == Never {
        self.init(canExecute: enabledIf) { [weak object] input -> AnyPublisher<P.Output, P.Failure> in
            guard let object = object else {
                return Empty().eraseToAnyPublisher()
            }
            
            return execute(object)(input).eraseToAnyPublisher()
        }
    }
    
    public convenience init<T: AnyObject, P: Publisher, K: Publisher>(
        object: T,
        enabledIf enabledIfKeyPath: KeyPath<T, K>,
        execute: @escaping (T) -> (Input) -> P
    ) where P.Output == Output, P.Failure == Error, K.Output == Bool, K.Failure == Never {
        self.init(object: object, enabledIf: object[keyPath: enabledIfKeyPath], execute: execute)
    }
}
