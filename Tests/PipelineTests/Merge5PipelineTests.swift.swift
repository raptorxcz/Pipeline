@testable import Pipeline
import PipelineTestDoubles
import XCTest

@MainActor
final class Merge5PipelineTests: XCTestCase {
    func test_whenInvokeSubscription1_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let sut = await Merge5Pipeline<String, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            transform: {
                await mergeValues.set(value: $0 + $1 + $2 + $3 + $4)
                return "\($0)"
            }
        )

        await source1.notify(value: 40)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 11_141)
    }

    func test_whenInvokeSubscription2_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let sut = await Merge5Pipeline<String, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            transform: {
                await mergeValues.set(value: $0 + $1 + $2 + $3 + $4)
                return "\($0)"
            }
        )

        await source2.notify(value: 4)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 11_114)
    }

    func test_whenInvokeSubscription3_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let sut = await Merge5Pipeline<String, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            transform: {
                await mergeValues.set(value: $0 + $1 + $2 + $3 + $4)
                return "\($0)"
            }
        )

        await source3.notify(value: 400)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 11_411)
    }

    func test_whenInvokeSubscription4_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let sut = await Merge5Pipeline<String, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            transform: {
                await mergeValues.set(value: $0 + $1 + $2 + $3 + $4)
                return "\($0)"
            }
        )

        await source4.notify(value: 2_000)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 12_111)
    }

    func test_whenInvokeSubscription5_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let sut = await Merge5Pipeline<String, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            transform: {
                await mergeValues.set(value: $0 + $1 + $2 + $3 + $4)
                return "\($0)"
            }
        )

        await source5.notify(value: 30_000)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 31_111)
    }

    func test_whenGetValue_thenReturnMergeValueFromSources() async {
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let source4 = PipelineSpy<UInt>(valueReturn: 1_000)
        let source5 = PipelineSpy<UInt>(valueReturn: 10_000)
        let sut = await Merge5Pipeline<UInt, UInt, UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            source4: source4,
            source5: source5,
            transform: {
                return $0 + $1 + $2 + $3 + $4
            }
        )

        let value = await sut.getValue()

        XCTAssertEqual(value, 11_111)
    }
}
