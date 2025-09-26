import Foundation

var stderr: some TextOutputStream = FileHandleWrapper(base: FileHandle.standardError)

private struct FileHandleWrapper: TextOutputStream {
    let base: FileHandle
    
    func write(_ string: String) {
        let data = string.data(using: .utf8, allowLossyConversion: true)!
        base.write(data)
    }
}
