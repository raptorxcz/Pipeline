//
//  PublishingPipeline.swift
//  Shared
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

public actor PublishingPipeline<Value>: Pipeline {
    private var lastValue: Value
    private let subscriptions = PipelineContext<Value>()

    public init(value: Value) {
        lastValue = value
    }

    public func publish(value: Value) async {
        lastValue = value
        await subscriptions.publish(value: value)
    }

    public func value() async -> Value {
        return lastValue
    }

    public func getContext() -> PipelineContext<Value> {
        return subscriptions
    }
}
