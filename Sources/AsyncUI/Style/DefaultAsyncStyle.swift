import SwiftUI

/// The default async style view implementation
struct DefaultAsyncStyle: ViewModifier {
  @Environment(\.isExecuting) var isExecuting
  @Environment(\.defaultAsyncStyleEnabled) var isEnabled

  public func body(content: Content) -> some View {
    ZStack {
      content
      
      if isEnabled {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
          .opacity(isExecuting ? 1 : 0)
      }
    }
  }
}
