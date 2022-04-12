import Foundation

enum OptionType: String {
    case userName = "-u"
    case projectName = "-p"
    case copyRights = "-c"
    case moduleName = "-m"
    case localDataManager = "-ldm"
    case remoteDataManager = "-rdm"
    case cocoaFramework = "-cocoa"
    case unknown
    
    init(value: String) {
        switch value {
        case "-u": self = .userName
        case "-p": self = .projectName
        case "-c": self = .copyRights
        case "-m": self = .moduleName
        case "-ldm": self = .localDataManager
        case "-rdm": self = .remoteDataManager
        case "-cocoa": self = .cocoaFramework
        default: self = .unknown
        }
    }
}

class ArgumentHandler {
    private init(){}
    class func getArgumentDictionary(from arguments:[String]) -> Dictionary<String, String>? {
        let argumentsCount = arguments.count
        guard argumentsCount >= 7 else {
            ConsoleOut.printUsage()
            return nil
        }
        
        var argumentDictionary = Dictionary<String, String>()
        
        for i in 1..<argumentsCount {
            let argument = arguments[i]
            
            if (argument.first == "-") {
                let optionTypeArgument = argument
                var valueTypeArgument = ""
                
                let option : OptionType = getOption(optionTypeArgument)
                
                if(option != .localDataManager && option != .remoteDataManager) {
                    valueTypeArgument = arguments[i+1]
                }
                
                switch option {
                case .userName:
                    argumentDictionary["userName"] = valueTypeArgument
                case .projectName:
                    argumentDictionary["projectName"] = valueTypeArgument
                case .copyRights:
                    argumentDictionary["copyRights"] = valueTypeArgument
                case .moduleName:
                    argumentDictionary["moduleName"] = valueTypeArgument
                case .localDataManager:
                    argumentDictionary["localDataManager"] = valueTypeArgument
                case .remoteDataManager:
                    argumentDictionary["remoteDataManager"] = valueTypeArgument
                case .cocoaFramework:
                    argumentDictionary["cocoaFramework"] = valueTypeArgument
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
