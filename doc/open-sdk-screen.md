# Open SDK Screen

Import the `KgSDKService.swift` file to begin implementation.

## KgSDKService Initialization

```swift
import SwiftUI
// The following library connects plugins with iOS platform code to this app.
import Flutter
import FlutterPluginRegistrant

@main
struct testApp: App {
    @StateObject var kgSDKService = KgSDKService.shared
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(kgSDKService)
        }
    }
}
```

## ContentView — Open Wallet

```swift
import SwiftUI
import Flutter

struct ContentView: View {
    @EnvironmentObject var kgSDKService: KgSDKService

    var body: some View {
        Button("Open Wallet!") {
            showKgSDK()
        }
    }

    private func showKgSDK() {
        if let window = UIApplication.shared.windows.first,
           let rootViewController = window.rootViewController {
            kgSDKService.showKgSDK(from: rootViewController)
        }
    }
}
```

## Calling SDK Functions

Example: `getBalance` retrieves the current balance of the user's wallet.

```swift
private func callKgSDK() {
    kgSDKService.callKgSDK(funcName: "getBalance", completion: { result in
        print(result ?? "no-balance")
    })
}
```
