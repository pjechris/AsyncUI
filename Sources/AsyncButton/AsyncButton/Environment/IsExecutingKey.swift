import SwiftUI

/// Environment key for `isExecuting`
struct IsExecutingKey: EnvironmentKey {
  static var defaultValue: Bool { false }
}

extension EnvironmentValues {
  /// whether the surrounded action is currently running
  public var isExecuting: Bool {
    get { self[IsExecutingKey.self] }
    set { self[IsExecutingKey.self] = newValue }
  }
}
