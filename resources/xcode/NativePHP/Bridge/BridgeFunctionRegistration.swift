import Foundation

/// Register all bridge functions with the registry
/// Call this once during app initialization
func registerBridgeFunctions() {
    let registry = BridgeFunctionRegistry.shared

    registry.register("Edge.Set", function: EdgeFunctions.Set())

    // Navigation functions
    registry.register("Navigation.OpenSidebar", function: EdgeFunctions.OpenSidebar())
    registry.register("Navigation.CloseSidebar", function: EdgeFunctions.CloseSidebar())
    registry.register("Navigation.ToggleSidebar", function: EdgeFunctions.ToggleSidebar())

    // Register plugin bridge functions
    registerPluginBridgeFunctions()
}
