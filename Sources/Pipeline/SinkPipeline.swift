public actor SinkedPipelinesStorage {
    private var pipelines = [Sendable]()

    public init() {}

    public func store(_ pipeline: Sendable) {
        pipelines.append(pipeline)
    }

    public func removeAll() {
        pipelines.removeAll()
    }
}

public final class SinkPipeline<Source: Sendable>: Sendable {
    // Strong reference to source `Pipeline`
    // This is holding whole pipeline stack.
    // If this is released then whole pipeline stack is released
    private let source: any Pipeline<Source>
    private let receiveValue: @Sendable (Source) async -> Void

    init(
        source: any Pipeline<Source>,
        receiveValue: @escaping @Sendable (Source) async -> Void
    ) async {
        self.source = source
        self.receiveValue = receiveValue
        await source.getSubscribers().addSubscriber(self) { [weak self] value in
            await self?.receiveValue(value)
        }
        await receiveValue(source.getValue())
    }

    public func store(in storage: SinkedPipelinesStorage) async {
        await storage.store(self)
    }
}
