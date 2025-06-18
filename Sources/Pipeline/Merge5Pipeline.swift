public final class Merge5Pipeline<Value: Sendable, Source1: Sendable, Source2: Sendable, Source3: Sendable, Source4: Sendable, Source5: Sendable>: Pipeline {
    // strong reference to sources Pipelines
    // This is holding whole pipelines stack.
    // If this is released then whole pipelines stack is released
    private let source1: any Pipeline<Source1>
    private let source2: any Pipeline<Source2>
    private let source3: any Pipeline<Source3>
    private let source4: any Pipeline<Source4>
    private let source5: any Pipeline<Source5>
    private let transform: @Sendable (Source1, Source2, Source3, Source4, Source5) async -> Value
    private let subscribers = PipelineSubscribers<Value>()

    init(
        source1: any Pipeline<Source1>,
        source2: any Pipeline<Source2>,
        source3: any Pipeline<Source3>,
        source4: any Pipeline<Source4>,
        source5: any Pipeline<Source5>,
        transform: @Sendable @escaping (Source1, Source2, Source3, Source4, Source5) async -> Value
    ) async {
        self.source1 = source1
        self.source2 = source2
        self.source3 = source3
        self.source4 = source4
        self.source5 = source5
        self.transform = transform
        await source1.getSubscribers().addSubscriber(self) { [weak self] value in
            await self?.notify(value1: value, value2: source2.getValue(), value3: source3.getValue(), value4: source4.getValue(), value5: source5.getValue())
        }
        await source2.getSubscribers().addSubscriber(self) { [weak self] value in
            await self?.notify(value1: source1.getValue(), value2: value, value3: source3.getValue(), value4: source4.getValue(), value5: source5.getValue())
        }
        await source3.getSubscribers().addSubscriber(self) { [weak self] value in
            await self?.notify(value1: source1.getValue(), value2: source2.getValue(), value3: value, value4: source4.getValue(), value5: source5.getValue())
        }
        await source4.getSubscribers().addSubscriber(self) { [weak self] value in
            await self?.notify(value1: source1.getValue(), value2: source2.getValue(), value3: source3.getValue(), value4: value, value5: source5.getValue())
        }
        await source5.getSubscribers().addSubscriber(self) { [weak self] value in
            await self?.notify(value1: source1.getValue(), value2: source2.getValue(), value3: source3.getValue(), value4: source4.getValue(), value5: value)
        }
    }

    public func getValue() async -> Value {
        return await transform(source1.getValue(), source2.getValue(), source3.getValue(), source4.getValue(), source5.getValue())
    }

    private func notify(value1: Source1, value2: Source2, value3: Source3, value4: Source4, value5: Source5) async {
        let newValue = await transform(value1, value2, value3, value4, value5)
        await subscribers.notify(with: newValue)
    }

    public func getSubscribers() async -> PipelineSubscribers<Value> {
        return subscribers
    }
}
