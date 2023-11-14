//
//  SinkPipelineTests.swift
//  SharedTests
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

@testable import Pipeline
import XCTest

final class SinkPipelineTests: XCTestCase {
    func test_whenInit_thenSubscribe() async {
        let source = PipelineSpy<UInt>(valueReturn: 10)
        let subscriptionSpy = PipelineSubscriptionSpy<UInt>()

        let sut = await SinkPipeline<UInt>(
            source: source,
            subscription: subscriptionSpy,
            sink: { _ in }
        )

        XCTAssertEqual(subscriptionSpy.addSubscription.count, 1)
        XCTAssertIdentical(subscriptionSpy.addSubscription.first?.listener, sut)
    }

    func test_whenInit_thenInvokeSink() async {
        let source = PipelineSpy<UInt>(valueReturn: 10)
        let subscriptionSpy = PipelineSubscriptionSpy<UInt>()
        var sinkValue: UInt?

        _ = await SinkPipeline<UInt>(
            source: source,
            subscription: subscriptionSpy,
            sink: { sinkValue = $0 }
        )

        XCTAssertEqual(sinkValue, 10)
    }

    func test_whenInvokeSubscription_thenInvokeSink() async {
        var sinkValue: UInt?
        let source = PipelineSpy<UInt>(valueReturn: 10)
        let subscriptionSpy = PipelineSubscriptionSpy<UInt>()
        _ = await SinkPipeline<UInt>(
            source: source,
            subscription: subscriptionSpy,
            sink: { sinkValue = $0 }
        )

        await subscriptionSpy.addSubscription.first?.block(4)

        XCTAssertEqual(sinkValue, 4)
    }
}
