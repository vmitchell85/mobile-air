package com.nativephp.mobile.bridge.functions

import android.util.Log
import com.nativephp.mobile.bridge.BridgeFunction
import com.nativephp.mobile.ui.NativeUIState
import kotlinx.coroutines.launch

private const val TAG = "EdgeFunctions"

/**
 * Functions related to Edge UI management
 * Namespace: "Edge.*"
 */
object EdgeFunctions {

    /**
     * Update the native UI state with Edge components
     * Parameters:
     *   - components: array - Array of Edge components
     *
     * Usage Example:
     *   nativephp_call('Edge.Set', json_encode([
     *     'components' => [
     *       ['type' => 'bottom_nav', 'data' => [...]]
     *     ]
     *   ]));
     */
    class Set : BridgeFunction {
        override fun execute(parameters: Map<String, Any>): Map<String, Any> {
            // Extract components from parameters
            val components = parameters["components"]

            if (components == null) {
                Log.e(TAG, "❌ No components provided in parameters")
                return mapOf("error" to "No components provided")
            }

            Log.d(TAG, "🎨 Edge.Set called")

            try {
                // Pass the components object directly to NativeUIState
                // It will handle the type conversion internally
                NativeUIState.updateFromJson(components)

                return mapOf("success" to true)
            } catch (e: Exception) {
                Log.e(TAG, "❌ Error updating UI state: ${e.message}", e)
                return mapOf("error" to "Failed to update UI state: ${e.message}")
            }
        }
    }

    /**
     * Programmatically open the side navigation drawer
     *
     * Usage Example:
     *   nativephp_call('Navigation.OpenSidebar', '{}');
     */
    class OpenSidebar : BridgeFunction {
        override fun execute(parameters: Map<String, Any>): Map<String, Any> {
            Log.d(TAG, "🎨 Navigation.OpenSidebar called")

            // Check if side nav data exists
            if (!NativeUIState.hasSideNav()) {
                Log.w(TAG, "⚠️ Navigation.OpenSidebar: No side nav data available")
                return mapOf("success" to false, "error" to "No side nav data available")
            }

            val scope = NativeUIState.drawerScope
            val state = NativeUIState.drawerState

            if (scope == null || state == null) {
                Log.e(TAG, "❌ Navigation.OpenSidebar: Drawer state not initialized (scope=$scope, state=$state)")
                return mapOf("success" to false, "error" to "Drawer state not initialized")
            }

            scope.launch {
                state.open()
                Log.d(TAG, "✅ Navigation.OpenSidebar: Sidebar opened")
            }

            return mapOf("success" to true)
        }
    }

    /**
     * Programmatically close the side navigation drawer
     *
     * Usage Example:
     *   nativephp_call('Navigation.CloseSidebar', '{}');
     */
    class CloseSidebar : BridgeFunction {
        override fun execute(parameters: Map<String, Any>): Map<String, Any> {
            Log.d(TAG, "🎨 Navigation.CloseSidebar called")

            val scope = NativeUIState.drawerScope
            val state = NativeUIState.drawerState

            if (scope == null || state == null) {
                Log.e(TAG, "❌ Navigation.CloseSidebar: Drawer state not initialized (scope=$scope, state=$state)")
                return mapOf("success" to false, "error" to "Drawer state not initialized")
            }

            scope.launch {
                state.close()
                Log.d(TAG, "✅ Navigation.CloseSidebar: Sidebar closed")
            }

            return mapOf("success" to true)
        }
    }

    /**
     * Toggle the side navigation drawer open/closed state
     *
     * Usage Example:
     *   nativephp_call('Navigation.ToggleSidebar', '{}');
     */
    class ToggleSidebar : BridgeFunction {
        override fun execute(parameters: Map<String, Any>): Map<String, Any> {
            Log.d(TAG, "🎨 Navigation.ToggleSidebar called")

            // Check if side nav data exists
            if (!NativeUIState.hasSideNav()) {
                Log.w(TAG, "⚠️ Navigation.ToggleSidebar: No side nav data available")
                return mapOf("success" to false, "error" to "No side nav data available")
            }

            val scope = NativeUIState.drawerScope
            val state = NativeUIState.drawerState

            if (scope == null || state == null) {
                Log.e(TAG, "❌ Navigation.ToggleSidebar: Drawer state not initialized (scope=$scope, state=$state)")
                return mapOf("success" to false, "error" to "Drawer state not initialized")
            }

            scope.launch {
                if (state.isOpen) {
                    state.close()
                    Log.d(TAG, "✅ Navigation.ToggleSidebar: Sidebar closed")
                } else {
                    state.open()
                    Log.d(TAG, "✅ Navigation.ToggleSidebar: Sidebar opened")
                }
            }

            return mapOf("success" to true)
        }
    }
}