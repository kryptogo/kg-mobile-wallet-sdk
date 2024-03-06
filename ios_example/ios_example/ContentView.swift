//
//  ContentView.swift
//  twm_test
//
//  Created by dora on 2024/2/1.
//

import SwiftUI
import Flutter

struct ContentView: View {
    @State private var showWebView = false
    private let webUrl = "https://pwa-dev.kryptogo.com/"
    var kgOauthToken = ""
    var flutterDependencies: FlutterDependencies
    
    var body: some View {
            TabView {
                NavigationView {
                    VStack {
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                        Text("Hello, iOS!")
                    }
                    .padding()
                    .navigationBarTitle("Home", displayMode: .inline)
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }

                // 添加更多的 Tab 项
                VStack {
                    Button(action: showFlutter, label: {
                        Text("Show Flutter")
                    })

                    Button(action: { self.showWebView.toggle() }, label: {
                               Text("Open Web Page")
                           })
                           .fullScreenCover(isPresented: $showWebView) {
                               VStack {
                                   Button("Close") {
                                       self.showWebView = false
                                   }
                                   WebView(url: URL(string: webUrl)!, token: kgOauthToken, isPresented: $showWebView)
                               }
                           }
                }
                .tabItem {
                    Label("Other", systemImage: "ellipsis.circle")
                }
            }
        }
    

    
    func openVerifyPage(result: @escaping FlutterResult) {
        // Assuming you have a VerifyPageViewController that handles the verification logic
        let verifyPageVC = VerifyPageViewController()
        verifyPageVC.modalPresentationStyle = .fullScreen
        verifyPageVC.completion = { isSuccess in
            print(isSuccess)
            result(isSuccess)
            DispatchQueue.main.async {
                verifyPageVC.dismiss(animated: true, completion: nil)
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

    func setUpMethodChannel(flutterViewController: FlutterViewController) {
        let channel = FlutterMethodChannel(name: "com.kryptogo.sdk/channel", binaryMessenger: flutterViewController.binaryMessenger)
        
        // Send initial parameter to Flutter.
        channel.invokeMethod("getInitialParam", arguments: ["flavor": "prod"])

        // Set method call handler for future Flutter-to-native calls.
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
          
            switch call.method {
                    case "closeFlutterView":
                        flutterViewController.dismiss(animated: true, completion: nil)
                    case "openVerifyPage":
                        self.openVerifyPage(result: result)
                        result(true)
                    default:
                        result(FlutterMethodNotImplemented)
                    }
        }
    }



    func showFlutter() {
        // Get the RootViewController.
        guard
          let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
          let window = windowScene.windows.first(where: \.isKeyWindow),
          let rootViewController = window.rootViewController
        else { return }

        // Create the FlutterViewController.
        let flutterViewController = FlutterViewController(
          engine: flutterDependencies.flutterEngine,
          nibName: nil,
          bundle: nil)
        flutterViewController.modalPresentationStyle = .overCurrentContext
        flutterViewController.isViewOpaque = false
        
        rootViewController.present(flutterViewController, animated: true)
        self.setUpMethodChannel(flutterViewController: flutterViewController)
      }
}

#Preview {
    ContentView(flutterDependencies: FlutterDependencies())
}
