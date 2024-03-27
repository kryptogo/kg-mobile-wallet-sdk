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
        methodChannel?.invokeMethod("getInitialParam", arguments: ["flavor": "prod"])

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
