# EventEmitter

A description of this package.

```swift
enum SessionEvents {
  static var logout = EventEmitter<Void>()
  static var tokenDidChange = EventEmitter<String?>()
  static var canLogout = EventResponder<(), Bool>()
}

SessionEvents.logout.always { _ in
  SessionEvents.canLogout.request(()) { canLogout in
    guard canLogout.reduce(true, { $0 && $1 }) else {
      return
    }
    UserDefaults.standard.removeObject(forKey: "token")
    SessionEvents.tokenDidChange.emit(nil)
  }
}

SessionEvents.logout.always { _ in
  // replace root view controller
}

SessionEvents.tokenDidChange.always { _ in
  // update token of api controller thing
}

SessionEvents.canLogout.always { _ -> Bool in
  false
}

SessionEvents.logout.emit()

```
