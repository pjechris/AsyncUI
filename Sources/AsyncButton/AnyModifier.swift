import SwiftUI

public struct AnyModifier: ViewModifier {
  var _body: (Any) -> AnyView

  public init<T: ViewModifier>(_ modifier: T) {
    _body = { AnyView(modifier.body(content:$0 as! T.Content)) }
  }

  public func body(content: Content) -> AnyView {
    _body(content)
  }
}
