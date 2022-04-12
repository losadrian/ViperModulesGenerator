import Foundation

enum OptionType: String {
    case userName = "-u"
    case projectName = "-p"
    case unknown
    
    init(value: String) {
        switch value {
        case "-u": self = .userName
        case "-p": self = .projectName
        default: self = .unknown
        }
    }
}

class ArgumentHandler {
    private init(){}
    
    class func getArgumentDictionary(from arguments:[String]) -> Dictionary<String, String>? {
        var argumentDictionary = Dictionary<String, String>()
        
        for i in 1..<arguments.count {
            let argument = arguments[i]
            
            if (argument.first == "-") {
                let optionTypeArgument = argument
                let valueTypeArgument = arguments[i+1]
                
                let option : OptionType = getOption(optionTypeArgument)
                
                switch option {
                case .userName:
                    argumentDictionary["userName"] = valueTypeArgument
                case .projectName:
                    argumentDictionary["projectName"] = valueTypeArgument
                case .unknown:
                    ConsoleOut.writeMessage("The \"\(optionTypeArgument)\" argument is an unknown option", to: .error)
                    ConsoleOut.printUsage()
                    return nil
                }
            }
        }
        return argumentDictionary
    }
    
    class func getOption(_ argument:String) -> OptionType {
        return (OptionType(value: argument))
    }
}

