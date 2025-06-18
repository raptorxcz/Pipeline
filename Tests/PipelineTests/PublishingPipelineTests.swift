@testable import Pipeline
import PipelineTestDoubles
import XCTest

final class PublishingPipelineTests: XCTestCase {
    func test_whenGetValue_thenReturnValue() async {
        let sut = PublishingPipeline<UInt>(value: 10)

        let value = await sut.getValue()

        XCTAssertEqual(value, 10)
    }

    func test_givenPublish_whenGetValue_thenReturnNewValue() async {
        let sut = PublishingPipeline<UInt>(value: 10)
        await sut.notify(value: 4)

        let value = await sut.getValue()

        XCTAssertEqual(value, 4)
    }
}
