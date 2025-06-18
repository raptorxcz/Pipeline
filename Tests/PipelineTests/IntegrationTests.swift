import Pipeline
import PipelineTestDoubles
import XCTest

@MainActor
final class IntegrationTests: SutTestCase<PublishingPipeline<UInt>> {
    private let pipelines = SinkedPipelinesStorage()

    override func setUp() async throws {
        await pipelines.removeAll()
        sut = PublishingPipeline<UInt>(value: 4)
    }

    override func tearDown() async throws {
        await pipelines.removeAll()
    }

    func test_whenGetValue_thenReturnInitValue() async {
        let value = await sut.getValue()

        XCTAssertEqual(value, 4)
    }

    func test_givenPublishValue_whenGetValue_thenReturnNewValue() async {
        await sut.notify(value: 5)

        let value = await sut.getValue()

        XCTAssertEqual(value, 5)
    }

    func test_whenSink_thenUpdateValue() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)

        await sut.sink { newValue in
            await value.set(value: newValue)
        }.store(in: pipelines)

        XCTAssertEqual(value, 4)
    }

    func test_givenSinkValue_whenPublish_thenUpdateValue() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)
        await sut.sink { newValue in
            await value.set(value: newValue)
        }.store(in: pipelines)

        await sut.notify(value: 9)

        XCTAssertEqual(value, 9)
    }

    func test_givenSinkValueAndNotStored_whenPublish_thenNotUpdateValue() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)
        _ = await sut.sink { newValue in
            await value.set(value: newValue)
        }

        await sut.notify(value: 9)

        XCTAssertEqual(value, 4)
    }

    func test_givenMapValue_whenGetValue_thenReturnUpdatedValue() async {
        let newPipeline = await sut.map { value in
            value + 100
        }

        let value = await newPipeline.getValue()

        XCTAssertEqual(value, 104)
    }

    func test_givenMapAndSinkValueNotStored_whenPublish_thenNotUpdate() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)
        let mapPipeline = await sut.map {
            $0 + 100
        }
        _ = await mapPipeline.sink { newValue in
            await value.set(value: newValue)
        }

        await sut.notify(value: 9)

        XCTAssertEqual(value, 104)
    }

    func test_givenSinkValueAndRemoveReferenceWithStored_whenPublish_thenUpdate() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)
        let mapPipeline = await sut.map {
            $0 + 100
        }
        await mapPipeline.sink { newValue in
            await value.set(value: newValue)
        }.store(in: pipelines)

        await sut.notify(value: 9)

        XCTAssertEqual(value, 109)
    }

    func test_givenMerge_whenGetValue_thenReturnMergeValue() async {
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let mergedPipeline = await sut.merge(with: otherPipeline) {
            $0 + $1
        }

        let value = await mergedPipeline.getValue()

        XCTAssertEqual(value, 104)
    }

    func test_givenMerge_whenSutPublish_thenSinkValue() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        await sut.merge(with: otherPipeline) {
            $0 + $1
        }.sink {
            await value.set(value: $0)
        }.store(in: pipelines)

        await sut.notify(value: 9)

        XCTAssertEqual(value, 109)
    }

    func test_givenMerge_whenOtherPipelinePublish_thenSinkValue() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        await sut.merge(with: otherPipeline) {
            $0 + $1
        }.sink {
            await value.set(value: $0)
        }.store(in: pipelines)

        await otherPipeline.notify(value: 200)

        XCTAssertEqual(value, 204)
    }

    func test_givenMerge3_whenGetValue_thenReturnMergeValue() async {
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        let mergedPipeline = await sut.merge(with: otherPipeline, and: otherPipeline2) {
            $0 + $1 + $2
        }

        let value = await mergedPipeline.getValue()

        XCTAssertEqual(value, 114)
    }

    func test_givenMerge3_whenSutPublish_thenSinkValue() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        await sut.merge(with: otherPipeline, and: otherPipeline2) {
            $0 + $1 + $2
        }.sink {
            await value.set(value: $0)
        }.store(in: pipelines)

        await sut.notify(value: 9)

        XCTAssertEqual(value, 119)
    }

    func test_givenMerge3_whenOtherPipelinePublish_thenSinkValue() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        await sut.merge(with: otherPipeline, and: otherPipeline2) {
            $0 + $1 + $2
        }.sink {
            await value.set(value: $0)
        }.store(in: pipelines)

        await otherPipeline.notify(value: 200)

        XCTAssertEqual(value, 214)
    }

    func test_givenMerge3_whenOtherPipeline2Publish_thenSinkValue() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        await sut.merge(with: otherPipeline, and: otherPipeline2) {
            $0 + $1 + $2
        }.sink {
            await value.set(value: $0)
        }.store(in: pipelines)

        await otherPipeline2.notify(value: 20)

        XCTAssertEqual(value, 124)
    }

    func test_givenMerge4_whenGetValue_thenReturnMergeValue() async {
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        let otherPipeline3 = PublishingPipeline<UInt>(value: 1_000)
        let mergedPipeline = await sut.merge(with: otherPipeline, and: otherPipeline2, and: otherPipeline3) {
            $0 + $1 + $2 + $3
        }

        let value = await mergedPipeline.getValue()

        XCTAssertEqual(value, 1_114)
    }

    func test_givenMerge4_whenSutPublish_thenSinkValue() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        let otherPipeline3 = PublishingPipeline<UInt>(value: 1_000)
        await sut.merge(with: otherPipeline, and: otherPipeline2, and: otherPipeline3) {
            $0 + $1 + $2 + $3
        }.sink {
            await value.set(value: $0)
        }.store(in: pipelines)

        await sut.notify(value: 9)

        XCTAssertEqual(value, 1_119)
    }

    func test_givenMerge4_whenOtherPipelinePublish_thenSinkValue() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        let otherPipeline3 = PublishingPipeline<UInt>(value: 1_000)
        await sut.merge(with: otherPipeline, and: otherPipeline2, and: otherPipeline3) {
            $0 + $1 + $2 + $3
        }.sink {
            await value.set(value: $0)
        }.store(in: pipelines)

        await otherPipeline.notify(value: 200)

        XCTAssertEqual(value, 1_214)
    }

    func test_givenMerge4_whenOtherPipeline2Publish_thenSinkValue() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        let otherPipeline3 = PublishingPipeline<UInt>(value: 1_000)
        await sut.merge(with: otherPipeline, and: otherPipeline2, and: otherPipeline3) {
            $0 + $1 + $2 + $3
        }.sink {
            await value.set(value: $0)
        }.store(in: pipelines)

        await otherPipeline2.notify(value: 20)

        XCTAssertEqual(value, 1_124)
    }

    func test_givenMerge4_whenOtherPipeline3Publish_thenSinkValue() async {
        let value: Wrapper<UInt> = Wrapper(value: 0)
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        let otherPipeline3 = PublishingPipeline<UInt>(value: 1_000)
        await sut.merge(with: otherPipeline, and: otherPipeline2, and: otherPipeline3) {
            $0 + $1 + $2 + $3
        }.sink {
            await value.set(value: $0)
        }.store(in: pipelines)

        await otherPipeline3.notify(value: 2_000)

        XCTAssertEqual(value, 2_114)
    }

    func test_givenMultipleLongDelayedMapClosures_whenSink_thenResultedElementsAreInTheSameOrder() {
        let expectation = expectation(description: "")
        Task {
            await runMapIntegrationTest(numberOfElements: 20, delayNanosecondsMultiplier: 33_000_000)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func runMapIntegrationTest(numberOfElements: Int, delayNanosecondsMultiplier: UInt64) async {
        let inputElements = Array(1..<numberOfElements)
        let publishingPipeline = PublishingPipeline(value: 0)
        let pipelineOutputs: Wrapper<[Int]> = Wrapper(value: [])
        await publishingPipeline.map { value in
            try? await Task.sleep(nanoseconds: UInt64.random(in: 1...3) * delayNanosecondsMultiplier)
            return value
        }.sink { value in
            let values = await pipelineOutputs.get()
            await pipelineOutputs.set(value: values + [value])
        }.store(in: pipelines)

        for value in inputElements {
            await publishingPipeline.notify(value: value)
        }

        XCTAssertEqual(pipelineOutputs, [0] + inputElements)
    }
}
