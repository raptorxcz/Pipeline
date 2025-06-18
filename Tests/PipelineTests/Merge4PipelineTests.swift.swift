//
//  Merge4PipelineTests.swift.swift
//  SharedTests
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

@testable import Pipeline
import PipelineTestDoubles
import XCTest

@MainActor
final class Merge4PipelineTests: XCTestCase {
    func test_whenInvokeSubscription1_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let sut = await Merge4Pipeline<String, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            transform: {
                await mergeValues.set(value: $0 + $1 + $2 + $3)
                return "\($0)"
            }
        )

        await source1.notify(value: 40)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 1_141)
    }

    func test_whenInvokeSubscription2_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let sut = await Merge4Pipeline<String, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            transform: {
                await mergeValues.set(value: $0 + $1 + $2 + $3)
                return "\($0)"
            }
        )

        await source2.notify(value: 4)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 1_114)
    }

    func test_whenInvokeSubscription3_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let sut = await Merge4Pipeline<String, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            transform: {
                await mergeValues.set(value: $0 + $1 + $2 + $3)
                return "\($0)"
            }
        )

        await source3.notify(value: 400)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 1_411)
    }

    func test_whenInvokeSubscription4_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let sut = await Merge4Pipeline<String, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            transform: {
                await mergeValues.set(value: $0 + $1 + $2 + $3)
                return "\($0)"
            }
        )

        await source4.notify(value: 2_000)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 2_111)
    }

    func test_whenGetValue_thenReturnMergeValueFromSources() async {
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let sut = await Merge4Pipeline<UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            transform: {
                return $0 + $1 + $2 + $3
            }
        )

        let value = await sut.getValue()

        XCTAssertEqual(value, 1_111)
    }
}
