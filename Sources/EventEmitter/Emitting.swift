public struct Emitting<Event, Listener, Response> {
  public typealias Witness = EmittingWitness<Event, Listener, Response>
  public typealias Storage = EmittingStorageWitness<Listener>
  
  private var listenerRefs: [Ref<Listener>] = []
  public let storageWitness: EmittingStorageWitness<Listener>
  public let emittingWitness: EmittingWitness<Event, Listener, Response>

  public init(
    storage: EmittingStorageWitness<Listener>,
    witness: EmittingWitness<Event, Listener, Response>
  ) {
    self.storageWitness = storage
    self.emittingWitness = witness
  }
    
  public mutating func watch(_ listener: Listener) -> Lifetime {
    let (responsibility, ref) = Ref.weak(listener)
    storageWitness.addListenerRef(&listenerRefs, ref)
    return responsibility
  }

  public mutating func always(_ listener: Listener) {
    storageWitness.addListenerRef(&listenerRefs, .strong(listener))
  }

  public mutating func addListenerRef(_ ref: Ref<Listener>) {
    storageWitness.addListenerRef(&listenerRefs, ref)
  }

  public func request(_ event: Event) -> Response {
    return emittingWitness.request(event, storageWitness.extractListeners(listenerRefs))
  }
}

public extension Emitting {
  func emit(_ event: Event) {
    _ = request(event)
  }
}

public extension Emitting where Event == Void {
  func emit() {
    emit(())
  }

  func request() -> Response {
    return request(())
  }
}
