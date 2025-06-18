@testable import Pipeline
import XCTest

@MainActor
public final class PipelineSpy<Value: Sendable>: Pipeline {
    public var valueCount = 0
    public var valueReturn: Value
    private let subscribers = PipelineSubscribers<Value>()

    public init(valueReturn: Value) {
        self.valueReturn = valueReturn
    }

    public func getValue() async -> Value {
        valueCount += 1
        return valueReturn
    }

    public func notify(value: Value) async {
        await subscribers.notify(with: value)
    }

    public func getSubscribers() async -> PipelineSubscribers<Value> {
        subscribers
    }
}
