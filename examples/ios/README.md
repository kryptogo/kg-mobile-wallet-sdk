# KG_SDK for iOS

## Table of Contents
- [KG\_SDK for iOS](#kg_sdk-for-ios)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Setup](#setup)
  - [Implementation](#implementation)
    - [Creating KgSDKService](#creating-kgsdkservice)
    - [Initializing KG\_SDK in SwiftUI](#initializing-kg_sdk-in-swiftui)
    - [Opening KG\_SDK Screen](#opening-kg_sdk-screen)
    - [Using KG\_SDK Functions](#using-kg_sdk-functions)
  - [Required Implementations](#required-implementations)
  - [Configuration](#configuration)

## Introduction

KG_SDK is a powerful SDK for integrating blockchain and wallet management capabilities into your iOS application. This README provides instructions on how to implement and use KG_SDK in your Swift project.

## Setup

To use KG_SDK, you need to set up Flutter in your iOS project. Follow these steps:

1. Add Flutter to your project as described in the Flutter documentation.
2. Ensure you have the necessary Flutter dependencies in your Podfile.

## Implementation

### Creating KgSDKService

Create a `KgSDKService` class to manage the interaction with the KG_SDK. Here's an example of how to structure this class:

```swift
import Flutter
import SwiftUI

class KgSDKService: ObservableObject {
    static let shared = KgSDKService()
    
    private let flutterEngine: FlutterEngine
    private let methodChannel: FlutterMethodChannel
    private var flutterViewController: FlutterViewController?
    
    private init() {
        flutterEngine = FlutterEngine(name: "kg_sdk_engine")
        flutterEngine.run()
        
        let messenger = flutterEngine.binaryMessenger
        methodChannel = FlutterMethodChannel(name: "com.kryptogo.sdk/channel", binaryMessenger: messenger)
        
        setupMethodChannel()
        
        flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        flutterViewController?.modalPresentationStyle = .fullScreen
        flutterViewController?.isViewOpaque = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.setInitParams()
        }
    }
    
    private func setupMethodChannel() {
        // Implement method channel setup here
    }
    
    private func setInitParams() {
        // Set initial parameters for KG_SDK
    }
    
    // Implement other necessary methods here
}
```

### Initializing KG_SDK in SwiftUI

In your main SwiftUI app file, initialize the KgSDKService:

```swift
import SwiftUI

@main
struct YourApp: App {
    @StateObject var kgSDKService = KgSDKService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(kgSDKService)
        }
    }
}
```

### Opening KG_SDK Screen

To open the KG_SDK screen, implement a method in your KgSDKService:

```swift
func showKgSDK(from viewController: UIViewController) {
    guard let flutterViewController = flutterViewController else {
        print("Error: FlutterViewController is not initialized")
        return
    }
    
    DispatchQueue.main.async {
        viewController.present(flutterViewController, animated: true, completion: nil)
    }
}
```

Use it in your SwiftUI view:

```swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var kgSDKService: KgSDKService

    var body: some View {
        Button("Open Wallet") {
            if let window = UIApplication.shared.windows.first,
               let rootViewController = window.rootViewController {
                kgSDKService.showKgSDK(from: rootViewController)
            }
        }
    }
}
```

### Using KG_SDK Functions

Implement methods in KgSDKService to interact with KG_SDK:

```swift
func getBalance(completion: @escaping (Any?) -> Void) {
    methodChannel.invokeMethod("getBalance", arguments: nil, result: completion)
}

func isReady(completion: @escaping (Any?) -> Void) {
    methodChannel.invokeMethod("isReady", arguments: nil, result: completion)
}

func goRoute(route: String) {
    methodChannel.invokeMethod("goRoute", arguments: route, result: nil)
}

func kDebugMode() async throws -> Bool {
    return try await withCheckedThrowingContinuation { continuation in
        methodChannel.invokeMethod("kDebugMode", arguments: nil) { result in
            continuation.resume(returning: result as? Bool ?? false)
        }
    }
}

func isWalletCreated() async throws -> Bool {
    return try await withCheckedThrowingContinuation { continuation in
        methodChannel.invokeMethod("isWalletCreated", arguments: nil) { result in
            continuation.resume(returning: result as? Bool ?? false)
        }
    }
}
```

## Required Implementations

You need to implement the following functions in your KgSDKService:

1. `updateSharedSecret(sharedSecret: String?) -> Bool`
   - Update the shared secret in your secure storage.
   
2. `fetchSharedSecret() -> String?`
   - Retrieve the shared secret from your secure storage.

Example implementation:

```swift
func updateSharedSecret(sharedSecret: String?) -> Bool {
    // Implement secure storage of sharedSecret
    // Return true if successful, false otherwise
}

func fetchSharedSecret() -> String? {
    // Implement secure retrieval of sharedSecret
    // Return the stored sharedSecret or nil if not found
}
```

## Configuration

Before using KG_SDK, update the following parameters in the `setInitParams` method of KgSDKService:

```swift
private func setInitParams() {
    methodChannel.invokeMethod("initParams", arguments: [
        "clientToken": "YOUR_CLIENT_TOKEN",
        "clientId": "YOUR_CLIENT_ID"
    ])
}
```

Replace `YOUR_CLIENT_TOKEN` and `YOUR_CLIENT_ID` with the values provided by KryptoGO Studio.

For more detailed information on getting started with KG_SDK, please refer to the [official documentation](https://dora-xies-organization.gitbook.io/kg_sdk-doc/kg_sdk/get-started).****