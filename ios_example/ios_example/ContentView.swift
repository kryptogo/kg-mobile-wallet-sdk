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
    @State private var isSDKReady = false
    @State private var isCheckingReady = false
    @State private var balance = ""

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
                
                if isCheckingReady {
                    ProgressView("Checking SDK status...")
                } else if isSDKReady {
                    Text("SDK is Ready!")
                        .foregroundColor(.green)
                        .padding()
                } else {
                    Text("SDK is not ready")
                        .foregroundColor(.red)
                        .padding()
                }

                // balance
                Text("Balance: \(balance)").padding()
            
                
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
        .onAppear {
            checkIsReady()
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
            if let resultString = result as? String {
                self.showToast(message: resultString)
            } else {
                self.showToast(message: "no-data")
            }
        })

        
    }
    
    private func getAccessToken() {
        kgSDKService.getAccessToken( completion: { result in
            print(result ?? "no-data")
            if let resultString = result as? String {
                self.showToast(message: resultString)
            } else {
                self.showToast(message: "no-data")
            }
        })
    }
    
    private func isReady() {
        kgSDKService.isReady( completion: { result in
            guard let isReady = result as? Bool else {
                print("no-data")
                return
            }
            print(isReady)
            if let resultString = result as? String {
                self.showToast(message: resultString)
            } else {
                self.showToast(message: "no-data")
            }
        })
    }
    
    private func getBalance() {
        kgSDKService.getBalance( completion: { result in
            print(result ?? "no-data")
            if let resultString = result as? String {
                self.showToast(message: resultString)
            
            } else {
                self.showToast(message: "no-data")
            }
        })
    }
    
    private func checkDevice() {
        kgSDKService.checkDevice( completion: { result in
            
            guard let isSame = result as? Bool else {
                print("no-data")
                return
            }
            print(isSame)
            if let resultString = result as? String {
                self.showToast(message: resultString)
            } else {
                self.showToast(message: "no-data")
            }
        })
    }

    // show toast 
    private func showToast(message: String) {
        let toast = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        toast.view.backgroundColor = .black
        toast.view.alpha = 0.6
        toast.view.layer.cornerRadius = 15
        
        // Add a dismiss action
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        toast.addAction(dismissAction)
        
        // Automatically dismiss after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            toast.dismiss(animated: true, completion: nil)
        }
        
        if let window = UIApplication.shared.windows.first, let rootViewController = window.rootViewController {
            rootViewController.present(toast, animated: true, completion: nil)
        }
    }

    private func checkIsReady() {
        isCheckingReady = true
        checkReadyStatus()
    }

    private func checkReadyStatus() {
        kgSDKService.isReady { result in
            if let isReady = result as? Bool {
                if isReady {
                    self.isSDKReady = true
                    self.isCheckingReady = false
                    // delay 1 second to get balance
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        kgSDKService.getBalance( completion: { result in
                        self.balance = result as? String ?? "-"
        })
                    }
                } else {
                    // If not ready, check again after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.checkReadyStatus()
                    }
                }
            } else {
                self.showToast(message: "Failed to check ready status")
                self.isCheckingReady = false
            }
        }
    }

}


struct ModalView: View {
    @State private var inputText: String = ""
    @State private var showAlert = false
    var completion: (Bool) -> Void
    let verificationCode = "111111"
    @Environment(\.presentationMode) var presentationMode

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
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Input cannot be empty"), dismissButton: .default(Text("OK")))
            }

            Button("Cancel") {
                completion(false)
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding()
    }
}
