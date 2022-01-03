import SwiftUI

/// A button executing a asynchronous task on tap
public struct AsyncButton<Label: View>: View {
  public let action: () async -> Void
  @ViewBuilder public let label: () -> Label
  
  @State var isExecuting = false
  
  public init(action: @escaping () async -> Void, @ViewBuilder label: @escaping () -> Label) {
    self.action = action
    self.label = label
  }
  
  public var body: some View {
    Button(action: runAction) {
      label().modifier(DefaultAsyncStyle())
    }
    .disabled(isExecuting)
    .environment(\.isExecuting, isExecuting)
  }
  
  private func runAction() {
    Task {
      isExecuting = true
      await action()
      isExecuting = false
    }
  }

}
