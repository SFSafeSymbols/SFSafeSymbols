import Foundation

var stderr = FileHandle.standardError

extension FileHandle: TextOutputStream {
    
    public func write(_ string: String) {
        let data = string.data(using: .utf8, allowLossyConversion: true)!
        self.write(data)
    }
}
