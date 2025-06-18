@testable import Pipeline
import PipelineTestDoubles
import XCTest

@MainActor
final class MapPipelineTests: XCTestCase {
    func test_whenInvokeSubscription_thenInvokeMap() async {
        let mapValue = Wrapper<UInt?>(value: nil)
        let source = PipelineSpy<UInt>(valueReturn: 10)
        let sut = await MapPipeline<String, UInt>(
            source: source,
            transform: {
                await mapValue.set(value: $0)
                return "\($0)"
            }
        )

        await source.notify(value: 4)

        XCTAssertNotNil(sut)
        XCTAssertEqual(mapValue, 4)
    }

    func test_whenGetValue_thenReturnMapValueFromSource() async {
        let source = PipelineSpy<UInt>(valueReturn: 10)
        let sut = await MapPipeline<UInt, UInt>(
            source: source,
            transform: { $0 + 100 }
        )

        let value = await sut.getValue()

        XCTAssertEqual(value, 110)
    }
}
