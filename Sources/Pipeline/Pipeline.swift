//
//  Pipeline.swift
//  Shared
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

public protocol Pipeline<Value>: Sendable {
    associatedtype Value: Sendable
    func getValue() async -> Value
    func getSubscribers() async -> PipelineSubscribers<Value>
}

public extension Pipeline {
    func map<T>(_ transform: @escaping @Sendable (Value) async -> T) async -> MapPipeline<T, Value> {
        return await MapPipeline(source: self, transform: transform)
    }

    func sink(_ receiveValue: @Sendable @escaping (Value) async -> Void) async -> SinkPipeline<Value> {
        return await SinkPipeline(source: self, receiveValue: receiveValue)
    }

    func sinkValue<T>(_ receiveValue: @escaping @Sendable (T) async -> Void) async -> SinkPipeline<Value> where Value == T? {
        return await SinkPipeline(source: self, receiveValue: { value in
            guard let value else {
                return
            }

            await receiveValue(value)
        })
    }

    func merge<T, X: Sendable>(
        with pipeline: any Pipeline<X>,
        transform: @escaping @Sendable (Value, X) async -> T
    ) async -> MergePipeline<T, Value, X> {
        return await MergePipeline<T, Value, X>(
            source1: self,
            source2: pipeline,
            transform: transform
        )
    }

    func merge<T, X: Sendable, Y: Sendable>(
        with pipeline: any Pipeline<X>,
        and pipeline2: any Pipeline<Y>,
        transform: @escaping @Sendable (Value, X, Y) async -> T
    ) async -> Merge3Pipeline<T, Value, X, Y> {
        return await Merge3Pipeline<T, Value, X, Y>(
            source1: self,
            source2: pipeline,
            source3: pipeline2,
            transform: transform
        )
    }

    func merge<T, X: Sendable, Y: Sendable, Z: Sendable>(
        with pipeline: any Pipeline<X>,
        and pipeline2: any Pipeline<Y>,
        and pipeline3: any Pipeline<Z>,
        transform: @escaping @Sendable (Value, X, Y, Z) async -> T
    ) async -> Merge4Pipeline<T, Value, X, Y, Z> {
        return await Merge4Pipeline<T, Value, X, Y, Z>(
            source1: self,
            source2: pipeline,
            source3: pipeline2,
            source4: pipeline3,
            transform: transform
        )
    }

    func merge<T, X: Sendable, Y: Sendable, Z: Sendable, A: Sendable>(
        with pipeline: any Pipeline<X>,
        and pipeline2: any Pipeline<Y>,
        and pipeline3: any Pipeline<Z>,
        and pipeline4: any Pipeline<A>,
        transform: @escaping @Sendable (Value, X, Y, Z, A) async -> T
    ) async -> Merge5Pipeline<T, Value, X, Y, Z, A> {
        return await Merge5Pipeline<T, Value, X, Y, Z, A>(
            source1: self,
            source2: pipeline,
            source3: pipeline2,
            source4: pipeline3,
            source5: pipeline4,
            transform: transform
        )
    }

    func merge<T, X: Sendable, Y: Sendable, Z: Sendable, A: Sendable, B: Sendable>(
        with pipeline: any Pipeline<X>,
        and pipeline2: any Pipeline<Y>,
        and pipeline3: any Pipeline<Z>,
        and pipeline4: any Pipeline<A>,
        and pipeline5: any Pipeline<B>,
        transform: @escaping @Sendable (Value, X, Y, Z, A, B) async -> T
    ) async -> Merge6Pipeline<T, Value, X, Y, Z, A, B> {
        return await Merge6Pipeline<T, Value, X, Y, Z, A, B>(
            source1: self,
            source2: pipeline,
            source3: pipeline2,
            source4: pipeline3,
            source5: pipeline4,
            source6: pipeline5,
            transform: transform
        )
    }
}
