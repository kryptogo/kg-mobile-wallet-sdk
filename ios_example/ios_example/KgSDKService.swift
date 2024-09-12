import Flutter
import SwiftUI
import FlutterPluginRegistrant

class KgSDKService: ObservableObject {
    static let shared = KgSDKService()
    
    private let flutterEngine: FlutterEngine
    private let methodChannel: FlutterMethodChannel
    private var flutterViewController: FlutterViewController?
    private let channelName = "com.kryptogo.sdk/channel"
    private let engineName = "flutter_engine"
    
    private init() {
        flutterEngine = FlutterEngine(name: engineName)
        flutterEngine.run()
        
        let messenger = flutterEngine.binaryMessenger
        methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        
        GeneratedPluginRegistrant.register(with: flutterEngine)
        setupMethodChannel()
        
        // 創建單個 FlutterViewController 實例
        flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        flutterViewController?.modalPresentationStyle = .automatic
        flutterViewController?.isViewOpaque = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) { [weak self] in
            self?.setInitParams(clientToken: Constants.KgSDK.clientToken)
        }
    }
    func setInitParams(clientToken: String) {
        print("setInitParams")
        methodChannel.invokeMethod("initClientToken", arguments: clientToken)
    }
    
    private func setupMethodChannel() {
        methodChannel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            
            switch call.method {
            case "closeFlutterView":
                self.closeFlutterView()
            case "openVerifyPage":
                self.openVerifyPage(result: result)
            case "updateSharedSecret":
                self.handleUpdateSharedSecret(call: call, result: result)
            case "requestSharedSecret":
                self.handleRequestSharedSecret(call: call, result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    
    
    func showKgSDK(from viewController: UIViewController) {
        guard let flutterViewController = flutterViewController else {
            print("Error: FlutterViewController is not initialized")
            return
        }
        
        // 確保 Flutter 視圖已加載
        flutterViewController.view.layoutIfNeeded()
        
        // 設置為全螢幕顯示
        flutterViewController.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async {
            viewController.present(flutterViewController, animated: true, completion: nil)
        }
    }
    
    func dismissKgSDK(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.flutterViewController?.dismiss(animated: true, completion: completion)
        }
    }
    
    func deleteUser() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            methodChannel.invokeMethod("deleteUser", arguments: nil) { result in
                switch result {
                case let boolResult as Bool:
                    continuation.resume(returning: boolResult)
                case let error as FlutterError:
                    continuation.resume(throwing: NSError(domain: "KgSDKService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Flutter Error"]))
                default:
                    continuation.resume(throwing: NSError(domain: "KgSDKService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unexpected result type"]))
                }
            }
        }
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
                    switch result {
                    case let boolResult as Bool:
                        continuation.resume(returning: boolResult)
                    default:
                        continuation.resume(returning: false )
                    }
                }
            }
        }
    
    func hasLocalShareKey() async throws -> Bool {
            return try await withCheckedThrowingContinuation { continuation in
                methodChannel.invokeMethod("hasLocalShareKey", arguments: nil) { result in
                    switch result {
                    case let boolResult as Bool:
                        continuation.resume(returning: boolResult)
                    default:
                        continuation.resume(throwing: "error" as! Error)
                    }
                }
            }
        }
    
    func isWalletCreated() async throws -> Bool {
            return try await withCheckedThrowingContinuation { continuation in
                methodChannel.invokeMethod("isWalletCreated", arguments: nil) { result in
                    switch result {
                    case let boolResult as Bool:
                        continuation.resume(returning: boolResult)
                    default:
                        continuation.resume(returning: false)
                    }
                }
            }
        }
    
    func getAccessToken(completion: @escaping (Any?) -> Void) {
        methodChannel.invokeMethod("getAccessToken", arguments: nil, result: completion)
    }
    
    func getBalance(completion: @escaping (Any?) -> Void) {
        methodChannel.invokeMethod("getBalance", arguments: nil, result: completion)
    }
    
    func checkDevice(completion: @escaping (Any?) -> Void) {
        methodChannel.invokeMethod("checkDevice", arguments: nil, result: completion)
    }
    
    
    private func closeFlutterView() {
        DispatchQueue.main.async { [weak self] in
            self?.flutterViewController?.dismiss(animated: true, completion: nil)
        }
    }
    

    private func openVerifyPage(result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            guard let topViewController = UIApplication.shared.windows.first?.rootViewController?.topMostViewController() else {
                result(FlutterError(code: "NO_VIEWCONTROLLER", message: "Unable to find a view controller to present from", details: nil))
                return
            }
            
            let verifyPageVC = VerifyPageViewController()
            verifyPageVC.modalPresentationStyle = .fullScreen
            verifyPageVC.completion = { isVerified in
                if isVerified {
                    result(true)
                } else {
                    result(FlutterError(code: "VERIFICATION_FAILED", message: "User verification failed", details: nil))
                }
                topViewController.dismiss(animated: true, completion: nil)
            }
            
            topViewController.present(verifyPageVC, animated: true, completion: nil)
        }
    }

    
    
    private func handleUpdateSharedSecret(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let sharedSecret = (call.arguments as? [String: String])?["sharedSecret"] else {
            result(false)
            return
        }
        
        let isSuccess = updateSharedSecret(sharedSecret: sharedSecret)
        result(isSuccess)
    }
    
    private func handleRequestSharedSecret(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let reason = (call.arguments as? [String: String])?["reason"] else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Reason is required", details: nil))
            return
        }
        
        print("requestSharedSecret: \(reason)")
        openVerifyPage { verificationResult in
            guard let isVerified = verificationResult as? Bool, isVerified else {
                result(FlutterError(code: "VERIFICATION_FAILED", message: "User verification failed", details: nil))
                return
            }
            
            let sharedSecret = self.fetchSharedSecret()
            result(sharedSecret)
        }
    }
    
    private func updateSharedSecret(sharedSecret: String) -> Bool {
         // Here we're using UserDefaults for simplicity. In a real app, you'd want to use
         // a more secure storage method, like Keychain.
         UserDefaults.standard.set(sharedSecret, forKey: "KgSDKSharedSecret")
         return true
     }
     
    func fetchSharedSecret() -> String? {
         return UserDefaults.standard.string(forKey: "KgSDKSharedSecret")
    }
}

struct OutlineButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .foregroundColor(.blue)
        }
    }
}


import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}
