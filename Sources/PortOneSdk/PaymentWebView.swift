import SwiftUI
import WebKit

public struct PaymentWebView: UIViewRepresentable {

  let json: String
  let onCompletion: (PaymentResult) -> Void

  public init?(data: [String: Any], onCompletion: @escaping (PaymentResult) -> Void) {
    if data["redirectUrl"] != nil {
      PortOneLogger.log("redirectUrl 파라미터는 SDK에서 자동으로 설정되므로 생략해 주세요.")
    }
    guard let json = try? JSONSerialization.data(withJSONObject: data) else {
      return nil
    }
    guard let jsonString = String(data: json, encoding: .utf8) else {
      return nil
    }
    self.json = jsonString
    self.onCompletion = { result in
      PortOneLogger.log("complete: \(result)")
      onCompletion(result)
    }
  }

  public func makeUIView(context: Context) -> WKWebView {
    let userContentController = WKUserContentController()
    userContentController.add(context.coordinator, name: "errorHandler")

    let configuration = WKWebViewConfiguration()
    configuration.userContentController = userContentController

    let webView = WKWebView(frame: .zero, configuration: configuration)
    webView.navigationDelegate = context.coordinator
    #if DEBUG
      if #available(iOS 16.4, *) {
        webView.isInspectable = true
      }
    #endif

    let html = """
      <!doctype html>
      <html>
      <head>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      </head>
      <body>
      <script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
      <script>
      document.addEventListener('DOMContentLoaded', () => {
        const request = \(json);
        PortOne.requestPayment({
          ...request,
          redirectUrl: "https://ios-sdk.portone.io/done",
        }).catch((e) => {
          window.webkit.messageHandlers.errorHandler.postMessage(e.message);
        });
      });
      </script>
      <body>
      </body>
      </html>
      """
    PortOneLogger.log("load initial HTML")
    webView.loadHTMLString(html, baseURL: URL(string: "https://ios-sdk.portone.io/ready"))

    return webView
  }

  public func updateUIView(_ uiView: WKWebView, context: Context) {
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  // MARK: - Coordinator

  public class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    var parent: PaymentWebView
    private var isCompleted = false  // onCompletion이 중복 호출되는 것을 방지

    init(_ parent: PaymentWebView) {
      self.parent = parent
    }

    // postMessage callback
    public func userContentController(
      _ userContentController: WKUserContentController, didReceive message: WKScriptMessage
    ) {
      guard !isCompleted else { return }

      if message.name == "errorHandler", let errorMessage = message.body as? String {
        PortOneLogger.log("error from webView: \(errorMessage)")
        isCompleted = true
        parent.onCompletion(.failure(.invalidArgument(message: errorMessage)))
      }
    }

    public func webView(
      _ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
      decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
    ) {
      guard let url = navigationAction.request.url else {
        PortOneLogger.log("cannot fetch url, allowing navigation")
        decisionHandler(.allow)
        return
      }

      PortOneLogger.log("try navigating to: \(url.absoluteString)")

      // 완료 URL 처리
      if url.absoluteString.starts(with: "https://ios-sdk.portone.io/done") {
        decisionHandler(.cancel)
        guard !isCompleted else {
          return
        }
        isCompleted = true

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []

        guard let txId = queryItems.first(where: { $0.name == "txId" })!.value else {
          parent.onCompletion(.failure(.unknown(message: "결제 결과에서 txId를 찾을 수 없습니다.")))
          return
        }
        guard let paymentId = queryItems.first(where: { $0.name == "paymentId" })!.value else {
          parent.onCompletion(.failure(.unknown(message: "결제 결과에서 paymentId를 찾을 수 없습니다.")))
          return
        }
        if let code = queryItems.first(where: { $0.name == "code" })?.value {
          let portMessage = queryItems.first(where: { $0.name == "message" })?.value
          let pgCode = queryItems.first(where: { $0.name == "pgCode" })?.value
          let pgMessage = queryItems.first(where: { $0.name == "pgMessage" })?.value
          parent.onCompletion(
            .failure(
              .failed(
                txId: txId, paymentId: paymentId, code: code, message: portMessage, pgCode: pgCode,
                pgMessage: pgMessage)))
        } else {
          parent.onCompletion(.success(.init(txId: txId, paymentId: paymentId)))
        }
        return
      }

      if let scheme = url.scheme, !["http", "https"].contains(scheme.lowercased()) {
        decisionHandler(.cancel)  // 이동 제한
        PortOneLogger.log("found app scheme: \(scheme)")
        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:]) { success in
            PortOneLogger.log("app opened: \(success)")
          }
        } else {

        }
        return
      }

      decisionHandler(.allow)
    }

    public func webView(
      _ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error
    ) {
      guard !isCompleted else { return }
      PortOneLogger.log("error navigating: \(error)")
    }

    public func webView(
      _ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!,
      withError error: Error
    ) {
      guard !isCompleted else { return }
      PortOneLogger.log("error loading content: \(error)")
    }
  }
}
