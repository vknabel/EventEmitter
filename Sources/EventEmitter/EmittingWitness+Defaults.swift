public extension EmittingWitness
  where
  Response: RangeReplaceableCollection,
  Listener == (Event) -> Response.Element {
  init() {
    self = .transformingEvents()
  }
}

public extension EmittingWitness {
  static func transformingEvents<Event, Response>(eventType _: Event.Type = Event.self, responseType _: Response.Type = Response.self) -> EmittingWitness < Event, (Event) -> Response.Element, Response>
    where
    Response: RangeReplaceableCollection {
    return EmittingWitness < Event, (Event) -> Response.Element, Response > .init(request:) { event, listeners in
      Response(listeners.map { $0(event) })
    }
  }

  static func all<Event>(eventType _: Event.Type = Event.self) -> EmittingWitness < Event, (Event) -> Bool, Bool> {
    return EmittingWitness.transformingEvents(eventType: Event.self, responseType: [Bool].self)
      .reduce(true, { $0 && $1 })
  }

  static func one<Event>() -> EmittingWitness < Event, (Event) -> Bool, Bool> {
    return EmittingWitness.transformingEvents(eventType: Event.self, responseType: [Bool].self)
      .reduce(false, { $0 || $1 })
  }

  static func effect<Event>(eventType _: Event.Type = Event.self) -> EmittingWitness < Event, (Event) -> Void, Void> {
    return EmittingWitness < Event, (Event) -> Void, Void > .init(request:) { event, listeners in
      listeners.forEach { $0(event) }
    }
  }

  static func read<Response>(responseType _: Response.Type = Response.self) -> EmittingWitness < Void, () -> Response.Element, Response> where
    Response: RangeReplaceableCollection {
    return EmittingWitness.transformingEvents(eventType: Void.self, responseType: Response.self)
      .pullbackListener({ (listener) -> (()) -> Response.Element in
        { _ in listener() }
      })
  }
}

public extension EmittingWitness where Event == Void, Listener == () -> Void, Response == Void {
  static func ping() -> EmittingWitness {
    return EmittingWitness .init(request:) { event, listeners in
      listeners.forEach { $0() }
    }
  }
}
