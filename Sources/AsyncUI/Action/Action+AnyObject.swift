import Foundation
import Combine

extension Action {
    /// Create an action using an object function as the action. You generally use it by passing the `execute` argument
    /// as a static reference function.
    /// 
    /// Example: InputAction(on: self, canExecute: $isEnabled, execute: Self.generateString)
    ///
    /// - Parameter canExecute: a signal saying whether the action is enabled or not
    /// - Parameter on: the object to execute the action on. Action do **NOT** keep a strong reference on it.
    /// - Parameter execute: the object method. For instance `MyViewViewModel.doSomething(_:)`
    public convenience init<T: AnyObject, P: Publisher, K: Publisher>(
        on object: T,
        canExecute: K,
        execute: @escaping (T) -> (Input) -> P
    ) where P.Output == Output, P.Failure == Error, K.Output == Bool, K.Failure == Never {
        self.init(canExecute: canExecute) { [weak object] input -> AnyPublisher<P.Output, P.Failure> in
            guard let object = object else {
                return Empty().eraseToAnyPublisher()
            }
            
            return execute(object)(input).eraseToAnyPublisher()
        }
    }
}
