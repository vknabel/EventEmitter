public class Ref<T> {
  private var value: () -> T?

  public init(dereference: @escaping () -> T?) {
    value = dereference
  }

  public func resolve() -> T? {
    return value()
  }

  public func free() {
    value = { nil }
  }
}

extension Ref {
  public static func weak(_ value: T) -> (Lifetime, Ref) {
    let lifetime = Box(value)
    let weak = Weak(value: lifetime)
    return (
      lifetime,
      .init(dereference: { weak.value?.value })
    )
  }

  public static func strong(_ value: T) -> Ref {
    return .init(dereference: { value })
  }

  private struct Weak<T> {
    fileprivate weak var value: Box<T>?
  }

  private class Box<T>: Lifetime {
    var value: T?

    init(_ value: T?) {
      self.value = value
    }

    func finish() {
      value = nil
    }
  }
}
