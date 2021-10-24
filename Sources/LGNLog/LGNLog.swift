import Foundation
@_exported import Logging

extension Logger: @unchecked Sendable {}

public extension Logger {
    @TaskLocal
    static var current = Logger(label: "default")
}

extension Logging.Logger.MetadataValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        switch self {
        case let .string(string):
            try string.encode(to: encoder)
        case let .stringConvertible(stringConvertible):
            try stringConvertible.description.encode(to: encoder)
        case let .dictionary(metadata):
            try metadata.encode(to: encoder)
        case let .array(array):
            try array.encode(to: encoder)
        }
    }
}

public struct LGNLogger: LogHandler {
    enum E: Error {
        case DataToJSONConvertionError
    }

    public var metadata = Logging.Logger.Metadata()

    public static var logLevel: Logging.Logger.Level = .info
    public static var hideTimezone = false
    public static var hideLabel = false
    public static var requestIDKey: String? = "requestID"

    private var _logLevel: Logging.Logger.Level? = nil
    public var logLevel: Logging.Logger.Level {
        get {
            self._logLevel ?? Self.logLevel
        }
        set {
            self._logLevel = newValue
        }
    }

    private let encoder = JSONEncoder()

    public var label: String

    public init(label: String) {
        self.label = label
    }

    public subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get {
            self.metadata[key]
        }
        set {
            self.metadata[key] = newValue
        }
    }

    public func log(
        level: Logging.Logger.Level,
        message: Logging.Logger.Message,
        metadata: Logging.Logger.Metadata?,
        file: String,
        function: String,
        line: UInt
    ) {
        var date = Date().description
        if Self.hideTimezone {
            date = date.replacingOccurrences(of: " +0000", with: "")
        }

        let _file = file.split(separator: "/").last!
        let _label: String = (!Self.hideLabel && self.logLevel <= .debug ? label : nil).map { " [\($0)]" } ?? ""
        let at = "\(date) @ \(_file.replacingOccurrences(of: ".swift", with: "")):\(line)"
        var preamble = "[\(at)]\(_label) [\(level)]"

        var prettyMetadata: String? = nil
        var mergedMetadata = self.metadata
        if let metadata = metadata {
            mergedMetadata = self.metadata.merging(metadata, uniquingKeysWith: { _, new in new })
        }
        if let requestIDKey = Self.requestIDKey, let requestID = mergedMetadata.removeValue(forKey: requestIDKey) {
            preamble.append(contentsOf: " [\(requestID)]")
        }
        if !mergedMetadata.isEmpty {
            do {
                let JSONData = try self.encoder.encode(mergedMetadata)
                guard let string = String(data: JSONData, encoding: .ascii) else {
                    throw E.DataToJSONConvertionError
                }
                prettyMetadata = string
            } catch {
                print("Could not encode metadata '\(mergedMetadata)' to JSON: \(error)")
            }
        }

        print("\(preamble): \(message)\(prettyMetadata.map { " (metadata: \($0))" } ?? "")")
    }

    private func prettify(_ metadata: Logging.Logger.Metadata) -> String? {
        !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }
}
