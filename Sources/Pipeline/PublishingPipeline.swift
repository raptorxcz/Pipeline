public actor PublishingPipeline<Value: Sendable>: Pipeline {
    private var lastValue: Value
    private let subscribers = PipelineSubscribers<Value>()

    public init(value: Value) {
        lastValue = value
    }

    public func notify(value: Value) async {
        lastValue = value
        await subscribers.notify(with: value)
    }

    public func getValue() async -> Value {
        lastValue
    }

    public func getSubscribers() async -> PipelineSubscribers<Value> {
        subscribers
    }
}
