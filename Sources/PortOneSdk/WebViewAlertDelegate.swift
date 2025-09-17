import UIKit
import WebKit

extension UIApplication {
  fileprivate func topViewController() -> UIViewController? {
    let keyWindow =
      connectedScenes
      .filter({ $0.activationState == .foregroundActive })
      .compactMap({ $0 as? UIWindowScene })
      .first?
      .windows
      .filter({ $0.isKeyWindow })
      .first

    var topController = keyWindow?.rootViewController

    while let presentedViewController = topController?.presentedViewController {
      topController = presentedViewController
    }

    return topController
  }
}

@MainActor
func showWebViewConfirmAlertPanel(
  message: String, completionHandler: @escaping @MainActor (Bool) -> Void
) {
  if let topViewController = UIApplication.shared.topViewController() {
    let alert = UIAlertController(
      title: nil,
      message: message,
      preferredStyle: .alert
    )
    let okAction = UIAlertAction(
      title: "OK",
      style: .default,
      handler: { _ in
        completionHandler(true)
      }
    )
    alert.addAction(okAction)
    let cancelAction = UIAlertAction(
      title: "Cancel",
      style: .cancel,
      handler: { _ in
        completionHandler(false)
      }
    )
    alert.addAction(cancelAction)
    topViewController.present(alert, animated: true)
  } else {
    completionHandler(false)
  }
}
