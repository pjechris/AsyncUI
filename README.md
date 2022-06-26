# AsyncUI

![swift](https://img.shields.io/badge/Swift-5.4%2B-orange?logo=swift&logoColor=white)
![platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS-lightgrey)
[![twitter](https://img.shields.io/badge/twitter-pjechris-1DA1F2?logo=twitter&logoColor=white)](https://twitter.com/pjechris)

Make your SwiftUI views with asynchronous code!

|                     | AsyncUI
|---------------------|--------
|      🤝             | Compatible with async/await (and Combine)
|      🎨             | First party asynchronous views
| :book:              | 100% open source under the MIT license

## Installation

Add package as dependency in your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/pjechris/AsyncUI.git", .upToNextMajor(from: "0.1.0"))
]
```

## Components

Have a look to our [Example](/Example) project to see each component in action. Here is the list of available components:

- [AsyncButton](/Sources/AsyncUI/Button/AsyncButton.swift)
- [AsyncPublisherButton](/Sources/AsyncUI/Button/AsyncPublisherButton.swift)
- [ActionButton](/Sources/AsyncUI/Button/ActionButton.swift)

## License
This project is released under the MIT License. Please see the LICENSE file for details.
