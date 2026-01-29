import SwiftUI
import UIKit

@available(iOS 14.0, *)
public class IdentityVerificationViewController: UIViewController {
  private let request: IdentityVerificationRequest
  private let onCompletion: (IdentityVerificationResult) -> Void
  private var hostingController: UIHostingController<IdentityVerificationWebView>?

  public init(request: IdentityVerificationRequest, onCompletion: @escaping (IdentityVerificationResult) -> Void) {
    self.request = request
    self.onCompletion = onCompletion
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    setupIdentityVerificationWebView()
  }

  private func setupIdentityVerificationWebView() {
    let identityVerificationWebView = IdentityVerificationWebView(
      request: request, onCompletion: onCompletion)
    let hostingController = UIHostingController(rootView: identityVerificationWebView)

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
