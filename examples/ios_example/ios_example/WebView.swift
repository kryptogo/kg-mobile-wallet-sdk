import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    var token: String
    @Binding var isPresented: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let js = "window.kryptogo_wallet = {'id_token': '\(self.parent.token)'}"
            webView.evaluateJavaScript(js, completionHandler: nil)
        }
    }
}
