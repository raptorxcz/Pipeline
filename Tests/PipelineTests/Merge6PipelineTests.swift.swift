@testable import Pipeline
import XCTest

final class Merge6PipelineTests: XCTestCase {
    func test_whenInit_thenSubscribe() async {
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let source6 = PipelineSpy<UInt>(valueReturn: 100_000)
        let subscriptionSpy1 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy2 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy3 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy4 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy5 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy6 = PipelineSubscriptionSpy<UInt>()

        let sut = await Merge6Pipeline<String, UInt, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            source6: source6,
            subscription1: subscriptionSpy1,
            subscription2: subscriptionSpy2,
            subscription3: subscriptionSpy3,
            subscription4: subscriptionSpy4,
            subscription5: subscriptionSpy5,
            subscription6: subscriptionSpy6,
            merge: { "\($0)-\($1)-\($2)-\($3)-\($4)-\($5)" }
        )

        XCTAssertEqual(subscriptionSpy1.addSubscription.count, 1)
        XCTAssertIdentical(subscriptionSpy1.addSubscription.first?.listener, sut)
        XCTAssertEqual(subscriptionSpy2.addSubscription.count, 1)
        XCTAssertIdentical(subscriptionSpy2.addSubscription.first?.listener, sut)
        XCTAssertEqual(subscriptionSpy3.addSubscription.count, 1)
        XCTAssertIdentical(subscriptionSpy3.addSubscription.first?.listener, sut)
        XCTAssertEqual(subscriptionSpy4.addSubscription.count, 1)
        XCTAssertIdentical(subscriptionSpy4.addSubscription.first?.listener, sut)
        XCTAssertEqual(subscriptionSpy5.addSubscription.count, 1)
        XCTAssertIdentical(subscriptionSpy5.addSubscription.first?.listener, sut)
        XCTAssertEqual(subscriptionSpy6.addSubscription.count, 1)
        XCTAssertIdentical(subscriptionSpy6.addSubscription.first?.listener, sut)
    }

    func test_whenInvokeSubscription1_thenInvokeMerge() async {
        var mergeValues: UInt?
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let source6 = PipelineSpy<UInt>(valueReturn: 100_000)
        let subscriptionSpy1 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy2 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy3 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy4 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy5 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy6 = PipelineSubscriptionSpy<UInt>()
        _ = await Merge6Pipeline<String, UInt, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            source6: source6,
            subscription1: subscriptionSpy1,
            subscription2: subscriptionSpy2,
            subscription3: subscriptionSpy3,
            subscription4: subscriptionSpy4,
            subscription5: subscriptionSpy5,
            subscription6: subscriptionSpy6,
            merge: {
                mergeValues = $0 + $1 + $2 + $3 + $4 + $5
                return "\($0)"
            }
        )

        await subscriptionSpy1.addSubscription.first?.block(40)

        XCTAssertEqual(mergeValues, 111_141)
    }

    func test_whenInvokeSubscription2_thenInvokeMerge() async {
        var mergeValues: UInt?
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let source6 = PipelineSpy<UInt>(valueReturn: 100_000)
        let subscriptionSpy1 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy2 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy3 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy4 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy5 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy6 = PipelineSubscriptionSpy<UInt>()
        _ = await Merge6Pipeline<String, UInt, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            source6: source6,
            subscription1: subscriptionSpy1,
            subscription2: subscriptionSpy2,
            subscription3: subscriptionSpy3,
            subscription4: subscriptionSpy4,
            subscription5: subscriptionSpy5,
            subscription6: subscriptionSpy6,
            merge: {
                mergeValues = $0 + $1 + $2 + $3 + $4 + $5
                return "\($0)"
            }
        )

        await subscriptionSpy2.addSubscription.first?.block(4)

        XCTAssertEqual(mergeValues, 111_114)
    }

    func test_whenInvokeSubscription3_thenInvokeMerge() async {
        var mergeValues: UInt?
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let source6 = PipelineSpy<UInt>(valueReturn: 100_000)
        let subscriptionSpy1 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy2 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy3 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy4 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy5 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy6 = PipelineSubscriptionSpy<UInt>()
        _ = await Merge6Pipeline<String, UInt, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            source6: source6,
            subscription1: subscriptionSpy1,
            subscription2: subscriptionSpy2,
            subscription3: subscriptionSpy3,
            subscription4: subscriptionSpy4,
            subscription5: subscriptionSpy5,
            subscription6: subscriptionSpy6,
            merge: {
                mergeValues = $0 + $1 + $2 + $3 + $4 + $5
                return "\($0)"
            }
        )

        await subscriptionSpy3.addSubscription.first?.block(400)

        XCTAssertEqual(mergeValues, 111_411)
    }

    func test_whenInvokeSubscription4_thenInvokeMerge() async {
        var mergeValues: UInt?
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let source6 = PipelineSpy<UInt>(valueReturn: 100_000)
        let subscriptionSpy1 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy2 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy3 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy4 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy5 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy6 = PipelineSubscriptionSpy<UInt>()
        _ = await Merge6Pipeline<String, UInt, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            source6: source6,
            subscription1: subscriptionSpy1,
            subscription2: subscriptionSpy2,
            subscription3: subscriptionSpy3,
            subscription4: subscriptionSpy4,
            subscription5: subscriptionSpy5,
            subscription6: subscriptionSpy6,
            merge: {
                mergeValues = $0 + $1 + $2 + $3 + $4 + $5
                return "\($0)"
            }
        )

        await subscriptionSpy4.addSubscription.first?.block(2_000)

        XCTAssertEqual(mergeValues, 112_111)
    }

    func test_whenInvokeSubscription5_thenInvokeMerge() async {
        var mergeValues: UInt?
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let source6 = PipelineSpy<UInt>(valueReturn: 100_000)
        let subscriptionSpy1 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy2 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy3 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy4 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy5 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy6 = PipelineSubscriptionSpy<UInt>()
        _ = await Merge6Pipeline<String, UInt, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            source6: source6,
            subscription1: subscriptionSpy1,
            subscription2: subscriptionSpy2,
            subscription3: subscriptionSpy3,
            subscription4: subscriptionSpy4,
            subscription5: subscriptionSpy5,
            subscription6: subscriptionSpy6,
            merge: {
                mergeValues = $0 + $1 + $2 + $3 + $4 + $5
                return "\($0)"
            }
        )

        await subscriptionSpy5.addSubscription.first?.block(30_000)

        XCTAssertEqual(mergeValues, 131_111)
    }

    func test_whenInvokeSubscription6_thenInvokeMerge() async {
        var mergeValues: UInt?
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let source6 = PipelineSpy<UInt>(valueReturn: 100_000)
        let subscriptionSpy1 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy2 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy3 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy4 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy5 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy6 = PipelineSubscriptionSpy<UInt>()
        _ = await Merge6Pipeline<String, UInt, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            source6: source6,
            subscription1: subscriptionSpy1,
            subscription2: subscriptionSpy2,
            subscription3: subscriptionSpy3,
            subscription4: subscriptionSpy4,
            subscription5: subscriptionSpy5,
            subscription6: subscriptionSpy6,
            merge: {
                mergeValues = $0 + $1 + $2 + $3 + $4 + $5
                return "\($0)"
            }
        )

        await subscriptionSpy6.addSubscription.first?.block(900_000)

        XCTAssertEqual(mergeValues, 911_111)
    }

    func test_whenGetValue_thenReturnMergeValueFromSources() async {
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let source6 = PipelineSpy<UInt>(valueReturn: 100_000)
        let subscriptionSpy1 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy2 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy3 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy4 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy5 = PipelineSubscriptionSpy<UInt>()
        let subscriptionSpy6 = PipelineSubscriptionSpy<UInt>()
        let sut = await Merge6Pipeline<UInt, UInt, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            source6: source6,
            subscription1: subscriptionSpy1,
            subscription2: subscriptionSpy2,
            subscription3: subscriptionSpy3,
            subscription4: subscriptionSpy4,
            subscription5: subscriptionSpy5,
            subscription6: subscriptionSpy6,
            merge: {
                return $0 + $1 + $2 + $3 + $4 + $5
            }
        )

        let value = await sut.value()

        XCTAssertEqual(value, 111_111)
    }
}
