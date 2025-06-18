//
//  PublishingPipeline.swift
//  Shared
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

public actor PublishingPipeline<Value: Sendable>: Pipeline {
    private var lastValue: Value
    private let subscribers = PipelineSubscribers<Value>()

    public init(value: Value) {
        lastValue = value
    }

    public func notify(value: Value) async {
        lastValue = value
        await subscribers.notify(with: value)
    }

    public func getValue() async -> Value {
        return lastValue
    }

    public func getSubscribers() async -> PipelineSubscribers<Value> {
        return subscribers
    }
}
