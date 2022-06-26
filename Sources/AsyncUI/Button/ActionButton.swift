import SwiftUI
import Combine

/// A button executing a `Publisher` action on tap
public struct ActionButton<Label: View, Output>: View {
  @ObservedObject var action: InputAction<Void, Output>
  @ViewBuilder public let label: () -> Label

  public init(action: InputAction<Void, Output>, @ViewBuilder label: @escaping () -> Label) {
    self._action = ObservedObject(wrappedValue: action)
    self.label = label
  }

  public var body: some View {
    Button(action: runAction) {
      label()
        .modifier(DefaultAsyncStyle())
    }
    .disabled(!action.isEnabled)
    .environment(\.isExecuting, action.isExecuting)
  }

  private func runAction() {
    action()
  }
}

struct ActionButton_Previews: PreviewProvider {
  static var previews: some View {
    ActionButton(
      action: InputAction<Void, String> { Just("Nothing").setFailureType(to: Error.self) },
      label: { Text("test") }
    )
    .background(Color.blue)
    .foregroundColor(.black)
    .previewDisplayName("action not running")
    .previewLayout(.sizeThatFits)
  }
}
