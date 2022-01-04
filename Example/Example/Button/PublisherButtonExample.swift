import SwiftUI
import AsyncUI
import Combine

struct PublisherButtonExample: View {
  @State var cancellables: Set<AnyCancellable> = []
  
  var body: some View {
    AsyncPublisherButton(action: runPublisher) {
      Text("Tap the button to run a Publisher")
    }
    .buttonStyle(.borderedProminent)
  }
  
  func runPublisher() -> some Publisher {
    Just(()).delay(for: 2, scheduler: RunLoop.main)
  }
}

struct PublisherButtonExample_Previews: PreviewProvider {
  static var previews: some View {
    PublisherButtonExample()
  }
}
