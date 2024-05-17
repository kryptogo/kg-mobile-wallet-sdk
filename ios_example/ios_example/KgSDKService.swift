import Flutter
import SwiftUI
import FlutterPluginRegistrant


class KgSDKService : ObservableObject{
    static let shared = KgSDKService()
    private var flutterEngine: FlutterEngine?
    private var flutterViewController: FlutterViewController?
    private var methodChannel: FlutterMethodChannel?
    private var openVerifyPageCallback: ((_ result: @escaping FlutterResult) -> Void)?
    private var channelName: String = "com.kryptogo.sdk/channel"
    private var engineName: String = "flutter_engine"
    
    
    private init (flutterViewController: FlutterViewController? = nil, methodChannel: FlutterMethodChannel? = nil, openVerifyPageCallback: ( (_: FlutterResult) -> Void)? = nil) {
        
        self.openVerifyPageCallback = openVerifyPageCallback
        self.flutterEngine = FlutterEngine(name: engineName)
        flutterEngine!.run()
        
        self.flutterViewController = FlutterViewController(engine: flutterEngine!, nibName: nil, bundle: nil)
        self.methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: self.flutterViewController!.binaryMessenger)
        GeneratedPluginRegistrant.register(with: self.flutterEngine!)
        setInitParams()
        
    }
    
    
    private func initializeFlutterViewController(flutterEngine: FlutterEngine) {
        guard let flutterVC = flutterViewController else { return }
        setUpMethodChannel()
    }
    
    private func setInitParams() {
        let sharedSecret = fetchSharedSecret()
        
        // Send initial parameter to KG_SDK.
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
            "clientId": "def3b0768f8f95ffa0be37d0f54e2064",
            "clientToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImRlbW8ta2V5IiwidHlwIjoiSldUIn0.eyJhdWQiOiJodHRwczovL2tyeXB0b2dvLmNvbSIsImV4cCI6MjAyNzQwOTg2MiwiaXNzIjoiaHR0cHM6Ly9hdXRoLmtyeXB0b2dvLmNvbSIsInN1YiI6InRlc3QtdXNlcjMifQ.TIHOBrcWHKihlTlKs7lDn3seSmWkVLkErmc21oB_W0lGXu2MKr152l6IC-s3SrDPiEqX5ERptaHPW4qcb5ls4uV_IAw-UkH-_-oUPGDTabp7TsL0tEL0ELBNZaOWOafcbb6X_qU3YXXI_TX0OVV9nR0p27R2guPdgA7mpvTaLvT8CIr6NpiFPC3wnYkBxfR2t-bMPNgndQcY5froDjQvbqIKNnt8fESFqM6q0QYi-y_Nag0eLND7ZK53TdLM72ccjRDQM2bzmo2x_qJhcf7QG_03-ww3HLuRKmmzHRjuewPHKzfLUjbKG5BowO-Q94pyo5zqEnD-VfRdzk3vyJEqHQ"
        ]
        

        if sharedSecret != nil {
            initParam["sharedSecret"] = sharedSecret
        }
        
        methodChannel?.invokeMethod("init", arguments: initParam)
        print("innns")
        
    }
    
    private func setUpMethodChannel() {
        methodChannel?.setMethodCallHandler { [self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "closeFlutterView":
                flutterViewController!.dismiss(animated: true, completion: nil)
            case "openVerifyPage":
                openVerifyPage(result:result)
            case "updateSharedSecret":
                let sharedSecret = (call.arguments as? [String: String])?["sharedSecret"]
                let isSuccess = self.updateSharedSecret(sharedSecret: sharedSecret)
                result(isSuccess)
            case "requestSharedSecret":
                let reason = (call.arguments as? [String: String])?["reason"]
                print("requestSharedSecret: \(reason ?? "")")
                openVerifyPage { verificationResult in
                    guard let isVerified = verificationResult as? Bool else {
                        print("no-data")
                        return
                    }
                    
                    let sharedSecret = self.fetchSharedSecret()
                    result(sharedSecret)
                }
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    func openVerifyPage(result: @escaping FlutterResult) {
        // Assuming you have a VerifyPageViewController that handles the verification logic
        
        let verifyPageVC = VerifyPageViewController()
        verifyPageVC.isModalInPresentation = true
        
        verifyPageVC.completion = { isVerified in
            print(isVerified)
            if isVerified {
                DispatchQueue.main.async {
                    verifyPageVC.dismiss(animated: true) {
                        result(isVerified)
                    }
                }
            }
            
        }
        // Present your verifyPageVC here, e.g., using the top most view controller or another method.
        // Find the top most view controller to present the verifyPageVC
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // Present your verifyPageVC here
            topController.present(verifyPageVC, animated: true, completion: nil)
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
        initializeFlutterViewController(flutterEngine:flutterEngine!)
        
        flutterViewController?.isViewOpaque = false
        rootViewController.present(flutterViewController ?? createFlutterViewController(), animated: true)
    }
    
    private func createFlutterViewController() -> FlutterViewController{
        return FlutterViewController(engine: flutterEngine!, nibName: nil, bundle: nil)
    }
    
    
    func callKgSDK(funcName: String, completion: @escaping (Any?) -> Void) {
        methodChannel?.invokeMethod(funcName, arguments: nil,result: { (result) in
            completion(result)
        })
    }
    
    func isReady(completion: @escaping (Any?) -> Void) {
        methodChannel?.invokeMethod("isReady", arguments: nil,result: { (result) in
            completion(result)
        })
    }
    
    func getAccessToken(completion: @escaping (Any?) -> Void) {
        methodChannel?.invokeMethod("getAccessToken", arguments: nil,result: { (result) in
            completion(result)
        })
    }
    
    func getBalance(completion: @escaping (Any?) -> Void) {
        methodChannel?.invokeMethod("getBalance", arguments: nil,result: { (result) in
            completion(result)
        })
    }
    
    func checkDevice(completion: @escaping (Any?) -> Void) {
        methodChannel?.invokeMethod("checkDevice", arguments: nil,result: { (result) in
            completion(result)
        })
    }
    
}

