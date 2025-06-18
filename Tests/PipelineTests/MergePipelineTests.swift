//
//  MergePipelineTests.swift
//  SharedTests
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

@testable import Pipeline
import PipelineTestDoubles
import XCTest

@MainActor
final class MergePipelineTests: XCTestCase {
    func test_whenInvokeSubscription1_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let sut = await MergePipeline<String, UInt, UInt>(
            source1: source1,
            source2: source2,
            transform: {
                await mergeValues.set(value: $0 + $1)
                return "\($0)"
            }
        )

        await source1.notify(value: 4)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 5)
    }

    func test_whenInvokeSubscription2_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let sut = await MergePipeline<String, UInt, UInt>(
            source1: source1,
            source2: source2,
            transform: {
                await mergeValues.set(value: $0 + $1)
                return "\($0)"
            }
        )

        await source2.notify(value: 4)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 14)
    }

    func test_whenGetValue_thenReturnMergeValueFromSources() async {
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let sut = await MergePipeline<UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            transform: { $0 + $1 }
        )

        let value = await sut.getValue()

        XCTAssertEqual(value, 11)
    }
}
