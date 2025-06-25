import SwiftUI
import UIKit

@available(iOS 14.0, *)
public class PaymentViewController: UIViewController {
  private let data: [String: Any]
  private let onCompletion: (PaymentResult) -> Void
  private var hostingController: UIHostingController<PaymentWebView>?

  public init(data: [String: Any], onCompletion: @escaping (PaymentResult) -> Void) {
    self.data = data
    self.onCompletion = onCompletion
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    setupPaymentWebView()
  }

  private func setupPaymentWebView() {
    guard let paymentWebView = PaymentWebView(data: data, onCompletion: onCompletion)
    else {
      return
    }
    let hostingController = UIHostingController(rootView: paymentWebView)

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
