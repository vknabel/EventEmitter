public typealias Predicate<Event, Listener> = Emitting<Event, Listener, Bool>
public typealias EventPredicate<Event> = Emitting<Event, (Event) -> Bool, Bool>

public typealias Effect<Event, Listener> = Emitting<Event, Listener, Void>
public typealias EventEffect<Event> = Emitting<Event, (Event) -> Void, Void>

public typealias Ping<Listener> = Emitting<Void, Listener, Void>
public typealias EventPing = Emitting<Void, () -> Void, Void>


// Predicate<Event, Listener>
public extension Emitting where Response == Bool {
    static func predicate(
        storage: Emitting.Storage = Emitting.Storage.init(),
        witness: Emitting.Witness
    ) -> Emitting {
        return Emitting(
            storage: storage,
            witness: witness
        )
    }
}

// EventPredicate<Event>
public extension Emitting where Listener == (Event) -> Bool, Response == Bool {
    static func eventPredicate(
        storage: Emitting.Storage = Storage.init(),
        witness: Emitting.Witness = Witness.all()
    ) -> Emitting {
        return Emitting(
            storage: storage,
            witness: witness
        )
    }
}

// Effect<Event, Listener>
public extension Emitting where Response == Void {
    static func effect(
        storage: Emitting.Storage = Emitting.Storage.init(),
        witness: Emitting.Witness
    ) -> Emitting {
        return Emitting(
            storage: storage,
            witness: witness
        )
    }
}

// EventEffect<Event>
public extension Emitting where Response == Void, Listener == (Event) -> Void {
    static func eventEffect(
        storage: Emitting.Storage = Storage.init(),
        witness: Emitting.Witness = Witness.effect()
    ) -> Emitting {
        return Emitting(
            storage: storage,
            witness: witness
        )
    }
}


// Ping<Listener>
public extension Emitting where Event == Void, Response == Void {
    static func ping(
        storage: Emitting.Storage = Emitting.Storage.init(),
        witness: Emitting.Witness
    ) -> Emitting {
        return Emitting(
            storage: storage,
            witness: witness
        )
    }
}

// EventPing
public extension Emitting where Event == Void, Response == Void, Listener == () -> Void {
    static func eventPing(
        storage: Emitting.Storage = Storage.init(),
        witness: Emitting.Witness = .ping()
    ) -> Emitting {
        return Emitting(
            storage: storage,
            witness: witness
        )
    }
}
