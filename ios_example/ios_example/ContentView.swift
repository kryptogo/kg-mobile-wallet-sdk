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
                
                Button(action: checkDevice, label: {
                    Text("Call checkDevice")
                })
                
                Button(action: {
                    kgSDKService.openVerifyPage { isVerified in
                        print("isVerified: \(isVerified)")
                    }
                }, label: {
                    Text("Call openVerifyPage")
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

    
    private func showKgSDK() {
        if let window = UIApplication.shared.windows.first, let rootViewController = window.rootViewController {
            kgSDKService.showKgSDK(from: rootViewController)
        }
    }
    
    private func callKgSDK() {
        kgSDKService.callKgSDK(funcName: "callKgSDK", completion: { result in
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
            guard let isReady = result as? Bool else {
                print("no-data")
                return
            }
            print(isReady)
        })
    }
    
    private func getBalance() {
        kgSDKService.getBalance( completion: { result in
            print(result ?? "no-data")
        })
    }
    
    private func checkDevice() {
        kgSDKService.checkDevice( completion: { result in
            
            guard let isSame = result as? Bool else {
                print("no-data")
                return
            }
            print(isSame)
        })
    }
    
    

    
    
}


struct ModalView: View {
    @State private var inputText: String = ""
    @State private var showAlert = false
    var completion: (Bool) -> Void
    let verificationCode = "111111"

    var body: some View {
        VStack {
            Text("Enter something")
            TextField("Enter text", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Submit") {
                if inputText != verificationCode {
                    showAlert = true
                } else {
                    completion(true)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Input cannot be empty"), dismissButton: .default(Text("OK")))
            }

            Button("Cancel") {
                completion(false)
            }
        }
        .padding()
        .interactiveDismissDisabled()

    }
}
