import Foundation

class Generator {
    private init(){}
    class func generateModules(from argumentDictionary:Dictionary<String, String>) -> Bool {
        let userName = argumentDictionary["userName"]!
        let projectName = argumentDictionary["projectName"]!
        let copyRights = argumentDictionary["copyRights"]
        let moduleName = argumentDictionary["moduleName"]!
        let localDataManager = argumentDictionary["localDataManager"]
        let remoteDataManager = argumentDictionary["remoteDataManager"]
        let cocoaFramework = argumentDictionary["cocoaFramework"]
        
        var isSuccessGeneration = false
        
        var isLocalDataManagerNeeded = false
        var isRemoteDataManagerNeeded = false
        var isCocoaApi = false
        
        if let _ = localDataManager {
            isLocalDataManagerNeeded = true
        }
        if let _ = remoteDataManager {
            isRemoteDataManagerNeeded = true
        }
        if let _ = cocoaFramework {
            isCocoaApi = true
        }
        
        let isOneOfDataManagerNeeded = isLocalDataManagerNeeded || isRemoteDataManagerNeeded
        
        var uiFramework = "UIKit"
        var storyboardType = "UIStoryboard"
        var viewControllerType = "UIViewController"
        var instantiateUIControllerMethodName = "instantiateViewController"
        
        if (isCocoaApi) {
            uiFramework = "Cocoa"
            storyboardType = "NSStoryboard"
            viewControllerType = "NSViewController"
            viewControllerType = "NSViewController"
            instantiateUIControllerMethodName = "instantiateController"
        }
        
        ConsoleOut.writeMessage("isLocalDataManagerNeeded : \(isLocalDataManagerNeeded)", to: .standard)
        ConsoleOut.writeMessage("isRemoteDataManagerNeeded : \(isRemoteDataManagerNeeded)", to: .standard)
        
        let fileManager = FileManager.default
        
        let workDirUrl              = URL(fileURLWithPath: fileManager.currentDirectoryPath, isDirectory: true)
        
        let moduleDirUrl            = workDirUrl.appendingPathComponent(moduleName)
        let builderImpUrl           = moduleDirUrl.appendingPathComponent("Builder")
        let dataManagerImpUrl       = moduleDirUrl.appendingPathComponent("DataManager")
        let interactorImpUrl        = moduleDirUrl.appendingPathComponent("Interactor")
        let presenterImpUrl         = moduleDirUrl.appendingPathComponent("Presenter")
        let protocolsUrl            = moduleDirUrl.appendingPathComponent("Protocols")
        let routerImpUrl            = moduleDirUrl.appendingPathComponent("Router")
        let viewControllerImpUrl    = moduleDirUrl.appendingPathComponent("View")
        
        let protocolInteractorUrl           = protocolsUrl.appendingPathComponent(moduleName+"InteractorProtocol").appendingPathExtension("swift")
        let protocolLocalDataManagerUrl     = protocolsUrl.appendingPathComponent(moduleName+"LocalDataManagerProtocol").appendingPathExtension("swift")
        let protocolPresenterUrl            = protocolsUrl.appendingPathComponent(moduleName+"PresenterProtocol").appendingPathExtension("swift")
        let protocolRemoteDataManagerUrl    = protocolsUrl.appendingPathComponent(moduleName+"RemoteDataManagerProtocol").appendingPathExtension("swift")
        let protocolRouterUrl               = protocolsUrl.appendingPathComponent(moduleName+"RouterProtocol").appendingPathExtension("swift")
        let protocolViewControllerUrl       = protocolsUrl.appendingPathComponent(moduleName+"ViewControllerProtocol").appendingPathExtension("swift")
        
        let builderUrl              = builderImpUrl.appendingPathComponent(moduleName+"Builder").appendingPathExtension("swift")
        let localDataManagerUrl     = dataManagerImpUrl.appendingPathComponent(moduleName+"LocalDataManager").appendingPathExtension("swift")
        let remoteDataManagerUrl    = dataManagerImpUrl.appendingPathComponent(moduleName+"RemoteDataManager").appendingPathExtension("swift")
        let interactorUrl           = interactorImpUrl.appendingPathComponent(moduleName+"Interactor").appendingPathExtension("swift")
        let presenterUrl            = presenterImpUrl.appendingPathComponent(moduleName+"Presenter").appendingPathExtension("swift")
        let routerUrl               = routerImpUrl.appendingPathComponent(moduleName+"Router").appendingPathExtension("swift")
        let viewControllerUrl       = viewControllerImpUrl.appendingPathComponent(moduleName+"ViewController").appendingPathExtension("swift")
        
        func fileComment(for module: String, type: String) -> String {
            let today       = Date()
            let calendar    = Calendar(identifier: .gregorian)
            let year        = String(calendar.component(.year, from: today))
            let month       = String(format: "%02d", calendar.component(.month, from: today))
            let day         = String(format: "%02d", calendar.component(.day, from: today))
            
            return """
            //
            //  \(module)\(type).swift
            //  \(projectName)
            //
            //  Created by \(userName) on \(day)/\(month)/\(year).
            //  Copyright © \(year) \(copyRights ?? userName). All rights reserved.
            //
            """
        }
        
        // MARK: interfaceInteractor
        var interfaceInteractor = """
        \(fileComment(for: moduleName, type: "InteractorProtocol"))
        
        import Foundation
        
        protocol \(moduleName)InteractorProtocol {
        \tvar presenter: \(moduleName)PresenterProtocol? { get set }
        
        """
        if (isLocalDataManagerNeeded) {
            interfaceInteractor.append("""
                \tvar localDataManager: \(moduleName)LocalDataManagerProtocol? { get set }
                \t
                """)
        }
        if (isRemoteDataManagerNeeded) {
            interfaceInteractor.append("""
                \tvar remoteDataManager: \(moduleName)RemoteDataManagerProtocol? { get set }
                \t
                """)
        }
        interfaceInteractor.append("""
        }
        """)
        
        
        // MARK: interfaceLocalDataManager
        let interfaceLocalDataManager = """
        \(fileComment(for: moduleName, type: "LocalDataManagerProtocol"))
        
        import Foundation
        
        protocol \(moduleName)LocalDataManagerProtocol: class {
        }
        """
        
        // MARK: interfaceRemoteDataManager
        let interfaceRemoteDataManager = """
        \(fileComment(for: moduleName, type: "RemoteDataManagerProtocol"))
        
        import Foundation
        
        protocol \(moduleName)RemoteDataManagerProtocol: class {
        }
        """
        
        // MARK: interfacePresenter
        let interfacePresenter = """
        \(fileComment(for: moduleName, type: "PresenterProtocol"))
        
        import Foundation
        
        protocol \(moduleName)PresenterProtocol: class {
        \tvar router: \(moduleName)RouterProtocol? { get set }
        \tvar interactor: \(moduleName)InteractorProtocol? { get set }
        \tvar view: \(moduleName)ViewControllerProtocol? { get set }
        }
        """
        
        // MARK: interfaceRouter
        let interfaceRouter = """
        \(fileComment(for: moduleName, type: "RouterProtocol"))
        
        import Foundation
        
        protocol \(moduleName)RouterProtocol {
        \tvar presenter: \(moduleName)PresenterProtocol? { get set }
        }
        """
        
        // MARK: interfaceViewController
        let interfaceViewController = """
        \(fileComment(for: moduleName, type: "ViewControllerProtocol"))
        
        import Foundation
        
        protocol \(moduleName)ViewControllerProtocol: class {
        \tvar presenter: \(moduleName)PresenterProtocol? { get set }
        }
        """
        
        // MARK: defaultBuilder
        var defaultBuilder = """
        \(fileComment(for: moduleName, type: "Builder"))
        
        import Foundation
        import \(uiFramework)
        
        class \(moduleName)Builder {
        \tclass func create\(moduleName)Module() -> \(viewControllerType) {
        \t\tlet refTo\(moduleName)View = storyboard.\(instantiateUIControllerMethodName)(withIdentifier: "\(moduleName)ViewController") as? \(moduleName)ViewController
        \t\t
        \t\tlet presenter: \(moduleName)PresenterProtocol = \(moduleName)Presenter()
        \t\tlet router: \(moduleName)RouterProtocol = \(moduleName)Router()
        \t\tlet interactor: \(moduleName)InteractorProtocol = \(moduleName)Interactor()
        """
        if (isLocalDataManagerNeeded) {
            defaultBuilder.append("""
                \t\t
                \t\tlet localDataManager: \(moduleName)LocalDataManagerProtocol = \(moduleName)LocalDataManager()
                \t
                """)
        }
        if (isRemoteDataManagerNeeded) {
            defaultBuilder.append("""
                \t\t
                \t\tlet remoteDataManager: \(moduleName)RemoteDataManagerProtocol = \(moduleName)RemoteDataManager()
                \t
                """)
        }
        defaultBuilder.append("""
            \t\t
            \t\trefTo\(moduleName)View?.presenter = presenter
            \t\tpresenter.view = refTo\(moduleName)View
            \t\tpresenter.view?.presenter = presenter
            \t\tpresenter.router = router
            \t\tpresenter.router?.presenter = presenter
            \t\tpresenter.interactor = interactor
            """)
        if (isLocalDataManagerNeeded) {
            defaultBuilder.append("""
                \t\t
                \t\tpresenter.interactor?.localDataManager = localDataManager
                """)
        }
        if (isRemoteDataManagerNeeded) {
            defaultBuilder.append("""
                \t\t
                \t\tpresenter.interactor?.remoteDataManager = remoteDataManager
                """)
        }
        defaultBuilder.append("""
            \t\t
            \t\tpresenter.interactor?.presenter = presenter
            \t\t
            \t\treturn refTo\(moduleName)View!
            \t}
            \t
            \tstatic var storyboard: \(storyboardType) {
            \t\treturn \(storyboardType)(name:"Main",bundle: Bundle.main)
            \t}
            }
            """)
        
        // MARK: defaultInteractor
        var defaultInteractor = """
            \(fileComment(for: moduleName, type: "Interactor"))
            
            import Foundation
            
            class \(moduleName)Interactor: \(moduleName)InteractorProtocol {
            \tweak var presenter: \(moduleName)PresenterProtocol?
            """
        if (isLocalDataManagerNeeded) {
            defaultInteractor.append("""
                    \t
                    \tvar localDataManager: \(moduleName)LocalDataManagerProtocol?
                    """)
        }
        if (isRemoteDataManagerNeeded) {
            defaultInteractor.append("""
                    \t
                    \tvar remoteDataManager: \(moduleName)RemoteDataManagerProtocol?
                    """)
        }
        defaultInteractor.append("""
            \t
            }
            """)
        
        // MARK: defaultLocalDataManager
        let defaultLocalDataManager = """
        \(fileComment(for: moduleName, type: "LocalDataManager"))
        
        import Foundation
        
        class \(moduleName)LocalDataManager: \(moduleName)LocalDataManagerProtocol {
        \t
        }
        """
        
        // MARK: defaultRemoteDataManager
        let defaultRemoteDataManager = """
        \(fileComment(for: moduleName, type: "RemoteDataManager"))
        
        import Foundation
        
        class \(moduleName)RemoteDataManager: \(moduleName)RemoteDataManagerProtocol {
        \t
        }
        """
        
        // MARK: defaultPresenter
        let defaultPresenter = """
        \(fileComment(for: moduleName, type: "Presenter"))
        
        import Foundation
        
        class \(moduleName)Presenter: \(moduleName)PresenterProtocol {
        \tvar router: \(moduleName)RouterProtocol?
        \tvar interactor: \(moduleName)InteractorProtocol?
        \tweak var view: \(moduleName)ViewControllerProtocol?
        \t
        }
        """
        
        // MARK: defaultRouter
        let defaultRouter = """
        \(fileComment(for: moduleName, type: "Router"))
        
        import Foundation
        import \(uiFramework)
        
        class \(moduleName)Router: \(moduleName)RouterProtocol {
        \tweak var presenter: \(moduleName)PresenterProtocol?
        \t
        }
        """
        
        // MARK: defaultViewController
        let defaultViewController = """
        \(fileComment(for: moduleName, type: "ViewController"))
        
        import Foundation
        import \(uiFramework)
        
        class \(moduleName)ViewController: \(viewControllerType), \(moduleName)ViewControllerProtocol {
        \tvar presenter: \(moduleName)PresenterProtocol?
        \t
        }
        """
        
        // MARK: file write
        do {
            var directoryPathUrlArray = [URL]()
            directoryPathUrlArray.append(moduleDirUrl)
            directoryPathUrlArray.append(builderImpUrl)
            if (isOneOfDataManagerNeeded) {
                directoryPathUrlArray.append(dataManagerImpUrl)
            }
            directoryPathUrlArray.append(interactorImpUrl)
            directoryPathUrlArray.append(presenterImpUrl)
            directoryPathUrlArray.append(protocolsUrl)
            directoryPathUrlArray.append(routerImpUrl)
            directoryPathUrlArray.append(viewControllerImpUrl)
            
            try directoryPathUrlArray.forEach {
                try fileManager.createDirectory(at: $0, withIntermediateDirectories: true, attributes: nil)
            }
            try interfaceInteractor.write(to: protocolInteractorUrl, atomically: true, encoding: .utf8)
            if (isLocalDataManagerNeeded) {
                try interfaceLocalDataManager.write(to: protocolLocalDataManagerUrl, atomically: true, encoding: .utf8)
            }
            try interfacePresenter.write(to: protocolPresenterUrl, atomically: true, encoding: .utf8)
            if (isRemoteDataManagerNeeded) {
                try interfaceRemoteDataManager.write(to: protocolRemoteDataManagerUrl, atomically: true, encoding: .utf8)
            }
            try interfaceRouter.write(to: protocolRouterUrl, atomically: true, encoding: .utf8)
            try interfaceViewController.write(to: protocolViewControllerUrl, atomically: true, encoding: .utf8)
            
            try defaultBuilder.write(to: builderUrl, atomically: true, encoding: .utf8)
            if (isLocalDataManagerNeeded) {
                try defaultLocalDataManager.write(to: localDataManagerUrl, atomically: true, encoding: .utf8)
            }
            if (isRemoteDataManagerNeeded) {
                try defaultRemoteDataManager.write(to: remoteDataManagerUrl, atomically: true, encoding: .utf8)
            }
            try defaultBuilder.write(to: builderUrl, atomically: true, encoding: .utf8)
            try defaultInteractor.write(to: interactorUrl, atomically: true, encoding: .utf8)
            try defaultPresenter.write(to: presenterUrl, atomically: true, encoding: .utf8)
            try defaultRouter.write(to: routerUrl, atomically: true, encoding: .utf8)
            try defaultViewController.write(to: viewControllerUrl, atomically: true, encoding: .utf8)
            
            ConsoleOut.writeMessage("Files generated to: \(workDirUrl)", to: .standard)
            isSuccessGeneration = true
        }
        catch {
            ConsoleOut.writeMessage(error.localizedDescription, to: .error)
        }
        
        return isSuccessGeneration
    }
}
