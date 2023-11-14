//
//  MapPipelineTests.swift
//  SharedTests
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

@testable import Pipeline
import XCTest

final class MapPipelineTests: XCTestCase {
    func test_whenInit_thenSubscribe() async {
        let source = PipelineSpy<UInt>(valueReturn: 10)
        let subscriptionSpy = PipelineSubscriptionSpy<UInt>()

        let sut = await MapPipeline<String, UInt>(
            source: source,
            subscription: subscriptionSpy,
            map: { "\($0)" }
        )

        XCTAssertEqual(subscriptionSpy.addSubscription.count, 1)
        XCTAssertIdentical(subscriptionSpy.addSubscription.first?.listener, sut)
    }

    func test_whenInvokeSubscription_thenInvokeMap() async {
        var mapValue: UInt?
        let source = PipelineSpy<UInt>(valueReturn: 10)
        let subscriptionSpy = PipelineSubscriptionSpy<UInt>()
        _ = await MapPipeline<String, UInt>(
            source: source,
            subscription: subscriptionSpy,
            map: {
                mapValue = $0
                return "\($0)"
            }
        )

        await subscriptionSpy.addSubscription.first?.block(4)

        XCTAssertEqual(mapValue, 4)
    }

    func test_whenGetValue_thenReturnMapValueFromSource() async {
        let source = PipelineSpy<UInt>(valueReturn: 10)
        let subscriptionSpy = PipelineSubscriptionSpy<UInt>()
        let sut = await MapPipeline<UInt, UInt>(
            source: source,
            subscription: subscriptionSpy,
            map: { $0 + 100 }
        )

        let value = await sut.value()

        XCTAssertEqual(value, 110)
    }
}
