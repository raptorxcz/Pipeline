//
//  PipelineListener.swift
//  Imos
//
//  Created by Libor Huspenina on 26.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

import Pipeline

final class PipelineListener<Output> {
    private let pipeline: any Pipeline<Output>
    private var runningPipelines: [SinkedPipeline] = []
    var outputs = [Output]()

    init(pipeline: some Pipeline<Output>) async {
        self.pipeline = pipeline
        await pipeline.sink { newValue in
            self.handleUpdate(output: newValue)
        }.store(in: &runningPipelines)
    }

    private func handleUpdate(output: Output) {
        outputs.append(output)
    }
}
