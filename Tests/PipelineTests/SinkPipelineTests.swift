@testable import Pipeline
import PipelineTestDoubles
import XCTest

@MainActor
final class SinkPipelineTests: XCTestCase {
    func test_whenInit_thenInvokeSink() async {
        let source = PipelineSpy<UInt>(valueReturn: 10)
        let sinkValue = Wrapper<UInt>(value: 0)

        _ = await SinkPipeline<UInt>(
            source: source,
            receiveValue: { await sinkValue.set(value: $0) }
        )

        XCTAssertEqual(sinkValue, 10)
    }

    func test_whenPublishNewData_thenInvokeSink() async {
        let sinkValue = Wrapper<UInt?>(value: nil)
        let source = PipelineSpy<UInt>(valueReturn: 10)
        let sut = await SinkPipeline<UInt>(
            source: source,
            receiveValue: { await sinkValue.set(value: $0) }
        )

        await source.notify(value: 4)

        XCTAssertNotNil(sut)
        XCTAssertEqual(sinkValue, 4)
    }
}
