//
//  PipelineContext.swift
//  Shared
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

public actor PipelineContext<Value>: PipelineSubscription {
    private var subscriptions = [Subscription<Value>]()

    func addSubscription(listener: AnyObject, block: @escaping PipelineBlock<Value>) {
        subscriptions.append(Subscription<Value>(
            listener: listener,
            block: block
        ))
    }

    func publish(value: Value) async {
        removeDeadSubscriptions()

        for subscription in subscriptions {
            await subscription.block(value)
        }
    }

    private func removeDeadSubscriptions() {
        let newSubscriptions = subscriptions.filter { subscription in
            return subscription.listener != nil
        }
        subscriptions = newSubscriptions
    }
}

private struct Subscription<Value> {
    weak var listener: AnyObject?
    let block: PipelineBlock<Value>
}

typealias PipelineBlock<Value> = (Value) async -> Void

protocol PipelineSubscription<Value> {
    associatedtype Value
    func addSubscription(listener: AnyObject, block: @escaping PipelineBlock<Value>) async
}
