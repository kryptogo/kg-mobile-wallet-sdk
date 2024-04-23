import Flutter
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
        flutterEngine?.run()
        
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
            "clientToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImRlbW8ta2V5IiwidHlwIjoiSldUIn0.eyJhdWQiOiJodHRwczovL2tyeXB0b2dvLmNvbSIsImV4cCI6MjAyNzQwOTg2MiwiaXNzIjoiaHR0cHM6Ly9hdXRoLmtyeXB0b2dvLmNvbSIsInN1YiI6InRlc3QtdXNlciJ9.Kmbblm_cUJNpoRImSRQmb83ljY35Kn-ZcA5SBy5WOPqqL6T42YVDJFMyOAp05j3aFfUIZxCOqQAFuT23bC53jZM9SOZjz9cmwqHOE6D9wzk6Y2gwdOABSIeEet2nGzXfoHcPR1GLXJYdnOWYdh9ZivE4dtH4wGRO-eiOUoJX_kxSunBk1XanG6T3BcCDduEd-jxHTBSoi2fcMU_KfDVA9ZTc3kwzzYq3qQUMu8lBIBUQYqeV3S4M29AMn1gUAlP5Z1oKuQZzYEM3jLxAkN9hls1fMavsfi2VGYK87UE7THyWmTgMU9BDNzk3DrT7Wcxc1DOhwotyrTtep8BQkjsCJw"
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
        initializeFlutterViewController(flutterEngine:flutterEngine!)
        
        flutterViewController?.modalPresentationStyle = .overCurrentContext
        flutterViewController?.isViewOpaque = false
        rootViewController.present(flutterViewController ?? createFlutterViewController(), animated: true)
    }
    
    private func createFlutterViewController() -> FlutterViewController{
        return FlutterViewController(engine: flutterEngine!, nibName: nil, bundle: nil)
    }
    
    
    func callKgSDK(funcName: String, completion: @escaping (Any?) -> Void) {
        methodChannel?.invokeMethod(funcName, arguments: nil,result: { (result) in
            print(result ?? "no-data")
            completion(result)
        })
    }
    
    func isReady(completion: @escaping (Any?) -> Void) {
        methodChannel?.invokeMethod("isReady", arguments: nil,result: { (result) in
            print(result ?? "no-data")
            completion(result)
        })
    }
    
    func getAccessToken(completion: @escaping (Any?) -> Void) {
        methodChannel?.invokeMethod("getAccessToken", arguments: nil,result: { (result) in
            print(result ?? "no-data")
            completion(result)
        })
    }
    
}
