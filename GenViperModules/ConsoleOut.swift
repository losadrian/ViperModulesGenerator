import Foundation

enum OutputType {
    case standard
    case error
}

class ConsoleOut {
    private init(){}
    
    class func writeMessage(_ message: String, to: OutputType = .standard) {
        print(message)
    }
    
    class func printUsage() {
        writeMessage("TODO: printUsage")
    }
}
