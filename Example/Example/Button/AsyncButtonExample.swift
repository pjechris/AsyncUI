import SwiftUI
import AsyncUI

struct AsyncButtonExample: View {
  var body: some View {
    AsyncButton(action: runAsyncAction) {
      Text("Tap the button to trigger an async task")
      
    }
    .buttonStyle(.borderedProminent)
  }
  
  func runAsyncAction() async {
    try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
  }
  
}

struct AsyncButtonExample_Previews: PreviewProvider {
  static var previews: some View {
    AsyncButtonExample()
  }
}
