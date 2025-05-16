import UIKit
import WebKit
import CleverTapSDK

class WebviewViewController: UIViewController, WKScriptMessageHandler {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupWebView()
    }
    

    private func setupWebView() {
        let contentController = WKUserContentController()

        // Initialize the CleverTapJSInterface safely
        guard let cleverTapConfig = CleverTap.sharedInstance()?.config else {
            print("Failed to get CleverTap config")
            return
        }
        
        guard let ctInterface = CleverTapJSInterface(config: cleverTapConfig) else {
            print("Failed to initialize CleverTapJSInterface")
            return
        }
        
        contentController.add(ctInterface, name: "iOS") // Unique identifier

        // Configure the WebView
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        // Set up Auto Layout to ensure the WebView fits the entire screen
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Load a sample URL or HTML content into the WebView
        if let url = URL(string: "https://manishchilwal.github.io/WebIntegration/") {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            print("Invalid URL")
        }
    }

    // Implement the WKScriptMessageHandler method
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "iOS" {
            print("Received message from JS: \(message.body)")
            // Handle the JS messages here
            handleJSMessage(message)
        }
    }

    private func handleJSMessage(_ message: WKScriptMessage) {
        // Handle and parse JavaScript messages from the web view here
        // Example: Handle different actions sent from JS
        if let messageBody = message.body as? [String: Any], let action = messageBody["action"] as? String {
            switch action {
            case "recordEventWithProps":
                if let event = messageBody["event"] as? String, let properties = messageBody["properties"] as? [String: Any] {
                    CleverTap.sharedInstance()?.recordEvent(event, withProps: properties)
                }
            case "profilePush":
                if let properties = messageBody["properties"] as? [String: Any] {
                    CleverTap.sharedInstance()?.profilePush(properties)
                }
            default:
                print("Unknown action from JS: \(action)")
            }
        } else {
            print("Invalid message format")
        }
    }
}
