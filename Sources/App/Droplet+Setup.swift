@_exported import Vapor
import LeafProvider

extension Droplet {
    public func setup() throws {
        try setupRoutes()
    }
}

extension Config {
    public func setup() throws {
        try addProvider(LeafProvider.Provider.self)
    }
}
