import SwiftUI

/// Environment key for async style
struct AsyncStyleKey: EnvironmentKey {
  static var defaultValue: AnyModifier? = AnyModifier(DefaultAsyncStyle())
}

extension EnvironmentValues {
  /// a default view style to apply on an async view
  public var defaultAsyncStyle: AnyModifier? {
    get { self[AsyncStyleKey.self] }
    set { self[AsyncStyleKey.self] = newValue }
  }
}
