//
//  BackgroundInitStore.swift
//  Skyscanner
//
//  Created by debmalyakar on 26/10/26.
//

import Foundation

// Instantiates a value in the background and returns it when requested. The value is only instantiated once, and subsequent calls to `value()` will return the same instance.
final class BackgroundInitStore<Value: Sendable> {
    private let factory: @Sendable () async -> Value
    private var task: Task<Value, Never>?

    init(factory: @escaping @Sendable () async -> Value) {
        self.factory = factory
    }

    func value() async -> Value {
        if let task { return await task.value }

        let factory = self.factory
        let newTask = Task.detached(priority: .userInitiated) {
            await factory()
        }
        task = newTask
        return await newTask.value
    }
}
