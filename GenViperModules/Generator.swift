import Foundation

class Generator {
    private init(){}
    
    class func generateModules(from argumentDictionary:Dictionary<String, String>) -> Bool {
        let userName = argumentDictionary["userName"]!
        let projectName = argumentDictionary["projectName"]!
        let moduleName = "TestModule"
        
        var isSuccess       = false
        
        let workDirUrl      = URL(fileURLWithPath: FileManager.default.currentDirectoryPath, isDirectory: true)
        
        let moduleDirUrl    = workDirUrl.appendingPathComponent(moduleName)
        let testFileDirUrl  = moduleDirUrl.appendingPathComponent("TestFolder")
        
        let testFileUrl     = testFileDirUrl.appendingPathComponent(moduleName+"TestFile").appendingPathExtension("swift")
        
        func makeFileContent(for module: String) -> String {
            return """
            //
            //  \(module)TestFile.swift
            //  \(projectName)
            //
            //  Created by \(userName)
            """
        }
        
        let testFileContent = makeFileContent(for: moduleName)
        
        // MARK: create directories and write files
        do {
            var directoryPathUrlArray = [URL]()
            directoryPathUrlArray.append(moduleDirUrl)
            directoryPathUrlArray.append(testFileDirUrl)
            
            try directoryPathUrlArray.forEach {
                try FileManager.default.createDirectory(at: $0, withIntermediateDirectories: true, attributes: nil)
            }
            
            try testFileContent.write(to: testFileUrl, atomically: true, encoding: .utf8)
            
            
            ConsoleOut.writeMessage("Files generated to: \(workDirUrl)", to: .standard)
            isSuccess = true
        }
        catch {
            ConsoleOut.writeMessage(error.localizedDescription, to: .error)
        }
        
        return isSuccess
    }
}
