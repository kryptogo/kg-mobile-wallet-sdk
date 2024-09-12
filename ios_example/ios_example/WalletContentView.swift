import SwiftUI

class WalletCenterViewModel: ObservableObject {
    @Published var balance: String = "Loading..."
    @Published var isWalletCreated: Bool = false
    @Published var hasLocalShareKey: Bool = false
    private let kgSDKService: KgSDKService
    
    init(kgSDKService: KgSDKService = .shared) {
        self.kgSDKService = kgSDKService
        refreshBalance()
        Task {
            await checkWalletStatus()
        }
    }
    
    func goRoute(route: String) {
        // Open KgSDK
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            kgSDKService.showKgSDK(from: topViewController)
        }
        
        // Navigate to the specified route
        kgSDKService.goRoute(route: route)
        
    }
    
    func kDebugMode() async {
        // print
        print("kDebugMode")
        
        do {
            let isDebugModeActivated = try await kgSDKService.kDebugMode()
            print("isDebugModeActivated", isDebugModeActivated)
        } catch {
            print("isDebugModeActivated error")
        }
    }
    
    func hasLocalShareKey() async {
        do {
            let hasLocalShareKey = try await kgSDKService.hasLocalShareKey()
            self.hasLocalShareKey = hasLocalShareKey
            print("hasLocalShareKey, ", hasLocalShareKey)
            
        } catch {
            print("hasLocalShareKey error")
        }
    }
    
    func isWalletCreated() async {
        do {
            let isWalletCreated = try await kgSDKService.isWalletCreated()
            self.isWalletCreated = isWalletCreated
            print("isWalletCreated, ", isWalletCreated)
            
        } catch {
            print("isWalletCreated error")
        }
    }
    
    @MainActor
    func checkWalletStatus() async {
        await hasLocalShareKey()
        await isWalletCreated()
    }
    
    func refreshBalance() {
        balance = "Loading..."
        kgSDKService.getBalance { [weak self] result in
            DispatchQueue.main.async {
                
                if let balanceResult = result {
                    print("refreshBalance",result)
                    switch balanceResult {
                    case let stringBalance as String:
                        self?.balance = stringBalance
                    case let doubleBalance as Double:
                        self?.balance = String(format: "%.2f", doubleBalance)
                    case let intBalance as Int:
                        self?.balance = String(intBalance)
                    default:
                        self?.balance = "Invalid balance format"
                    }
                } else {
                    self?.balance = "Error fetching balance"
                }
            }
        }
    }
    
    func restoreWallet(with password: String) {
        // Implement the logic to restore the wallet using the provided password
        print("Attempting to restore wallet with password: \(password)")
      
    }
}

struct WalletCenterView: View {
    @StateObject private var viewModel = WalletCenterViewModel()
    @State private var isShowingKgSDK = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Hi, Wallet")
                .font(.largeTitle)
            
            VStack(alignment: .leading) {
                Text("Total Balance")
                    .font(.headline)
                Text(viewModel.balance)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Button(action: {
                viewModel.refreshBalance()
            }) {
                Text("Refresh Balance")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            if viewModel.isWalletCreated && viewModel.hasLocalShareKey {
                List {
                    Button(action: {
                        viewModel.goRoute(route: "/send_token/select_token")
                    }) {
                        Label("Send", systemImage: "paperplane")
                    }
                    Button(action: {
                        viewModel.goRoute(route: "/swap")
                    }) {
                        Label("Swap", systemImage: "arrow.triangle.2.circlepath")
                    }
                    Button(action: {
                        viewModel.goRoute(route: "/receive_address")
                    }) {
                        Label("Receive", systemImage: "tray.and.arrow.down")
                    }
                }
            } else if viewModel.isWalletCreated && !viewModel.hasLocalShareKey {
                VStack {
                    Image(systemName: "wallet.pass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                    
                    Text("Wallet created, but no local share key")
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        showPasswordAlert()
                    }) {
                        Text("Restore Wallet")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding()
            } else {
                VStack {
                    Image(systemName: "wallet.pass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                    
                    Text("Wallet not create")
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        let verifyPageVC = VerifyPageViewController()
                        verifyPageVC.modalPresentationStyle = .fullScreen
                        verifyPageVC.completion = { isVerified in
                            if isVerified {
                                // 驗證成功，先關閉 VerifyPageViewController
                                verifyPageVC.dismiss(animated: true) {
                                    // VerifyPageViewController 完全關閉後，打開 KgSDK
                                    DispatchQueue.main.async {
                                        if let topViewController = UIApplication.shared.windows.first?.rootViewController?.topMostViewController() {
                                            KgSDKService.shared.showKgSDK(from: topViewController)
                                        }
                                    }
                                }
                            } else {
                                // 驗證失敗，可以在這裡處理
                                print("Verification failed")
                            }
                        }
                        UIApplication.shared.windows.first?.rootViewController?.present(verifyPageVC, animated: true, completion: nil)
                    }) {
                        Text("Create Wallet")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding()
            }
            Spacer() // 添加這行來將內容推到頂部
        }
        .frame(maxHeight: .infinity, alignment: .top) // 添加這行來確保整個 VStack 靠上對齊
        .padding()
        .navigationBarTitle("Wallet Center", displayMode: .inline)
        .sheet(isPresented: $isShowingKgSDK) {
            KgSDKView()
        }
    }
    
    func showPasswordAlert() {
        let alert = UIAlertController(title: "Restore Wallet", message: "Please enter your password", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "Password"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            guard let password = alert.textFields?.first?.text, !password.isEmpty else {
                print("Password is empty")
                return
            }
            
            // Here you can call the function to restore the wallet with the entered password
            self.viewModel.restoreWallet(with: password)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}

struct KgSDKView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        DispatchQueue.main.async {
            KgSDKService.shared.showKgSDK(from: viewController)
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct WalletCenterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WalletCenterView()
        }
    }
}
