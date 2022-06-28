import SwiftUI
import AsyncUI
import Combine

class ActionViewModel: ObservableObject {
  @Published var isEnabled = true
  @Published var length = 10
  @Published var randomString = ""
  @Published var delay: RunLoop.SchedulerTimeType.Stride = 2
  @Published var generateRandomString: InputAction<Void, Void>!

  init() {
    generateRandomString = InputAction(on: self, canExecute: $isEnabled, execute: ActionViewModel.generateString)
  }

  private func generateString(_ void: Void) -> AnyPublisher<Void, Error> {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    return Just(())
      .delay(for: delay, scheduler: RunLoop.main)
      .map { _ in self.randomString = String((0..<self.length).map{ _ in letters.randomElement()! }) }
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
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
