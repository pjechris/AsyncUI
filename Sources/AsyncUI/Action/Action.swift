import Foundation
import Combine

public class Action<Input, Output>: ObservableObject {
    @Published public private(set) var canExecute: Bool = false
    @Published public private(set) var isExecuting: Bool = false
    @Published public private(set) var result: Result<Output, Error>?
    
    private let action: (Input) -> AnyPublisher<Output, Error>
    private var cancellables: Set<AnyCancellable> = []
    
    public init<P: Publisher>(
        canExecute: AnyPublisher<Bool, Never> = Just(true).eraseToAnyPublisher(),
        execute: @escaping (Input) -> P
    ) where P.Output == Output, P.Failure == Error {
        self.action = { execute($0).eraseToAnyPublisher() }
        
        canExecute
            .sink { [weak self] in self?.canExecute = $0 }
            .store(in: &cancellables)
    }
    
    public convenience init<T: Publisher, P: Publisher>(canExecute: T, execute: @escaping (Input) -> P)
    where T.Output == Bool, T.Failure == Never, P.Output == Output, P.Failure == Error {
        self.init(canExecute: canExecute.eraseToAnyPublisher(), execute: execute)
    }
    
    public func callAsFunction(_ input: Input) {
        guard canExecute && !isExecuting else {
            return
        }
        
        action(input)
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.isExecuting = true },
                receiveCompletion: { [weak self] _ in self?.isExecuting = false },
                receiveCancel: { [weak self] _ in self?.isExecuting = false }
            )
            .sink(
                receiveCompletion: { [weak self] in
                    if case .failure(let error) = $0 {
                        self?.result = .failure(error)
                    }
                },
                receiveValue: { [weak self] in self?.result = .success($0) }
            )
            .store(in: &cancellables)
    }
}
