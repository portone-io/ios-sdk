import SwiftUI
import UIKit

@available(iOS 14.0, *)
public class IssueBillingKeyViewController: UIViewController {
  private let request: IssueBillingKeyRequest
  private let onCompletion: (IssueBillingKeyResult) -> Void
  private var hostingController: UIHostingController<IssueBillingKeyWebView>?

  public init(request: IssueBillingKeyRequest, onCompletion: @escaping (IssueBillingKeyResult) -> Void) {
    self.request = request
    self.onCompletion = onCompletion
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    setupIssueBillingKeyWebView()
  }

  private func setupIssueBillingKeyWebView() {
    guard let issueBillingKeyWebView = IssueBillingKeyWebView(request: request, onCompletion: onCompletion) else {
      return
    }
    let hostingController = UIHostingController(rootView: issueBillingKeyWebView)

    addChild(hostingController)
    view.addSubview(hostingController.view)
    hostingController.didMove(toParent: self)

    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
      hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    self.hostingController = hostingController
  }
}
