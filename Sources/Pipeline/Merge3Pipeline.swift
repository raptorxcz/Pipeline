public final class Merge3Pipeline<Value: Sendable, Source1: Sendable, Source2: Sendable, Source3: Sendable>: Pipeline {
    // strong reference to sources Pipelines
    // This is holding whole pipelines stack.
    // If this is released then whole pipelines stack is released
    private let source1: any Pipeline<Source1>
    private let source2: any Pipeline<Source2>
    private let source3: any Pipeline<Source3>
    private let transform: @Sendable (Source1, Source2, Source3) async -> Value
    private let subscribers = PipelineSubscribers<Value>()

    init(
        source1: any Pipeline<Source1>,
        source2: any Pipeline<Source2>,
        source3: any Pipeline<Source3>,
        transform: @Sendable @escaping (Source1, Source2, Source3) async -> Value
    ) async {
        self.source1 = source1
        self.source2 = source2
        self.source3 = source3
        self.transform = transform
        await source1.getSubscribers().addSubscriber(self) { [weak self] value in
            await self?.notify(value1: value, value2: source2.getValue(), value3: source3.getValue())
        }
        await source2.getSubscribers().addSubscriber(self) { [weak self] value in
            await self?.notify(value1: source1.getValue(), value2: value, value3: source3.getValue())
        }
        await source3.getSubscribers().addSubscriber(self) { [weak self] value in
            await self?.notify(value1: source1.getValue(), value2: source2.getValue(), value3: value)
        }
    }

    public func getValue() async -> Value {
        await transform(source1.getValue(), source2.getValue(), source3.getValue())
    }

    private func notify(value1: Source1, value2: Source2, value3: Source3) async {
        let newValue = await transform(value1, value2, value3)
        await subscribers.notify(with: newValue)
    }

    public func getSubscribers() async -> PipelineSubscribers<Value> {
        subscribers
    }
}
