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
        // Send initial parameter to Flutter.
        let initParam: [String: Any] = [
            "appName": "TWMTEST",
            "walletConfig": [
                "maxWallet": 100
            ],
            "themeData": [
                "primaryValue": "FFFFC211"
            ],
            "flavorEnum": "dev",
            "clientId": "def3b0768f8f95ffa0be37d0f54e2064",
            "clientToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImRlbW8ta2V5IiwidHlwIjoiSldUIn0.eyJhdWQiOiJodHRwczovL2tyeXB0b2dvLmNvbSIsImV4cCI6MjAyNzQwOTg2MiwiaXNzIjoiaHR0cHM6Ly9hdXRoLmtyeXB0b2dvLmNvbSIsInN1YiI6InRlc3QtdXNlciJ9.Kmbblm_cUJNpoRImSRQmb83ljY35Kn-ZcA5SBy5WOPqqL6T42YVDJFMyOAp05j3aFfUIZxCOqQAFuT23bC53jZM9SOZjz9cmwqHOE6D9wzk6Y2gwdOABSIeEet2nGzXfoHcPR1GLXJYdnOWYdh9ZivE4dtH4wGRO-eiOUoJX_kxSunBk1XanG6T3BcCDduEd-jxHTBSoi2fcMU_KfDVA9ZTc3kwzzYq3qQUMu8lBIBUQYqeV3S4M29AMn1gUAlP5Z1oKuQZzYEM3jLxAkN9hls1fMavsfi2VGYK87UE7THyWmTgMU9BDNzk3DrT7Wcxc1DOhwotyrTtep8BQkjsCJw"
        ]

        methodChannel?.invokeMethod("getInitialParam", arguments: initParam)

        // Set method call handler for future Flutter-to-native calls.
        methodChannel?.setMethodCallHandler { [self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
                    case "closeFlutterView":
                        flutterViewController!.dismiss(animated: true, completion: nil)
                    case "openVerifyPage":
                        self.openVerifyPageCallback?(result)
                    default:
                        result(FlutterMethodNotImplemented)
                    }
        }
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
