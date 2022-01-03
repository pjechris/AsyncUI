import SwiftUI
import AsyncUI

struct ContentView: View {
  var body: some View {
    ScrollView {
      asyncButton
      publisherButton
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
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ContentView()
    }
  }
}
