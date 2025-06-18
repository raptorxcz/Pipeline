//
//  MapPipeline.swift
//  Shared
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

public final class MapPipeline<Value: Sendable, Source: Sendable>: Pipeline {
    // strong reference to sources Pipelines
    // This is holding whole pipelines stack.wow
    // If this is released then whole pipelines stack is released
    private let source: any Pipeline<Source>
    private let transform: @Sendable (Source) async -> Value
    private let subscribers = PipelineSubscribers<Value>()

    init(
        source: any Pipeline<Source>,
        transform: @Sendable @escaping (Source) async -> Value
    ) async {
        self.source = source
        self.transform = transform
        await source.getSubscribers().addSubscriber(self) { [weak self] value in
            await self?.notify(value: value)
        }
    }

    public func getValue() async -> Value {
        return await transform(source.getValue())
    }

    private func notify(value: Source) async {
        let newValue = await transform(value)
        await subscribers.notify(with: newValue)
    }

    public func getSubscribers() async -> PipelineSubscribers<Value> {
        return subscribers
    }
}
