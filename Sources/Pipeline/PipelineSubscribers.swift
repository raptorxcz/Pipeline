public actor PipelineSubscribers<Value: Sendable> {
    typealias PipelineUpdateBlock = @Sendable (Value) async -> Void

    private struct Subscriber {
        weak var entity: AnyObject?
        let block: PipelineUpdateBlock
    }

    private var subscribers = [Subscriber]()

    func addSubscriber(_ entity: AnyObject, block: @escaping PipelineUpdateBlock) {
        subscribers.append(Subscriber(
            entity: entity,
            block: block
        ))
    }

    func notify(with value: Value) async {
        removeDeadSubscribers()

        for subscriber in subscribers {
            await subscriber.block(value)
        }
    }

    private func removeDeadSubscribers() {
        let newSubscribers = subscribers.filter { subscriber in
            return subscriber.entity != nil
        }
        subscribers = newSubscribers
    }
}
