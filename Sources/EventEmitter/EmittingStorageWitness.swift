public struct EmittingStorageWitness<Listener> {
  public var extractListeners: ([Ref<Listener>]) -> [Listener]
  public var addListenerRef: (inout [Ref<Listener>], Ref<Listener>) -> Void

  public init(
    extractListeners: @escaping ([Ref<Listener>]) -> [Listener],
    addListenerRef: @escaping (inout [Ref<Listener>], Ref<Listener>) -> Void
  ) {
    self.addListenerRef = addListenerRef
    self.extractListeners = extractListeners
  }
}
