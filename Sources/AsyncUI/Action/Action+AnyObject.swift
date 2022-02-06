import Foundation

extension Action {
    public convenience init<P: Publisher, I: AnyObject>(
        canExecute: AnyPublisher<Bool, Never> = Just(true).eraseToAnyPublisher(),
        instance: I,
        execute: @escaping (I) -> (Input) -> P
    ) where P.Output == Output, P.Failure == Error {
        self.init(canExecute: canExecute) { [weak instance] input in
            instance.map { instance in execute(instance)(input).eraseToAnyPublisher() }
            ?? Empty().eraseToAnyPublisher()
        }
    }
}
