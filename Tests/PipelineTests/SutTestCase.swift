//
//  SutTestCase.swift
//  PipelineTests
//
//  Created by Kryštof Matěj on 06.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

import XCTest

open class SutTestCase<T>: XCTestCase {
    var sut: T!

    override open func tearDown() {
        super.tearDown()
    }
}
