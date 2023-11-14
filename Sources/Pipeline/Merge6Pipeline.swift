public final class Merge6Pipeline<Value, Source1, Source2, Source3, Source4, Source5, Source6>: Pipeline {
    // strong reference to sources Pipelines
    // This is holding whole pipelines stack.
    // If this is released then whole pipelines stack is released
    private let source1: any Pipeline<Source1>
    private let source2: any Pipeline<Source2>
    private let source3: any Pipeline<Source3>
    private let source4: any Pipeline<Source4>
    private let source5: any Pipeline<Source5>
    private let source6: any Pipeline<Source6>
    private let merge: (Source1, Source2, Source3, Source4, Source5, Source6) async -> Value
    private var subscriptions = PipelineContext<Value>()

    init(
        source1: any Pipeline<Source1>,
        source2: any Pipeline<Source2>,
        source3: any Pipeline<Source3>,
        source4: any Pipeline<Source4>,
        source5: any Pipeline<Source5>,
        source6: any Pipeline<Source6>,
        subscription1: any PipelineSubscription<Source1>,
        subscription2: any PipelineSubscription<Source2>,
        subscription3: any PipelineSubscription<Source3>,
        subscription4: any PipelineSubscription<Source4>,
        subscription5: any PipelineSubscription<Source5>,
        subscription6: any PipelineSubscription<Source6>,
        merge: @escaping (Source1, Source2, Source3, Source4, Source5, Source6) async -> Value
    ) async {
        self.source1 = source1
        self.source2 = source2
        self.source3 = source3
        self.source4 = source4
        self.source5 = source5
        self.source6 = source6
        self.merge = merge
        await subscription1.addSubscription(listener: self) { [weak self] value in
            await self?.publish(value1: value, value2: source2.value(), value3: source3.value(), value4: source4.value(), value5: source5.value(), value6: source6.value())
        }
        await subscription2.addSubscription(listener: self) { [weak self] value in
            await self?.publish(value1: source1.value(), value2: value, value3: source3.value(), value4: source4.value(), value5: source5.value(), value6: source6.value())
        }
        await subscription3.addSubscription(listener: self) { [weak self] value in
            await self?.publish(value1: source1.value(), value2: source2.value(), value3: value, value4: source4.value(), value5: source5.value(), value6: source6.value())
        }
        await subscription4.addSubscription(listener: self) { [weak self] value in
            await self?.publish(value1: source1.value(), value2: source2.value(), value3: source3.value(), value4: value, value5: source5.value(), value6: source6.value())
        }
        await subscription5.addSubscription(listener: self) { [weak self] value in
            await self?.publish(value1: source1.value(), value2: source2.value(), value3: source3.value(), value4: source4.value(), value5: value, value6: source6.value())
        }
        await subscription6.addSubscription(listener: self) { [weak self] value in
            await self?.publish(value1: source1.value(), value2: source2.value(), value3: source3.value(), value4: source4.value(), value5: source5.value(), value6: value)
        }
    }

    public func value() async -> Value {
        return await merge(source1.value(), source2.value(), source3.value(), source4.value(), source5.value(), source6.value())
    }

    private func publish(value1: Source1, value2: Source2, value3: Source3, value4: Source4, value5: Source5, value6: Source6) async {
        let newValue = await merge(value1, value2, value3, value4, value5, value6)
        await subscriptions.publish(value: newValue)
    }

    public func getContext() -> PipelineContext<Value> {
        return subscriptions
    }
}
