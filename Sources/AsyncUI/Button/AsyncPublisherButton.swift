import SwiftUI
import Combine

/// A button executing a `Publisher` action on tap
public struct AsyncPublisherButton<Label: View, P: Publisher>: View {
  public let action: () -> P
  @ViewBuilder public let label: () -> Label
  
  @State var cancellables: Set<AnyCancellable> = []
  @State var isExecuting = false
  
  public init(action: @escaping () -> P, @ViewBuilder label: @escaping () -> Label) {
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
    isExecuting = true
    
    action()
      .sink(
        receiveCompletion: { _ in
          isExecuting = false
        },
        receiveValue: { _ in }
      )
      .store(in: &cancellables)
  }
}

struct AsyncPublisherButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AsyncPublisherButton(
        action: { Just("Nothing") },
        label: { Text("test") }
      )
        .background(Color.blue)
        .foregroundColor(.black)
        .previewDisplayName("action not running")
    }
    .previewLayout(.sizeThatFits)
  }
}
