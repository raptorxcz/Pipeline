//
//  PipelineSpy.swift
//  SharedTests
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

@testable import Pipeline
import XCTest

final class PipelineSpy<Value>: Pipeline {
    var valueCount = 0
    var valueReturn: Value

    init(valueReturn: Value) {
        self.valueReturn = valueReturn
    }

    func value() async -> Value {
        valueCount += 1
        return valueReturn
    }

    func getContext() async -> PipelineContext<Value> {
        return PipelineContext<Value>()
    }
}
