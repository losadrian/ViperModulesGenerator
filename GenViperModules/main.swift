import Foundation

ConsoleOut.writeMessage("Commandline arguments: \(CommandLine.arguments)")

guard CommandLine.arguments.count > 1 else {
    ConsoleOut.printUsage()
    exit(-1)
}

let argumentDictionary = ArgumentHandler.getArgumentDictionary(from: CommandLine.arguments)


guard let arguments = argumentDictionary else {
    exit(-1)
}

let isSuccessGeneration = Generator.generateModules(from: arguments)

if isSuccessGeneration {
    exit(0)
}
else {
    exit(-1)
}
