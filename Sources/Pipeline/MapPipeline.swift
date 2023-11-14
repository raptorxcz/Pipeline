//
//  MapPipeline.swift
//  Shared
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

public final class MapPipeline<Value, Source>: Pipeline {
    // strong reference to sources Pipelines
    // This is holding whole pipelines stack.
    // If this is released then whole pipelines stack is released
    private let source: any Pipeline<Source>
    private let map: (Source) async -> Value
    private var context = PipelineContext<Value>()

    init(source: any Pipeline<Source>, subscription: any PipelineSubscription<Source>, map: @escaping (Source) async -> Value) async {
        self.source = source
        self.map = map
        await subscription.addSubscription(listener: self) { [weak self] value in
            await self?.publish(value: value)
        }
    }

    public func value() async -> Value {
        return await map(source.value())
    }

    private func publish(value: Source) async {
        let newValue = await map(value)
        await context.publish(value: newValue)
    }

    public func getContext() -> PipelineContext<Value> {
        return context
    }
}
