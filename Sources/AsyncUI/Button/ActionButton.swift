import SwiftUI
import Combine

/// A Button tailored for executing an `InputAction`
public struct ActionButton<Label: View, Output>: View {
  @ObservedObject var action: InputAction<Void, Output>
  @ViewBuilder public let label: () -> Label

  /// Create a button that display a custom label
  /// - Parameter action: The action to perform when the user triggers the button
  /// - Parameter label: A view that describe the purpose of the button’s action
  public init(action: InputAction<Void, Output>, @ViewBuilder label: @escaping () -> Label) {
    self.action = action
    self.label = label
  }

  public var body: some View {
    Button(action: { action() }) {
      label()
        .modifier(DefaultAsyncStyle())
    }
    .disabled(!action.isEnabled)
    .environment(\.isExecuting, action.isExecuting)
  }
}

extension ActionButton {
    /// Creates a button that generate its label from a localized string key
    public init(_ titleKey: LocalizedStringKey, action: InputAction<Void, Output>) where Label == Text {
        self.init(action: action) {
            Text(titleKey)
        }
    }

    /// Creates a button that generate its label from a string
    public init<S: StringProtocol>(_ title: S, action: InputAction<Void, Output>) where Label == Text {
        self.init(action: action) {
            Text(title)
        }
    }
}

struct ActionButton_Previews: PreviewProvider {
  static var previews: some View {
    var increment = 0
    let action = Action { () -> Empty in
      increment += 1
      return Empty()
    }

    ActionButton(
      action: action,
      label: { Text("\(increment) clicks") }
    )
    .background(Color.blue)
    .foregroundColor(.black)
    .previewDisplayName("action not running")
    .previewLayout(.sizeThatFits)
  }
}
