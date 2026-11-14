import os

@usableFromInline
internal final class LockWrapper<Value>: @unchecked Sendable {
    @usableFromInline
    internal let _lock: os_unfair_lock_t

    @usableFromInline
    internal var _value: Value

    @usableFromInline
    internal init(_ value: Value) {
        _lock = .allocate(capacity: 1)
        _lock.initialize(to: os_unfair_lock())
        _value = value
    }

    deinit {
        _lock.deinitialize(count: 1)
        _lock.deallocate()
    }

    @usableFromInline
    @_alwaysEmitIntoClient
    internal func read<U>(_ closure: (Value) throws -> U) rethrows -> U {
        os_unfair_lock_lock(_lock)
        defer { os_unfair_lock_unlock(_lock) }
        return try closure(_value)
    }

    @usableFromInline
    @_alwaysEmitIntoClient
    @discardableResult
    internal func write<U>(_ closure: (inout Value) throws -> U) rethrows -> U {
        os_unfair_lock_lock(_lock)
        defer { os_unfair_lock_unlock(_lock) }
        return try closure(&_value)
    }
}
