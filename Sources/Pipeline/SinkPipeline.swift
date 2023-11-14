//
//  SinkPipeline.swift
//  Shared
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

public typealias SinkedPipeline = Any

public final class SinkPipeline<Source> {
    // Strong reference to source `Pipeline`
    // This is holding whole pipeline stack.
    // If this is released then whole pipeline stack is released
    private let source: any Pipeline<Source>
    private let sink: (Source) async -> Void

    init(source: any Pipeline<Source>, subscription: any PipelineSubscription<Source>, sink: @escaping (Source) async -> Void) async {
        self.source = source
        self.sink = sink
        await subscription.addSubscription(listener: self) { [weak self] value in
            await self?.sink(value)
        }
        await sink(source.value())
    }

    public func store(in storage: inout [SinkedPipeline]) {
        storage.append(self)
    }
}
