@testable import Pipeline
import PipelineTestDoubles
import XCTest

@MainActor
final class Merge3PipelineTests: XCTestCase {
    func test_whenInvokeSubscription1_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let sut = await Merge3Pipeline<String, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            transform: {
                await mergeValues.set(value: $0 + $1 + $2)
                return "\($0)"
            }
        )

        await source1.notify(value: 4)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 105)
    }

    func test_whenInvokeSubscription2_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let sut = await Merge3Pipeline<String, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            transform: {
                await mergeValues.set(value: $0 + $1 + $2)
                return "\($0)"
            }
        )

        await source2.notify(value: 4)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 114)
    }

    func test_whenInvokeSubscription3_thenInvokeMerge() async {
        let mergeValues = Wrapper<UInt?>(value: nil)
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let sut = await Merge3Pipeline<String, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            transform: {
                await mergeValues.set(value: $0 + $1 + $2)
                return "\($0)"
            }
        )

        await source3.notify(value: 4)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mergeValues, 15)
    }

    func test_whenGetValue_thenReturnMergeValueFromSources() async {
        let source1 = PipelineSpy<UInt>(valueReturn: 10)
        let source2 = PipelineSpy<UInt>(valueReturn: 1)
        let source3 = PipelineSpy<UInt>(valueReturn: 100)
        let sut = await Merge3Pipeline<UInt, UInt, UInt, UInt>(
            source1: source1,
            source2: source2,
            source3: source3,
            transform: {
                $0 + $1 + $2
            }
        )

        let value = await sut.getValue()

        XCTAssertEqual(value, 111)
    }
}
