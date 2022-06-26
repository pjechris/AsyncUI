import SwiftUI
import AsyncUI
import Combine

class ActionViewModel: ObservableObject {
  @Published var isEnabled = true
  @Published var length = 10
  @Published var randomString = ""
  @Published var generateRandomString: InputAction<Void, Void>!

  init() {
    generateRandomString = InputAction(on: self, canExecute: $isEnabled, execute: ActionViewModel.generateString)
  }

  private func generateString(_ void: Void) -> AnyPublisher<Void, Error> {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    randomString = String((0..<length).map{ _ in letters.randomElement()! })

    return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
}

struct ActionButtonExample: View {
  @StateObject var viewModel = ActionViewModel()

  var body: some View {
    VStack {
      Button(action: toggle) {
        Text(viewModel.isEnabled ? "Disable the action" : "Enable the action")
      }

      ActionButton(action: viewModel.generateRandomString) {
        Text("Generate a random string")
      }
      .buttonStyle(.borderedProminent)

      if !viewModel.randomString.isEmpty {
        Text("Last generared string: \(viewModel.randomString)")
          .font(.caption)
      }
    }

  }

  func toggle() {
    viewModel.isEnabled.toggle()
  }

}

struct ActionButtonExample_Previews: PreviewProvider {
  static var previews: some View {
    ActionButtonExample()
  }
}
