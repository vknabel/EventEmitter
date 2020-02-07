public extension EmittingStorageWitness {
  init() {
    self = .serial
  }

  static var serial: EmittingStorageWitness {
    return .init(
      extractListeners: { $0.compactMap { $0.resolve() } },
      addListenerRef: { elements, reference in
        elements.append(reference)
        elements = elements.filter { (element) -> Bool in
          return element.resolve() != nil
        }
      }
    )
  }

  static var single: EmittingStorageWitness {
    return .init(
      extractListeners: { $0.compactMap { $0.resolve() } },
      addListenerRef: { elements, reference in
        elements = [reference]
      }
    )
  }

  static var consumingBuffer: EmittingStorageWitness {
    return .init(
      extractListeners: { listenerRefs in
        listenerRefs.compactMap { ref in
          let listener = ref.resolve()
          ref.free()
          return listener
        }
      },
      addListenerRef: { elements, reference in
        elements.append(reference)
        elements = elements.filter { (element) -> Bool in
          return element.resolve() != nil
        }
      }
    )
  }

  static var consumingFirst: EmittingStorageWitness {
    return .init(
      extractListeners: { listenerRefs in
        if let activeRef = listenerRefs.first(where: { ref in ref.resolve() != nil }),
          let listener = activeRef.resolve() {
          activeRef.free()
          return [listener]
        } else {
          return []
        }
      },
      addListenerRef: { elements, reference in
        elements.append(reference)
        elements = elements.filter { (element) -> Bool in
          return element.resolve() != nil
        }
      }
    )
  }
}
