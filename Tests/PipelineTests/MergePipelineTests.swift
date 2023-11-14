//
//  MergePipelineTests.swift
//  SharedTests
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

@testable import Pipeline
import XCTest

final class MergePipelineTests: XCTestCase {
    func test_whenInit_thenSubscribe() async {
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let subscriptionSpy1 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy2 = PipelineSubscriptionSpy<UInt>()

        let sut = await MergePipeline<String, UInt, UInt>(
            source1: source1,
            source2: source2,
            subscription1: subscriptionSpy1,
            subscription2: subscriptionSpy2,
            merge: { "\($0)-\($1)" }
        )

        XCTAssertEqual(subscriptionSpy1.addSubscription.count, 1)
        XCTAssertIdentical(subscriptionSpy1.addSubscription.first?.listener, sut)
        XCTAssertEqual(subscriptionSpy2.addSubscription.count, 1)
        XCTAssertIdentical(subscriptionSpy2.addSubscription.first?.listener, sut)
    }

    func test_whenInvokeSubscription1_thenInvokeMerge() async {
        var mergeValues: UInt?
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let subscriptionSpy1 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy2 = PipelineSubscriptionSpy<UInt>()
        _ = await MergePipeline<String, UInt, UInt>(
            source1: source1,
            source2: source2,
            subscription1: subscriptionSpy1,
            subscription2: subscriptionSpy2,
            merge: {
                mergeValues = $0 + $1
                return "\($0)"
            }
        )

        await subscriptionSpy1.addSubscription.first?.block(4)

        XCTAssertEqual(mergeValues, 5)
    }

    func test_whenInvokeSubscription2_thenInvokeMerge() async {
        var mergeValues: UInt?
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let subscriptionSpy1 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy2 = PipelineSubscriptionSpy<UInt>()
        _ = await MergePipeline<String, UInt, UInt>(
            source1: source1,
            source2: source2,
            subscription1: subscriptionSpy1,
            subscription2: subscriptionSpy2,
            merge: {
                mergeValues = $0 + $1
                return "\($0)"
            }
        )

        await subscriptionSpy2.addSubscription.first?.block(4)

        XCTAssertEqual(mergeValues, 14)
    }

    func test_whenGetValue_thenReturnMergeValueFromSources() async {
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let subscriptionSpy1 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy2 = PipelineSubscriptionSpy<UInt>()
        let sut = await MergePipeline<UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            subscription1: subscriptionSpy1,
            subscription2: subscriptionSpy2,
            merge: { $0 + $1 }
        )

        let value = await sut.value()

        XCTAssertEqual(value, 11)
    }
}
