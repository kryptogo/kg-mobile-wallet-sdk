import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var isSDKReady = false
    @Published var isCheckingReady = false
    @Published var showWebView = false
    @Published var balance = ""
    
    let webUrl = URL(string: "http://localhost:62320/")!
    let kgOauthToken = ""
    
    private let kgSDKService: KgSDKService
    
    init(kgSDKService: KgSDKService = .shared) {
        self.kgSDKService = kgSDKService
    }

    func deleteUser() {
        Task {
            do {
                try await kgSDKService.deleteUser()
            } catch {
                print("Error deleting user: \(error)")
            }
        }
    }

    // Check if the SDK is ready
    func checkIsReady() {
        isCheckingReady = true
        checkReadyStatus()
    }
    
    // Set the initialization parameters, clientToken is required
    func setInitParams() {
        let clientToken = Constants.KgSDK.clientToken
        kgSDKService.setInitParams(clientToken: clientToken)
    }
    
    func setNewUserInitParams() {
        let clientToken = Constants.KgSDK.newUserclientToken
        kgSDKService.setInitParams(clientToken: clientToken)
    }
    
    func setNoLocalInitParams() {
        let clientToken = Constants.KgSDK.missingLocalClientToken
        kgSDKService.setInitParams(clientToken: clientToken)
    }
    
    private func checkReadyStatus() {
        kgSDKService.isReady { [weak self] result in
            guard let self = self else { return }
            if let isReady = result as? Bool {
                if isReady {
                    self.isSDKReady = true
                    self.isCheckingReady = false
                    self.getBalance()
                } else {
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
            viewModel.checkIsReady()
        }
    }
}

