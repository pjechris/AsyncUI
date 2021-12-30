import SwiftUI
import Combine

/// A button executing a `Publisher` action on tap
public struct AsyncPublisherButton<Label: View, P: Publisher>: View {
  public let action: () -> P
  @ViewBuilder public let label: Label
  
  @State var cancellables: Set<AnyCancellable> = Set()
  @State var isExecuting = false
  
  public var body: some View {
    Button(
      action: executeAction,
      label: { label.modifier(DefaultAsyncStyle()) }
    )
      .disabled(isExecuting)
  }
  
  private func executeAction() {
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

struct AsyncButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AsyncPublisherButton(
        action: { Just("Nothing") },
        label: { Text("test") },
        cancellables: [],
        isExecuting: false
      )
        .background(Color.blue)
        .foregroundColor(.black)
        .previewDisplayName("action not running")
      
      AsyncPublisherButton(
        action: { Just("Nothing") },
        label: { Text("test") },
        cancellables: [],
        isExecuting: true
      )
        .background(Color.red)
        .previewDisplayName("action running")
    }
    .previewLayout(.sizeThatFits)
  }
}
