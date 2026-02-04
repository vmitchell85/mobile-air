import Foundation
import SwiftUI

// MARK: - Edge Function Namespace

/// Functions related to Edge UI management
/// Namespace: "Edge.*"
enum EdgeFunctions {

    // MARK: - Edge.Set

    /// Update the native UI state with Edge components
    /// Parameters:
    ///   - components: array - Array of Edge components
    ///
    /// Usage Example:
    ///   nativephp_call('Edge.Set', json_encode([
    ///     'components' => [
    ///       ['type' => 'bottom_nav', 'data' => [...]]
    ///     ]
    ///   ]));
    class Set: BridgeFunction {
        func execute(parameters: [String: Any]) throws -> [String: Any] {
            // Extract components array from parameters
            guard let components = parameters["components"] as? [[String: Any]] else {
                print("❌ Edge.Set: No components array provided")
                return ["error": "No components array provided"]
            }

            print("🎨 Edge.Set called with \(components.count) component(s)")
            print("🎨 Edge.Set components: \(components)")

            // Convert components back to JSON string for NativeUIState
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: components, options: [])
                guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                    print("❌ Edge.Set: Failed to convert components to JSON string")
                    return ["error": "Failed to convert components to JSON string"]
                }

                // Update NativeUIState on main thread synchronously
                // Use sync to ensure the UI state is updated before PHP response completes
                // This prevents a race condition where the WebView receives the response
                // before the EDGE components are registered in NativeUIState
                if Thread.isMainThread {
                    NativeUIState.shared.updateFromJson(jsonString)
                } else {
                    DispatchQueue.main.sync {
                        NativeUIState.shared.updateFromJson(jsonString)
                    }
                }

                return ["success": true]
            } catch {
                print("❌ Edge.Set: JSON serialization error: \(error)")
                return ["error": "JSON serialization failed: \(error.localizedDescription)"]
            }
        }
    }

    // MARK: - Navigation.OpenSidebar

    /// Programmatically open the side navigation drawer
    ///
    /// Usage Example:
    ///   nativephp_call('Navigation.OpenSidebar', '{}');
    class OpenSidebar: BridgeFunction {
        func execute(parameters: [String: Any]) throws -> [String: Any] {
            print("🎨 Navigation.OpenSidebar called")

            // Check if side nav exists
            guard NativeUIState.shared.hasSideNav() else {
                print("⚠️ Navigation.OpenSidebar: No side nav data available")
                return ["success": false, "error": "No side nav data available"]
            }

            if Thread.isMainThread {
                withAnimation(.easeInOut(duration: 0.3)) {
                    NativeUIState.shared.openSidebar()
                }
            } else {
                DispatchQueue.main.sync {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        NativeUIState.shared.openSidebar()
                    }
                }
            }

            print("✅ Navigation.OpenSidebar: Sidebar opened")
            return ["success": true]
        }
    }

    // MARK: - Navigation.CloseSidebar

    /// Programmatically close the side navigation drawer
    ///
    /// Usage Example:
    ///   nativephp_call('Navigation.CloseSidebar', '{}');
    class CloseSidebar: BridgeFunction {
        func execute(parameters: [String: Any]) throws -> [String: Any] {
            print("🎨 Navigation.CloseSidebar called")

            if Thread.isMainThread {
                withAnimation(.easeInOut(duration: 0.3)) {
                    NativeUIState.shared.closeSidebar()
                }
            } else {
                DispatchQueue.main.sync {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        NativeUIState.shared.closeSidebar()
                    }
                }
            }

            print("✅ Navigation.CloseSidebar: Sidebar closed")
            return ["success": true]
        }
    }

    // MARK: - Navigation.ToggleSidebar

    /// Toggle the side navigation drawer open/closed state
    ///
    /// Usage Example:
    ///   nativephp_call('Navigation.ToggleSidebar', '{}');
    class ToggleSidebar: BridgeFunction {
        func execute(parameters: [String: Any]) throws -> [String: Any] {
            print("🎨 Navigation.ToggleSidebar called")

            // Check if side nav exists
            guard NativeUIState.shared.hasSideNav() else {
                print("⚠️ Navigation.ToggleSidebar: No side nav data available")
                return ["success": false, "error": "No side nav data available"]
            }

            let willOpen = !NativeUIState.shared.shouldPresentSidebar

            if Thread.isMainThread {
                withAnimation(.easeInOut(duration: 0.3)) {
                    NativeUIState.shared.shouldPresentSidebar.toggle()
                }
            } else {
                DispatchQueue.main.sync {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        NativeUIState.shared.shouldPresentSidebar.toggle()
                    }
                }
            }

            print("✅ Navigation.ToggleSidebar: Sidebar \(willOpen ? "opened" : "closed")")
            return ["success": true]
        }
    }
}