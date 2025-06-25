import SwiftUI
import WebKit
import os

@available(iOS 14.0, *)
private let logger = Logger(subsystem: "io.portone.sdk", category: "IdentityVerification")

@available(iOS 14.0, *)
public struct IdentityVerificationWebView: UIViewRepresentable {

  let json: String
  let onCompletion: (IdentityVerificationResult) -> Void

  public init?(data: [String: Any], onCompletion: @escaping (IdentityVerificationResult) -> Void) {
    if data["redirectUrl"] != nil {
      logger.warning("redirectUrl 파라미터는 SDK에서 자동으로 설정되므로 생략해 주세요.")
    }
    guard let jsonData = try? JSONSerialization.data(withJSONObject: data),
      let jsonString = String(data: jsonData, encoding: .utf8)
    else {
      return nil
    }
    self.json = jsonString
    self.onCompletion = { result in
      logger.debug("completed: \(String(reflecting: result))")
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
        PortOne.requestIdentityVerification({
          ...request,
          redirectUrl: "https://ios-sdk.portone.io/done",
        }).catch((e) => {
          window.webkit.messageHandlers.errorHandler.postMessage(e.message);
        });
      });
      </script>
      </body>
      </html>
      """
    logger.debug("Loading initial HTML")
    webView.loadHTMLString(html, baseURL: URL(string: "https://ios-sdk.portone.io/ready"))

    return webView
  }

  public func updateUIView(_ uiView: WKWebView, context: Context) {
    context.coordinator.onCompletion = onCompletion
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(onCompletion: onCompletion)
  }

  // MARK: - Coordinator

  public class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    var onCompletion: (IdentityVerificationResult) -> Void
    private var isCompleted = false  // onCompletion이 중복 호출되는 것을 방지
    private var lock = os_unfair_lock()

    init(onCompletion: @escaping (IdentityVerificationResult) -> Void) {
      self.onCompletion = onCompletion
      super.init()
    }

    // postMessage callback
    public func userContentController(
      _ userContentController: WKUserContentController, didReceive message: WKScriptMessage
    ) {
      if message.name == "errorHandler", let errorMessage = message.body as? String {
        logger.error("Error from webView: \(errorMessage)")

        os_unfair_lock_lock(&lock)
        guard !isCompleted else {
          os_unfair_lock_unlock(&lock)
          return
        }
        isCompleted = true
        os_unfair_lock_unlock(&lock)

        onCompletion(.failure(.invalidArgument(message: errorMessage)))
      }
    }

    public func webView(
      _ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
      decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
    ) {
      guard let url = navigationAction.request.url else {
        logger.warning("Cannot fetch URL, allowing navigation")
        decisionHandler(.allow)
        return
      }

      logger.debug("Attempting navigation to: \(url.absoluteString)")

      // 완료 URL 처리
      if url.absoluteString.starts(with: "https://ios-sdk.portone.io/done") {
        decisionHandler(.cancel)

        os_unfair_lock_lock(&lock)
        guard !isCompleted else {
          os_unfair_lock_unlock(&lock)
          return
        }
        isCompleted = true
        os_unfair_lock_unlock(&lock)

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []

        guard
          let identityVerificationTxId = queryItems.first(where: {
            $0.name == "identityVerificationTxId"
          })?.value
        else {
          onCompletion(
            .failure(.unknown(message: "본인인증 결과에서 identityVerificationTxId를 찾을 수 없습니다.")))
          return
        }
        guard
          let identityVerificationId = queryItems.first(where: {
            $0.name == "identityVerificationId"
          })?.value
        else {
          onCompletion(
            .failure(.unknown(message: "본인인증 결과에서 identityVerificationId를 찾을 수 없습니다.")))
          return
        }
        if let code = queryItems.first(where: { $0.name == "code" })?.value {
          let portMessage = queryItems.first(where: { $0.name == "message" })?.value
          let pgCode = queryItems.first(where: { $0.name == "pgCode" })?.value
          let pgMessage = queryItems.first(where: { $0.name == "pgMessage" })?.value
          onCompletion(
            .failure(
              .failed(
                identityVerificationTxId: identityVerificationTxId,
                identityVerificationId: identityVerificationId, code: code, message: portMessage,
                pgCode: pgCode, pgMessage: pgMessage)))
        } else {
          onCompletion(
            .success(
              .init(
                identityVerificationTxId: identityVerificationTxId,
                identityVerificationId: identityVerificationId)))
        }
        return
      }

      if let scheme = url.scheme, !["http", "https"].contains(scheme.lowercased()) {
        decisionHandler(.cancel)  // 이동 제한
        logger.debug("Found app scheme: \(scheme)")
        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:]) { success in
            logger.debug("App opened: \(success)")
          }
        } else {
          logger.warning("Cannot open URL with scheme '\(scheme)' - app may not be installed")
        }
        return
      }

      decisionHandler(.allow)
    }

    public func webView(
      _ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error
    ) {
      os_unfair_lock_lock(&lock)
      let alreadyCompleted = isCompleted
      os_unfair_lock_unlock(&lock)

      guard !alreadyCompleted else { return }
      logger.error("Navigation error: \(error)")
    }

    public func webView(
      _ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!,
      withError error: Error
    ) {
      os_unfair_lock_lock(&lock)
      let alreadyCompleted = isCompleted
      os_unfair_lock_unlock(&lock)

      guard !alreadyCompleted else { return }
      logger.error("Content loading error: \(error)")
    }
  }
}
