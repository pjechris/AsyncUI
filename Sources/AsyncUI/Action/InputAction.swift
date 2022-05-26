import Foundation
import Combine

/// Represents a value that accept an action taking `Input` as its input and
/// producing an `Output` when executed.
///
/// Example: Create an action running only if user has permission
///
/// ```swift
/// class SomeClass: ObservableObject {
///     var deleteNote: Action<Void, Void>!
///     @Published var isUserAdmin = false
///
///     init() {
///         self.deleteNote = Action(canExecute: $isUserAdmin) { [weak self] in
///             self?.delete(note: $0)
///         }
///     }
///
///     func delete(note: Note) -> AnyPublisher<Void, Error> {
///         /// delete the note
///     }
/// }
/// ```
///
/// Alternatively you can also pass the object and its instance method in order to avoid using `weak` everytime:
///
/// ```swift
///     self.deleteNote = Action(on: self, canExecute: $isUserAdmin, execute: SomeClass.deleteNote(note:))
/// ```
public class InputAction<Input, Output>: ObservableObject {
    /// true if the action is can be executed. Has no effect if chaning *while* the action is already running
    @Published public private(set) var canExecute: Bool = false
    /// true if the action is currently running
    @Published public private(set) var isExecuting: Bool = false
    /// the last result from the action
    @Published public private(set) var result: Result<Output, Error>?
    
    private let action: (Input) -> AnyPublisher<Output, Error>
    private var cancellables: Set<AnyCancellable> = []
    
    /// init the action by supplying when it is enabled or not and the closure to run
    /// - Parameter canExecute: a publisher indicating whenever the action is enabled or not
    /// - Parameter execute: the action itself to run
    public init<K: Publisher, P: Publisher>(canExecute: K, execute: @escaping (Input) -> P)
    where K.Output == Bool, K.Failure == Never, P.Output == Output, P.Failure == Error {
        
        self.action = { execute($0).eraseToAnyPublisher() }
        
        canExecute
            .sink { [weak self] in self?.canExecute = $0 }
            .store(in: &cancellables)
    }
    
    /// Convenience init to use when the action should always be enabled
    /// - Parameter execute: the action itself to run
    public convenience init<P: Publisher>(execute: @escaping (Input) -> P) where P.Output == Output, P.Failure == Error {
        self.init(canExecute: Just(true).eraseToAnyPublisher(), execute: execute)
    }

    /// execute the action (if enabled) with given `input`.
    ///
    /// This is a special Swift method which can be called as regular function on the object.
    public func callAsFunction(_ input: Input) {
        guard canExecute && !isExecuting else {
            return
        }
        
        action(input)
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.isExecuting = true },
                receiveCompletion: { [weak self] _ in self?.isExecuting = false },
                receiveCancel: { [weak self] in self?.isExecuting = false }
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
