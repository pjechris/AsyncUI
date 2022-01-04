import SwiftUI

/// The default async style view implementation
struct DefaultAsyncStyle: ViewModifier {
  @Environment(\.isExecuting) var isExecuting
  @Environment(\.defaultAsyncStyleEnabled) var isEnabled

  public func body(content: Content) -> some View {
    ZStack {
      content
        .opacity(isExecuting ? 0.5 : 1)
      
      if isEnabled {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
          .opacity(isExecuting ? 1 : 0)
      }
    }
  }
}

struct DefaultAsyncStyle_Previews: PreviewProvider {
  static var previews: some View {
    Button(action: { }) {
      Text("Test Default style")
    }
    .modifier(DefaultAsyncStyle())
    .environment(\.isExecuting, true)
    .environment(\.defaultAsyncStyleEnabled, true)
  }
}
