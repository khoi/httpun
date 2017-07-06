@_exported import Vapor
import LeafProvider

extension Droplet {
    public func setup() throws {
        try setupRoutes()
    }

    
}

extension Config {
    public func setup() throws {
        addConfigurable(middleware: HeaderMiddleware(), name: "pun_header_middleware")
        try addProvider(LeafProvider.Provider.self)
    }
}
