//
//  PublishingPipelineTests.swift
//  PipelineTests
//
//  Created by Kryštof Matěj on 08.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

@testable import Pipeline
import XCTest

final class PublishingPipelineTests: XCTestCase {
    func test_whenGetValue_thenReturnValue() async {
        let sut = PublishingPipeline<UInt>(value: 10)

        let value = await sut.value()

        XCTAssertEqual(value, 10)
    }

    func test_givenPublish_whenGetValue_thenReturnNewValue() async {
        let sut = PublishingPipeline<UInt>(value: 10)
        await sut.publish(value: 4)

        let value = await sut.value()

        XCTAssertEqual(value, 4)
    }
}
