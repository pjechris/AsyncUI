import SwiftUI

/// Environment key for async style
struct DefaultAsyncStyleKey: EnvironmentKey {
  static var defaultValue: Bool = true
}

extension EnvironmentValues {
  /// a boolean indicating whether default async style should be applied on the view
  public var defaultAsyncStyleEnabled: Bool {
    get { self[DefaultAsyncStyleKey.self] }
    set { self[DefaultAsyncStyleKey.self] = newValue }
  }
}

extension View {
  public func enableDefaultAsyncStyle(_ enable: Bool) -> some View {
    self
      .environment(\.defaultAsyncStyleEnabled, enable)
  }
}
