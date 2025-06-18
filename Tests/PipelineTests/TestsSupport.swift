import XCTest

actor Wrapper<T> {
    @MainActor
    var value: T

    @MainActor
    init(value: T) {
        self.value = value
    }

    @MainActor
    func set(value: T) {
        self.value = value
    }

    @MainActor
    func get() -> T {
        value
    }
}

@MainActor
func XCTAssertEqual<T>(_ expression1: @autoclosure () -> Wrapper<T>, _ expression2: @autoclosure () -> T, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) where T: Equatable {
    let value = expression1().get()
    XCTAssertEqual(value, expression2(), message(), file: file, line: line)
}
