import SwiftUI
import AsyncUI

struct ContentView: View {
  var body: some View {
    ScrollView {
      asyncButton
      publisherButton
      actionButton
    }
  }
  
  private var asyncButton: some View {
    GroupBox(label: Label("async/await button", systemImage: "network")) {
      AsyncButtonExample()
    }
  }
  
  private var publisherButton: some View {
    GroupBox(label: Label("async publisher button", systemImage: "network")) {
      PublisherButtonExample()
    }
  }

  private var actionButton: some View {
    GroupBox(label: Label("action button", systemImage: "network")) {
      ActionButtonExample()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ContentView()
    }
  }
}
