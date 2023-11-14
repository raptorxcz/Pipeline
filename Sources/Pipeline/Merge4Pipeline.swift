public final class Merge4Pipeline<Value, Source1, Source2, Source3, Source4>: Pipeline {
    // strong reference to sources Pipelines
    // This is holding whole pipelines stack.
    // If this is released then whole pipelines stack is released
    private let source1: any Pipeline<Source1>
    private let source2: any Pipeline<Source2>
    private let source3: any Pipeline<Source3>
    private let source4: any Pipeline<Source4>
    private let merge: (Source1, Source2, Source3, Source4) async -> Value
    private var subscriptions = PipelineContext<Value>()

    init(
        source1: any Pipeline<Source1>,
        source2: any Pipeline<Source2>,
        source3: any Pipeline<Source3>,
        source4: any Pipeline<Source4>,
        subscription1: any PipelineSubscription<Source1>,
        subscription2: any PipelineSubscription<Source2>,
        subscription3: any PipelineSubscription<Source3>,
        subscription4: any PipelineSubscription<Source4>,
        merge: @escaping (Source1, Source2, Source3, Source4) async -> Value
    ) async {
        self.source1 = source1
        self.source2 = source2
        self.source3 = source3
        self.source4 = source4
        self.merge = merge
        await subscription1.addSubscription(listener: self) { [weak self] value in
            await self?.publish(value1: value, value2: source2.value(), value3: source3.value(), value4: source4.value())
        }
        await subscription2.addSubscription(listener: self) { [weak self] value in
            await self?.publish(value1: source1.value(), value2: value, value3: source3.value(), value4: source4.value())
        }
        await subscription3.addSubscription(listener: self) { [weak self] value in
            await self?.publish(value1: source1.value(), value2: source2.value(), value3: value, value4: source4.value())
        }
        await subscription4.addSubscription(listener: self) { [weak self] value in
            await self?.publish(value1: source1.value(), value2: source2.value(), value3: source3.value(), value4: value)
        }
    }

    public func value() async -> Value {
        return await merge(source1.value(), source2.value(), source3.value(), source4.value())
    }

    private func publish(value1: Source1, value2: Source2, value3: Source3, value4: Source4) async {
        let newValue = await merge(value1, value2, value3, value4)
        await subscriptions.publish(value: newValue)
    }

    public func getContext() -> PipelineContext<Value> {
        return subscriptions
    }
}
