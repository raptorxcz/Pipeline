# Pipeline
Pipeline is a lightweight solution for asynchronous state propagation. 

## Motivation
We've found [CQRS](https://martinfowler.com/bliki/CQRS.html) to be extremely helpful in subscribing to state updates. It's a principle we use across many different architecture implementations and one of the few we insist on. The readability of Swift concurrency is the feature we wanted to introduce to our code. However, 1st party solutions don't work like we need to (just yet), so we implemented the tiniest possible solution.

## Considered alternatives
**AsyncStream** can't have multiple simultaneous listeners: obtaining values is a [consuming operation](https://github.com/apple/swift-async-algorithms/issues/110). Multiple views can't subscribe to one stream. 

**Combine** operators only accept synchronous closures. Calling asynchronous swift functions is not possible, and adding support proves difficult in some edge cases; for instance, using `Future` to synchronize multiple calls in `map` may mess up element order, and so on. Also, mixing two different level abstractions (Swift concurrency for _commands_ and Combine framework for _queries_) to implement one principle feels rough around the edges.

## Usage

### Create pipeline

```swift
class Storage {
	let pipeline = PublishingPipeline<Int>(value: 0)
}
```

### Getting value from pipeline

```swift
let value = await stoage.pipeline.value()
```

### Mapping value

```swift
func getNewValue() -> any Pipeline<Int> {
	return storage.pipeline.map { $0 + 42 }
}
```

### Merging multiple pipelines

```swift
func getNewValue() -> any Pipeline<Int> {
	return storage.pipeline.merge(with: anotherPipeline) { $0 + $1 + 42 }
}
```

### Sinking  values and storing pipeline

```swift
class Sample {
	private var runningPipelines = [SinkedPipeline]()
	...
	
	func getNewValue() -> any Pipeline<Int> {
		return storage.pipeline.sink { [weak self] value in
			await self?.handleUpdate(value)
		}.store(in: &runningPipelines)
	}
	
	func handleUpdate(_ value: Int) async {
		...
	}
}
```