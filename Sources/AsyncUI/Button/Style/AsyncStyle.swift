import SwiftUI

/// A style that apply custom appearance to all async views
public protocol AsyncStyle: ViewModifier { }

extension AsyncStyle where Self == DefaultAsyncStyle {
  static var `default`: DefaultAsyncStyle { DefaultAsyncStyle() }
}

/// The default async style view implementation
public struct DefaultAsyncStyle: AsyncStyle {
  @Environment(\.isExecuting) var isExecuting

  public func body(content: Content) -> some View {
    ZStack {
      content
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
        .opacity(isExecuting ? 1 : 0)
    }
  }
}
