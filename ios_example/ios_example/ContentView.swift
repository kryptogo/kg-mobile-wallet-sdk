//
//  ContentView.swift
//  twm_test
//
//  Created by dora on 2024/2/1.
//

import SwiftUI
import Flutter
import FlutterPluginRegistrant


struct ContentView: View {
    @State private var showWebView = false
    private let webUrl = "http://localhost:62320/"
    var kgOauthToken = ""
    @EnvironmentObject var kgSDKService: KgSDKService
    
    
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
            
            VStack {
                
                Button(action: showKgSDK, label: {
                    Text("Show KG_SDK")
                })
                
                
                Button(action: callKgSDK, label: {
                    Text("Call KG_SDK")
                })
                
                Button(action: getAccessToken, label: {
                    Text("Call accessToken")
                })
                
                Button(action: isReady, label: {
                    Text("Call ready")
                })
                
                Button(action: getBalance, label: {
                    Text("Call getBalance")
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
    
    private func showKgSDK() {
        if let window = UIApplication.shared.windows.first, let rootViewController = window.rootViewController {
            kgSDKService.showKgSDK(from: rootViewController)
        }
    }
    
    private func callKgSDK() {
        kgSDKService.callKgSDK(funcName: "checkDevice", completion: { result in
            print(result ?? "no-data")
        })
    }
    
    private func getAccessToken() {
        kgSDKService.getAccessToken( completion: { result in
            print(result ?? "no-data")
        })
    }
    
    private func isReady() {
        kgSDKService.isReady( completion: { result in
            print(result ?? "no-data")
        })
    }
    
    private func getBalance() {
        kgSDKService.getBalance( completion: { result in
            print(result ?? "no-data")
        })
    }
    
    
}
