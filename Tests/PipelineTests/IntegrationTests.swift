//
//  IntegrationTests.swift
//  SharedTests
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

import Pipeline
import XCTest

final class IntegrationTests: SutTestCase<PublishingPipeline<UInt>> {
    private var pipelines: [SinkedPipeline]!
    private var storedValue: UInt = 0

    override func setUp() {
        pipelines = []
        sut = PublishingPipeline<UInt>(value: 4)
    }

    override func tearDown() {
        super.tearDown()
        pipelines = nil
    }

    func test_whenGetValue_thenReturnInitValue() async {
        let value = await sut.value()

        XCTAssertEqual(value, 4)
    }

    func test_givenPublishValue_whenGetValue_thenReturnNewValue() async {
        await sut.publish(value: 5)

        let value = await sut.value()

        XCTAssertEqual(value, 5)
    }

    func test_whenSink_thenUpdateValue() async {
        var value: UInt = 0

        await sut.sink { newValue in
            value = newValue
        }.store(in: &pipelines)

        XCTAssertEqual(value, 4)
    }

    func test_givenSinkValue_whenPublish_thenUpdateValue() async {
        var value: UInt = 0
        await sut.sink { newValue in
            value = newValue
        }.store(in: &pipelines)

        await sut.publish(value: 9)

        XCTAssertEqual(value, 9)
    }

    func test_givenSinkValueAndNotStored_whenPublish_thenNotUpdateValue() async {
        var value: UInt = 0
        _ = await sut.sink { newValue in
            value = newValue
        }

        await sut.publish(value: 9)

        XCTAssertEqual(value, 4)
    }

    func test_givenMapValue_whenGetValue_thenReturnUpdatedValue() async {
        let newPipeline = await sut.map { value in
            return value + 100
        }

        let value = await newPipeline.value()

        XCTAssertEqual(value, 104)
    }

    func test_givenMapAndSinkValueNotStored_whenPublish_thenNotUpdate() async {
        var value: UInt = 0
        let mapPipeline = await sut.map {
            $0 + 100
        }
        _ = await mapPipeline.sink { newValue in
            value = newValue
        }

        await sut.publish(value: 9)

        XCTAssertEqual(value, 104)
    }

    func test_givenSinkValueAndRemoveReferenceWithStored_whenPublish_thenUpdate() async {
        var value: UInt = 0
        let mapPipeline = await sut.map {
            $0 + 100
        }
        await mapPipeline.sink { newValue in
            value = newValue
        }.store(in: &pipelines)

        await sut.publish(value: 9)

        XCTAssertEqual(value, 109)
    }

    func test_givenMerge_whenGetValue_thenReturnMergeValue() async {
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let mergedPipeline = await sut.merge(with: otherPipeline) {
            return $0 + $1
        }

        let value = await mergedPipeline.value()

        XCTAssertEqual(value, 104)
    }

    func test_givenMerge_whenSutPublish_thenSinkValue() async {
        var value: UInt = 0
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        await sut.merge(with: otherPipeline) {
            return $0 + $1
        }.sink {
            value = $0
        }.store(in: &pipelines)

        await sut.publish(value: 9)

        XCTAssertEqual(value, 109)
    }

    func test_givenMerge_whenOtherPipelinePublish_thenSinkValue() async {
        var value: UInt = 0
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        await sut.merge(with: otherPipeline) {
            return $0 + $1
        }.sink {
            value = $0
        }.store(in: &pipelines)

        await otherPipeline.publish(value: 200)

        XCTAssertEqual(value, 204)
    }

    func test_givenMerge3_whenGetValue_thenReturnMergeValue() async {
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        let mergedPipeline = await sut.merge(with: otherPipeline, and: otherPipeline2) {
            return $0 + $1 + $2
        }

        let value = await mergedPipeline.value()

        XCTAssertEqual(value, 114)
    }

    func test_givenMerge3_whenSutPublish_thenSinkValue() async {
        var value: UInt = 0
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        await sut.merge(with: otherPipeline, and: otherPipeline2) {
            return $0 + $1 + $2
        }.sink {
            value = $0
        }.store(in: &pipelines)

        await sut.publish(value: 9)

        XCTAssertEqual(value, 119)
    }

    func test_givenMerge3_whenOtherPipelinePublish_thenSinkValue() async {
        var value: UInt = 0
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        await sut.merge(with: otherPipeline, and: otherPipeline2) {
            return $0 + $1 + $2
        }.sink {
            value = $0
        }.store(in: &pipelines)

        await otherPipeline.publish(value: 200)

        XCTAssertEqual(value, 214)
    }

    func test_givenMerge3_whenOtherPipeline2Publish_thenSinkValue() async {
        var value: UInt = 0
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        await sut.merge(with: otherPipeline, and: otherPipeline2) {
            return $0 + $1 + $2
        }.sink {
            value = $0
        }.store(in: &pipelines)

        await otherPipeline2.publish(value: 20)

        XCTAssertEqual(value, 124)
    }

    func test_givenMerge4_whenGetValue_thenReturnMergeValue() async {
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        let otherPipeline3 = PublishingPipeline<UInt>(value: 1_000)
        let mergedPipeline = await sut.merge(with: otherPipeline, and: otherPipeline2, and: otherPipeline3) {
            return $0 + $1 + $2 + $3
        }

        let value = await mergedPipeline.value()

        XCTAssertEqual(value, 1_114)
    }

    func test_givenMerge4_whenSutPublish_thenSinkValue() async {
        var value: UInt = 0
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        let otherPipeline3 = PublishingPipeline<UInt>(value: 1_000)
        await sut.merge(with: otherPipeline, and: otherPipeline2, and: otherPipeline3) {
            return $0 + $1 + $2 + $3
        }.sink {
            value = $0
        }.store(in: &pipelines)

        await sut.publish(value: 9)

        XCTAssertEqual(value, 1_119)
    }

    func test_givenMerge4_whenOtherPipelinePublish_thenSinkValue() async {
        var value: UInt = 0
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        let otherPipeline3 = PublishingPipeline<UInt>(value: 1_000)
        await sut.merge(with: otherPipeline, and: otherPipeline2, and: otherPipeline3) {
            return $0 + $1 + $2 + $3
        }.sink {
            value = $0
        }.store(in: &pipelines)

        await otherPipeline.publish(value: 200)

        XCTAssertEqual(value, 1_214)
    }

    func test_givenMerge4_whenOtherPipeline2Publish_thenSinkValue() async {
        var value: UInt = 0
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        let otherPipeline3 = PublishingPipeline<UInt>(value: 1_000)
        await sut.merge(with: otherPipeline, and: otherPipeline2, and: otherPipeline3) {
            return $0 + $1 + $2 + $3
        }.sink {
            value = $0
        }.store(in: &pipelines)

        await otherPipeline2.publish(value: 20)

        XCTAssertEqual(value, 1_124)
    }

    func test_givenMerge4_whenOtherPipeline3Publish_thenSinkValue() async {
        var value: UInt = 0
        let otherPipeline = PublishingPipeline<UInt>(value: 100)
        let otherPipeline2 = PublishingPipeline<UInt>(value: 10)
        let otherPipeline3 = PublishingPipeline<UInt>(value: 1_000)
        await sut.merge(with: otherPipeline, and: otherPipeline2, and: otherPipeline3) {
            return $0 + $1 + $2 + $3
        }.sink {
            value = $0
        }.store(in: &pipelines)

        await otherPipeline3.publish(value: 2_000)

        XCTAssertEqual(value, 2_114)
    }

    func test_whenSinkWithSelf_thenSinkValue() async {
        let sut = PublishingPipeline<UInt?>(value: 4)
        await sut.sink(self: self) { (self, value) in
            self.storedValue = value
        }.store(in: &pipelines)

        await sut.publish(value: 2_000)

        XCTAssertEqual(storedValue, 2_000)
    }

    func test_givenMultipleLongDelayedMapClosures_whenSink_thenResultedElementsAreInTheSameOrder() {
        let expectation = expectation(description: "")
        Task {
            await runMapIntegrationTest(numberOfElements: 20, delayNanosecondsMultiplier: 33_000_000)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    func runMapIntegrationTest(numberOfElements: Int, delayNanosecondsMultiplier: UInt64) async {
        let inputElements = Array(1 ..< numberOfElements)
        let publishingPipeline = PublishingPipeline(value: 0)
        var pipelineOutputs: [Int] = []
        await publishingPipeline.map { value in
            return await self.randomDelay(of: value, nanosecondsMultiplier: delayNanosecondsMultiplier)
        }.sink { value in
            pipelineOutputs.append(value)
        }.store(in: &pipelines)

        for value in inputElements {
            await publishingPipeline.publish(value: value)
        }

        XCTAssertEqual(pipelineOutputs, [0] + inputElements)
    }

    private func randomDelay(of value: Int, nanosecondsMultiplier: UInt64) async -> Int {
        try? await Task.sleep(nanoseconds: UInt64.random(in: 1 ... 3) * nanosecondsMultiplier)
        return value
    }
}
