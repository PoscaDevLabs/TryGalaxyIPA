import SwiftUI
import WebKit

@main
struct TryGalaxyApp: App {
    var body: some Scene {
        WindowGroup {
            GalaxyWebView()
                .ignoresSafeArea()
                .statusBarHidden(true)
        }
    }
}

struct GalaxyWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        let spoofJS = """
        Object.defineProperty(navigator, 'standalone', { get: () => true });
        const origMatchMedia = window.matchMedia;
        window.matchMedia = function(query) {
            if (query.includes('display-mode: standalone')) {
                return { matches: true, media: query, onchange: null, addListener: () => {}, removeListener: () => {}, addEventListener: () => {}, removeEventListener: () => {}, dispatchEvent: () => false };
            }
            return origMatchMedia.apply(this, arguments);
        };
        """
        let script = WKUserScript(source: spoofJS, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7 Mobile/15E148 Safari/604.1"
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        if let url = URL(string: "https://trygalaxy.com") {
            webView.load(URLRequest(url: url))
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
