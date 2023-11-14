//
//  PipelineSubscriptionSpy.swift
//  PipelineTests
//
//  Created by Kryštof Matěj on 08.05.2023.
//  Copyright © 2023 Cleverlance. All rights reserved.
//

@testable import Pipeline

final class PipelineSubscriptionSpy<Value>: PipelineSubscription {
    struct AddSubscription {
        let listener: AnyObject
        let block: PipelineBlock<Value>
    }

    var addSubscription = [AddSubscription]()

    func addSubscription(listener: AnyObject, block: @escaping PipelineBlock<Value>) {
        let item = AddSubscription(listener: listener, block: block)
        addSubscription.append(item)
    }
}
