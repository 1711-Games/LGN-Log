# LGNLog

A custom logger implementation and [TaskLocal](https://developer.apple.com/documentation/swift/tasklocal?language=swift)
helper for [Swift-Log](https://github.com/apple/swift-log).

# Why and how

This package provides two and a half things (and a small bonus):

* TaskLocal support for `Logger` struct
* A custom (and a pretty one) log handler implementation
* Also it does `import Logging` so you don't have to (.mp4), just import `LGNLog` and it will work

## TaskLocal

As per this package `Logger` now has `@TaskLocal var current` property which does precisely what you think it does:
your app can call `Logger.current` in every place you can imagine to get a current logger, and you shouldn't bother
creating new temporary loggers here and there. By default it's just a simple logger with label `default`.
Sure enough, you can bind it to your configured logger for some async `Task` just like that:
```swift
var logger = Logger(label: "custom_label")
logger[metadataKey: "requestID"] = "\(UUID())"
Logger.$current.withValue(logger) {
    Logger.current.info("hello")
}
```
And there you have it.

## Custom implementation

Of course, default formatting isn't very pretty:

`
2021-10-23T17:51:14+0300 info custom_label : FileLine=main.swift:322 requestID=00000000-1637-0034-1711-000000000000 Hello
`

so this package comes with a prettier formatting. You can enable it by calling:

```swift
LoggingSystem.bootstrap(LGNLogger.init)
```

Et voilà:

`
[2021-10-24 13:01:57 +0000 @ main.swift:322] [custom_label] [info] [00000000-1637-0034-1711-000000000000]: Hello (metadata: {"FileLine":"main.swift:322"})
`

Additionally, it has a few config vars:

### Sets a log level globally for all loggers initiated with this backend (`.info` by default):

```swift
LGNLogger.logLevel = .trace
```

### Hides timezone from log message (saves a few bytes) (`false` by default)

```swift
LGNLogger.hideTimezone = true
```

### Hides label from log message (`false` by default)

```swift
LGNLogger.hideLabel = true
```

### Fetches request ID from Metadata and puts in preamble (`requestID` by default)

```swift
LGNLogger.requestIDKey = "customRequestIDKey"
```
