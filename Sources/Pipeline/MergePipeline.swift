//
//  MergePipeline.swift
//  Shared
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

public final class MergePipeline<Value, Source1, Source2>: Pipeline {
    // strong reference to sources Pipelines
    // This is holding whole pipelines stack.
    // If this is released then whole pipelines stack is released
    private let source1: any Pipeline<Source1>
    private let source2: any Pipeline<Source2>
    private let merge: (Source1, Source2) async -> Value
    private var subscriptions = PipelineContext<Value>()

    init(
        source1: any Pipeline<Source1>,
        source2: any Pipeline<Source2>,
        subscription1: any PipelineSubscription<Source1>,
        subscription2: any PipelineSubscription<Source2>,
        merge: @escaping (Source1, Source2) async -> Value
    ) async {
        self.source1 = source1
        self.source2 = source2
        self.merge = merge
        await subscription1.addSubscription(listener: self) { [weak self] value in
            await self?.publish(value1: value, value2: source2.value())
        }
        await subscription2.addSubscription(listener: self) { [weak self] value in
            await self?.publish(value1: source1.value(), value2: value)
        }
    }

    public func value() async -> Value {
        return await merge(source1.value(), source2.value())
    }

    private func publish(value1: Source1, value2: Source2) async {
        let newValue = await merge(value1, value2)
        await subscriptions.publish(value: newValue)
    }

    public func getContext() -> PipelineContext<Value> {
        return subscriptions
    }
}
