import SwiftUI
import Combine

/// A button executing an asynchronous action on tap
public struct AsyncButton<Label: View, P: Publisher>: View {
  public let action: () -> P
  @ViewBuilder public let label: Label
  
  @State var cancellables: Set<AnyCancellable> = Set()
  @State var isExecuting = false
  
  @Environment(\.defaultAsyncStyle) var style
  
  public var body: some View {
    Button(
      action: executeAction,
      label: { label.modifier(style ?? AnyModifier(EmptyModifier())) }
    )
      .disabled(isExecuting)
  }
  
  func executeAction() {
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
      AsyncButton(
        action: { Just("Nothing") },
        label: { Text("test") },
        cancellables: [],
        isExecuting: false
      )
        .background(Color.blue)
        .foregroundColor(.black)
      
      AsyncButton(
        action: { Just("Nothing") },
        label: { Text("test") },
        cancellables: [],
        isExecuting: true
      )
        .background(Color.red)
    }
    .previewLayout(.sizeThatFits)
  }
}
