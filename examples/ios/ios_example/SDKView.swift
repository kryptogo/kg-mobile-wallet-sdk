import SwiftUI

struct SDKView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    SDKStatusView(isCheckingReady: $viewModel.isCheckingReady, isSDKReady: $viewModel.isSDKReady)
                    Button(action: {
                        viewModel.checkIsReady()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("重新檢查 SDK 狀態")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }.padding(.horizontal)
                    
                    
                    Divider()
                        .padding(.vertical)
                    
                    VStack() {
                        TextField("Client Token", text: $viewModel.initParamsInput)
                            .padding()
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            ).padding(.vertical)
                            
                            
                        
                        Button(action: {
                            viewModel.setCustomInitParams()
                            viewModel.checkIsReady()
                        }) {
                            Text("set client token")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }.padding(.horizontal)
                    
                 
                    NavigationLink(destination: WalletCenterView()) {
                        HStack {
                            Image(systemName: "wallet.pass")
                            Text("Wallet Center")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(!viewModel.isSDKReady)
                    .opacity(viewModel.isSDKReady ? 1.0 : 0.3)
                    .padding(.horizontal)
                    
                    
                    if viewModel.showWebView {
                        WebViewContainer(url: viewModel.webUrl, token: viewModel.kgOauthToken, isPresented: $viewModel.showWebView)
                    }
                    
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitle("SDK", displayMode: .large)
        }
    }
}

struct SDKStatusView: View {
    @Binding var isCheckingReady: Bool
    @Binding var isSDKReady: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SDK Status")
                .font(.headline)
            
            Group {
                if isCheckingReady {
                    HStack {
                        ProgressView()
                        Text("Checking SDK status...")
                    }
                } else if isSDKReady {
                    Label("SDK is Ready!", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Label("SDK is not ready", systemImage: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.tertiarySystemBackground))
            .cornerRadius(10)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct WebViewContainer: View {
    let url: URL
    let token: String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            WebView(url: url, token: token, isPresented: $isPresented)
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct SDKView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SDKView(viewModel: ContentViewModel())
        }
    }
}
