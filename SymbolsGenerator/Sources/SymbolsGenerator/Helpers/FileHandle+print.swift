import Foundation
import Synchronization

private let stderrLock = Mutex(FileHandle.standardError)

func printToStdErr(_ items: Any..., separator: String = " ", terminator: String = "\n") {

    stderrLock.withLock { handle in
        let str = items.map { "\($0)" }.joined(separator: separator) + terminator
        guard let data = str.data(using: .utf8, allowLossyConversion: true) else { return }
        handle.write(data)
    }
}
