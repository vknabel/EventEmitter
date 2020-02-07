public struct EmittingWitness<Event, Listener, Response> {
  public var request: (Event, [Listener]) -> Response

  public init(request: @escaping (Event, [Listener]) -> Response) {
    self.request = request
  }
}

public extension EmittingWitness {
  func map<R>(_ transform: @escaping (Response) -> R) -> EmittingWitness<Event, Listener, R> {
    return EmittingWitness<Event, Listener, R> { event, listeners -> R in
      transform(self.request(event, listeners))
    }
  }

  func pullback<E>(_ transform: @escaping (E) -> Event) -> EmittingWitness<E, Listener, Response> {
    return EmittingWitness<E, Listener, Response> { (event: E, listeners: [Listener]) -> Response in
      self.request(transform(event), listeners)
    }
  }

  func pullbackListener<L>(_ transform: @escaping (L) -> Listener) -> EmittingWitness<Event, L, Response> {
    return EmittingWitness<Event, L, Response> { event, listeners -> Response in
      self.request(event, listeners.map(transform))
    }
  }
}

public extension EmittingWitness where Response: Sequence {
  func reduce<R>(
    _ initialResult: R,
    _ nextPartialResult: @escaping (R, Response.Element) -> R
  ) -> EmittingWitness<Event, Listener, R> {
    return map { response in
      response.reduce(initialResult, nextPartialResult)
    }
  }

  func reduce<R>(
    into initialResult: R,
    _ updateAccumulatingResult: @escaping (inout R, Response.Element) -> Void
  ) -> EmittingWitness<Event, Listener, R> {
    return map { response in
      response.reduce(into: initialResult, updateAccumulatingResult)
    }
  }

  func compactMap<R>(_ transform: @escaping (Response.Element) -> R?) -> EmittingWitness<Event, Listener, [R]> {
    return map { response in
      response.compactMap(transform)
    }
  }
}
