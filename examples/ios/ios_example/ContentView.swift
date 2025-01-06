import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var isSDKReady = false
    @Published var isCheckingReady = false
    @Published var showWebView = false
    @Published var balance = ""
    @Published var initParamsInput: String
    var errorMessage: String?
    
    let kgOauthToken = ""
    
    private let kgSDKService: KgSDKService
    private let clientTokenKey = "KgSDKClientToken"
    
    init(kgSDKService: KgSDKService = .shared) {
        self.kgSDKService = kgSDKService
        
        // Load saved clientToken from UserDefaults
        self.initParamsInput = UserDefaults.standard.string(forKey: clientTokenKey) ?? ""
    }

    // Check if the SDK is ready
    func checkIsReady() {
        isCheckingReady = true
        checkReadyStatus()
    }

    
    // Set the initialization parameters, clientToken is required
    func setInitParams() async throws {
        let clientToken = Constants.KgSDK.clientToken
        do {
             try await kgSDKService.initKgSDK(clientToken: clientToken)
            print("Successfully set init params")
        } catch {
            
            errorMessage = "Failed to set init params: \(error.localizedDescription)"
            print(errorMessage!)
            throw error
        }
    }

    func setCustomInitParams() async throws {
        DispatchQueue.main.async {
            self.isCheckingReady = true
        }
        // Save the clientToken to UserDefaults
        UserDefaults.standard.set(initParamsInput, forKey: clientTokenKey)
        
        do {
            try await kgSDKService.initKgSDK(clientToken: initParamsInput)
            print("Custom init params successfully set")
        } catch {
            errorMessage = "Failed to set custom init params: \(error.localizedDescription)"
            print(errorMessage!)
            throw error

        }
    }
    
    func setNewUserInitParams() async throws {
        let clientToken = Constants.KgSDK.newUserclientToken
        do {
            try await kgSDKService.initKgSDK(clientToken: clientToken)
            print("New user init params successfully set")
        } catch {
            errorMessage = "Failed to set new user init params: \(error.localizedDescription)"
            print(errorMessage!)
            throw error

        }
    }
    
    func setNoLocalInitParams() async throws {
        let clientToken = Constants.KgSDK.missingLocalClientToken
        do {
            try await kgSDKService.initKgSDK(clientToken: clientToken)
            print("No local init params successfully set")
        } catch {
            errorMessage = "Failed to set no local init params: \(error.localizedDescription)"
            print(errorMessage!)
            throw error
        }
    }
    
    private func checkReadyStatus() {
        kgSDKService.isReady { [weak self] result in
            guard let self = self else { return }
            if let isReady = result as? Bool {
                if isReady {
                    self.isSDKReady = true
                    self.isCheckingReady = false
                    self.errorMessage = nil
                    self.getBalance()
                } else if errorMessage != nil {
                    self.isCheckingReady = false

                }
                
                else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.checkReadyStatus()
                    }
                }
            } else {
                self.isCheckingReady = false
            }
        }
    }
    
    private func getBalance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.kgSDKService.getBalance { result in
                self.balance = result as? String ?? "-"
            }
        }
    }
    
    func refreshSharedSecret() async throws{
        do {
            try await kgSDKService.refreshSharedSecret()
            print("Refresh shared secret successful")
        } catch {
            errorMessage = "Failed to refresh shared secret: \(error.localizedDescription)"
            print(errorMessage!)
            throw error

        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SDKView(viewModel: viewModel)
                .tabItem {
                    Label("SDK", systemImage: "ellipsis.circle")
                }
        }
        .onAppear {
        }
    }
}

