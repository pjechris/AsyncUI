import Foundation
import Combine

extension Action {
    /// init the action by supplying when it is enabled or not and run a synchronous closure
    public convenience init<K: Publisher>(canExecute: K, execute: @escaping (Input) throws -> Output)
    where K.Output == Bool, K.Failure == Never {

        let publisherExecute: (Input) -> AnyPublisher<Output, Error> = {
            do {
                return Just(try execute($0)).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            catch {
                return Fail<Output, Error>(error: error).eraseToAnyPublisher()
            }
        }

        self.init(canExecute: canExecute, execute: publisherExecute)
    }

    /// Creates an  action that should always be enabled and run a synchronous closure
    public convenience init(execute: @escaping (Input) throws -> Output) {
        self.init(canExecute: Just(true), execute: execute)
    }
}
