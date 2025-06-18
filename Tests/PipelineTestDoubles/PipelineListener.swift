//
//  PipelineListener.swift
//  Imos
//
//  Created by Libor Huspenina on 26.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

import Pipeline

@MainActor
public final class PipelineListener<Output: Sendable> {
    private let pipeline: any Pipeline<Output>
    private let runningPipelines = SinkedPipelinesStorage()
    private var outputs = [Output]()

    public init(pipeline: some Pipeline<Output>) async {
        self.pipeline = pipeline
        await pipeline.sink { newValue in
            await self.handleUpdate(output: newValue)
        }.store(in: runningPipelines)
    }

    private func handleUpdate(output: Output) {
        outputs.append(output)
    }

    func getOutputs() -> [Output] {
        outputs
    }
}
