# Swift Example
# Open SDK screen
Before using KG_SDK, you need to import the ~[KgSDKService.swift](https://dora-xies-organization.gitbook.io/kg_sdk-doc/kg_sdk/open-sdk-screen/kgsdkservice.swift)~ file into your iOS application. This file will help you quickly start and effectively integrate KG_SDK.
# [](https://dora-xies-organization.gitbook.io/kg_sdk-doc/kg_sdk/open-sdk-screen#init-kg_sdk-service)Init KG_SDK Service
To get started with KG_SDK in your iOS application, you need to set up the initial service in your SwiftUI environment. Below is the code snippet for initializing the KgSDKService within the main entry point of your SwiftUI application:
Copy
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

This setup involves importing necessary Flutter dependencies and registering KgSDKService as an environment object to make it available throughout your app.
# [](https://dora-xies-organization.gitbook.io/kg_sdk-doc/kg_sdk/open-sdk-screen#open-kg_sdk-screen)Open KG_SDK Screen
To interact with the KG_SDK, you’ll need to provide a user interface component that triggers SDK functions. Here’s how to create a simple button within ContentView to open the wallet:
Copy
import SwiftUI import Flutter

struct ContentView: View {
EnvironmentObject. @EnvironmentObject var
flutterDependencies: FlutterDependencies


var body: some View { Button(“Open Wallet!”) { showKgSDK() } }

private func showKgSDK() {
    if let window = UIApplication.shared.windows.first, let rootViewController = window.rootViewController {
        kgSDKService.showKgSDK(from: rootViewController)
    }
}
This code snippet adds a button that, when pressed, calls the showKgSDK function to display the KG_SDK interface from the main application window.
# [](https://dora-xies-organization.gitbook.io/kg_sdk-doc/kg_sdk/open-sdk-screen#supported-functions-in-kg_sdk)Supported Functions in KG_SDK
KG_SDK offers a variety of functions that can be called using the funcName parameter within your app. These functions enable you to perform different operations related to blockchain and wallet management. Here is a list of some commonly used functions and their purposes:
* **getBalance**: Retrieves the current balance of the user's wallet. This function is ideal for quickly checking how much funds are available in the wallet.

⠀Copy
private func callKgSDK() {
    kgSDKService.callKgSDK(funcName: "getBalance", completion: { result in
        print(result ?? "no-balance")
    })
}

# KgSDKService.swift
KgSDKService.swift
# [](https://dora-xies-organization.gitbook.io/kg_sdk-doc/kg_sdk/open-sdk-screen/kgsdkservice.swift#function-should-be-implement)Function should be Implement


| name | desc | return type |
|---|---|---|
| updateSharedSecret | updateSharedSecret to your storage | Copy<br>(sharedSecret: String?) -> Bool |
| fetchSharedSecret | get sharedSecret to from your storage | Copy<br>() -> String? |
# [](https://dora-xies-organization.gitbook.io/kg_sdk-doc/kg_sdk/open-sdk-screen/kgsdkservice.swift#parameter-should-be-update)Parameter should be update
### you can see all params at ~[Get Started](https://dora-xies-organization.gitbook.io/kg_sdk-doc/kg_sdk/get-started)~
| name | desc |
|---|---|
| clientId | clientId from KryptoGO Studio |
| clientToken | clientToken from your own service |

```swift

import Flutter
import FlutterPluginRegistrant


class KgSDKService : ObservableObject{
    static let shared = KgSDKService()
    private var flutterEngine: FlutterEngine?
    private var flutterViewController: FlutterViewController?
    private var methodChannel: FlutterMethodChannel?
    private var openVerifyPageCallback: ((_ result: @escaping FlutterResult) -> Void)?
    
    
    private init (flutterViewController: FlutterViewController? = nil, methodChannel: FlutterMethodChannel? = nil, openVerifyPageCallback: ( (_: FlutterResult) -> Void)? = nil) {
        self.flutterViewController = flutterViewController
        self.methodChannel = methodChannel
        self.openVerifyPageCallback = openVerifyPageCallback
        self.flutterEngine = FlutterEngine(name: "flutter_engine")
        flutterEngine?.run()
        GeneratedPluginRegistrant.register(with: self.flutterEngine!)
    }
    
    
    private func initializeFlutterViewController(flutterEngine: FlutterEngine) {
        flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        guard let flutterVC = flutterViewController else { return }
        methodChannel = FlutterMethodChannel(name: "com.kryptogo.sdk/channel", binaryMessenger: flutterVC.binaryMessenger)
        setUpMethodChannel()
    }
    
    private func setUpMethodChannel() {
        let sharedSecret = fetchSharedSecret()
        // Send initial parameter to Flutter.
        var initParam: [String: Any] = [
            "appName": "TWMTEST",
            "walletConfig": [
                "maxWallet": 100,
                "enableAutoSssSignUp": true,
                "enableSSS":true,
                "allRpcs": ["ethereum"]
            ],
            "themeData": [
                "primaryValue": "FFFFC211"
            ],
            "flavorEnum": "dev",
            "clientId": "$YOUR_CLIENT_ID",
            "clientToken": "$YOUR_CLIENTTOKEN"
        ]
        if sharedSecret != nil {
            initParam["sharedSecret"] = sharedSecret
        }
        
        methodChannel?.invokeMethod("getInitialParam", arguments: initParam)
        
        // Set method call handler for future Flutter-to-native calls.
        methodChannel?.setMethodCallHandler { [self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "closeFlutterView":
                flutterViewController!.dismiss(animated: true, completion: nil)
            case "openVerifyPage":
                self.openVerifyPageCallback?(result)
            case "updateSharedSecret":
                print(call.arguments)
                let sharedSecret = (call.arguments as? [String: String])?["sharedSecret"]
                let isSuccess = self.updateSharedSecret(sharedSecret: sharedSecret)
                result(isSuccess)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    // To be implemented: update to server
    func updateSharedSecret(sharedSecret: String?) -> Bool {
        guard let secret = sharedSecret else {
            return false
        }
        UserDefaults.standard.set(secret, forKey: "sharedSecret")
        return true
    }
    
    
    // To be implemented: fetch from server
    func fetchSharedSecret() -> String? {
        return UserDefaults.standard.string(forKey: "sharedSecret")
    }
    
    
    func showKgSDK(from rootViewController: UIViewController) {
        // check flutterViewController is initialized
        if flutterViewController == nil {
            initializeFlutterViewController(flutterEngine:flutterEngine!)
        }
        
        
        flutterViewController?.modalPresentationStyle = .overCurrentContext
        flutterViewController?.isViewOpaque = false
        rootViewController.present(flutterViewController ?? createFlutterViewController(), animated: true)
    }
    
    private func createFlutterViewController() -> FlutterViewController{
        return FlutterViewController(engine: flutterEngine!, nibName: nil, bundle: nil)
    }
    
    
    func callKgSDK(funcName: String, completion: @escaping (Any?) -> Void) {
        // Create the FlutterViewController.
        let flutterViewController = FlutterViewController(
            engine: flutterEngine!,
            nibName: nil,
            bundle: nil)
        
        let channel = FlutterMethodChannel(name: "com.kryptogo.sdk/channel", binaryMessenger: flutterViewController.binaryMessenger)
        channel.invokeMethod(funcName, arguments: nil,result: { (result) in
            print(result ?? "no-data")
            completion(result)
            
        })
    }
    
}



```
```