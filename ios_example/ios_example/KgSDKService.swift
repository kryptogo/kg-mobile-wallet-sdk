import Flutter
import FlutterPluginRegistrant


class KgSDKService : ObservableObject{
    static let shared = KgSDKService()
    private var flutterEngine: FlutterEngine?
    private var flutterViewController: FlutterViewController?
    private var methodChannel: FlutterMethodChannel?
    private var openVerifyPageCallback: ((_ result: @escaping FlutterResult) -> Void)?
    private var channelName: String = "com.kryptogo.sdk/channel"
    
    
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
        methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: flutterVC.binaryMessenger)
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
            "clientId": "def3b0768f8f95ffa0be37d0f54e2064",
            "clientToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImRlbW8ta2V5IiwidHlwIjoiSldUIn0.eyJhdWQiOiJodHRwczovL2tyeXB0b2dvLmNvbSIsImV4cCI6MjAyNzQwOTg2MiwiaXNzIjoiaHR0cHM6Ly9hdXRoLmtyeXB0b2dvLmNvbSIsInN1YiI6InRlc3QtdXNlcjIifQ.iLJy5JM9uY0Qqtsngyjvx9coU3e5ILgVyjL2IoFdNnqVvDK6zvF28Oy_Svm_9klLhQT-v0We9IwuNhAHOMQ5hHZ4qKna0iBuAy6K2Ooj9N2_1sn4Wxfj-QIQQc1Sx3rSaVuxES2qGyccVH460-KK-jXLsDde7WZNgyJdXlsTwnOUM62w-VODhhRRpoqsmNr_aTHPhsF5XAYCCZVjZss2L4x1XQWMZff0Cue_cQl3Beh3NU8qHpGdTBhIZHH6YjnTdzBtJSCapzU-YFwNArLlnZRcVG2ZtLK_2iA15918w8GtckwHlEDkvl3f49F5oKiY5CiTuU2_RIKP1AoMkvl-5g"
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
        
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: flutterViewController.binaryMessenger)
        channel.invokeMethod(funcName, arguments: nil,result: { (result) in
            print(result ?? "no-data")
            completion(result)
            
        })
    }
    
}
