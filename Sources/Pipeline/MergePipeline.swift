//
//  MergePipeline.swift
//  Shared
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

public final class MergePipeline<Value: Sendable, Source1: Sendable, Source2: Sendable>: Pipeline {
    // strong reference to sources Pipelines
    // This is holding whole pipelines stack.
    // If this is released then whole pipelines stack is released
    private let source1: any Pipeline<Source1>
    private let source2: any Pipeline<Source2>
    private let transform: @Sendable (Source1, Source2) async -> Value
    private let subscribers = PipelineSubscribers<Value>()

    init(
        source1: any Pipeline<Source1>,
        source2: any Pipeline<Source2>,
        transform: @Sendable @escaping (Source1, Source2) async -> Value
    ) async {
        self.source1 = source1
        self.source2 = source2
        self.transform = transform
        await source1.getSubscribers().addSubscriber(self) { [weak self] value in
            await self?.notify(value1: value, value2: source2.getValue())
        }
        await source2.getSubscribers().addSubscriber(self) { [weak self] value in
            await self?.notify(value1: source1.getValue(), value2: value)
        }
    }

    public func getValue() async -> Value {
        return await transform(source1.getValue(), source2.getValue())
    }

    private func notify(value1: Source1, value2: Source2) async {
        let newValue = await transform(value1, value2)
        await subscribers.notify(with: newValue)
    }

    public func getSubscribers() async -> PipelineSubscribers<Value> {
        return subscribers
    }
}
