//
//  Pipeline.swift
//  Shared
//
//  Created by Kryštof Matěj on 03.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

public protocol Pipeline<Value> {
    associatedtype Value
    func value() async -> Value
    func getContext() async -> PipelineContext<Value>
}

public extension Pipeline {
    func map<T>(_ block: @escaping (Value) async -> T) async -> MapPipeline<T, Value> {
        return await MapPipeline(source: self, subscription: getContext(), map: block)
    }

    func sink(_ block: @escaping (Value) async -> Void) async -> SinkPipeline<Value> {
        return await SinkPipeline(source: self, subscription: getContext(), sink: block)
    }

    func sink<T, S: AnyObject>(
        self weakSelf: S, _ block: @escaping (S, T) async -> Void
    ) async -> SinkPipeline<Value> where Value == T? {
        return await SinkPipeline(source: self, subscription: getContext(), sink: { [weak weakSelf] value in
            guard let weakSelf else {
                return
            }

            guard let value else {
                return
            }

            await block(weakSelf, value)
        })
    }

    func sink<T, S: AnyObject>(
        self weakSelf: S, _ block: @escaping (S, T) async -> Void
    ) async -> SinkPipeline<Value> where Value == T {
        return await SinkPipeline(source: self, subscription: getContext(), sink: { [weak weakSelf] value in
            guard let weakSelf else {
                return
            }

            await block(weakSelf, value)
        })
    }

    func merge<T, X>(with pipeline: any Pipeline<X>, block: @escaping (Value, X) async -> T) async -> MergePipeline<T, Value, X> {
        return await MergePipeline<T, Value, X>(
            source1: self,
            source2: pipeline,
            subscription1: getContext(),
            subscription2: pipeline.getContext(),
            merge: block
        )
    }

    func merge<T, X, Y>(
        with pipeline: any Pipeline<X>,
        and pipeline2: any Pipeline<Y>,
        block: @escaping (Value, X, Y) async -> T
    ) async -> Merge3Pipeline<T, Value, X, Y> {
        return await Merge3Pipeline<T, Value, X, Y>(
            source1: self,
            source2: pipeline,
            source3: pipeline2,
            subscription1: getContext(),
            subscription2: pipeline.getContext(),
            subscription3: pipeline2.getContext(),
            merge: block
        )
    }

    func merge<T, X, Y, Z>(
        with pipeline: any Pipeline<X>,
        and pipeline2: any Pipeline<Y>,
        and pipeline3: any Pipeline<Z>,
        block: @escaping (Value, X, Y, Z) async -> T
    ) async -> Merge4Pipeline<T, Value, X, Y, Z> {
        return await Merge4Pipeline<T, Value, X, Y, Z>(
            source1: self,
            source2: pipeline,
            source3: pipeline2,
            source4: pipeline3,
            subscription1: getContext(),
            subscription2: pipeline.getContext(),
            subscription3: pipeline2.getContext(),
            subscription4: pipeline3.getContext(),
            merge: block
        )
    }

    func merge<T, X, Y, Z, A>(
        with pipeline: any Pipeline<X>,
        and pipeline2: any Pipeline<Y>,
        and pipeline3: any Pipeline<Z>,
        and pipeline4: any Pipeline<A>,
        block: @escaping (Value, X, Y, Z, A) async -> T
    ) async -> Merge5Pipeline<T, Value, X, Y, Z, A> {
        return await Merge5Pipeline<T, Value, X, Y, Z, A>(
            source1: self,
            source2: pipeline,
            source3: pipeline2,
            source4: pipeline3,
            source5: pipeline4,
            subscription1: getContext(),
            subscription2: pipeline.getContext(),
            subscription3: pipeline2.getContext(),
            subscription4: pipeline3.getContext(),
            subscription5: pipeline4.getContext(),
            merge: block
        )
    }

    func merge<T, X, Y, Z, A, B>(
        with pipeline: any Pipeline<X>,
        and pipeline2: any Pipeline<Y>,
        and pipeline3: any Pipeline<Z>,
        and pipeline4: any Pipeline<A>,
        and pipeline5: any Pipeline<B>,
        block: @escaping (Value, X, Y, Z, A, B) async -> T
    ) async -> Merge6Pipeline<T, Value, X, Y, Z, A, B> {
        return await Merge6Pipeline<T, Value, X, Y, Z, A, B>(
            source1: self,
            source2: pipeline,
            source3: pipeline2,
            source4: pipeline3,
            source5: pipeline4,
            source6: pipeline5,
            subscription1: getContext(),
            subscription2: pipeline.getContext(),
            subscription3: pipeline2.getContext(),
            subscription4: pipeline3.getContext(),
            subscription5: pipeline4.getContext(),
            subscription6: pipeline5.getContext(),
            merge: block
        )
    }
}
