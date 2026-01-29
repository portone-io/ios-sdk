import PortOneSdk
import UIKit

let storeId = "store-00000000-0000-0000-0000-000000000000"
let channelKey = "channel-key-00000000-0000-0000-0000-000000000000"

class ViewController: UIViewController {

  @IBOutlet weak var paymentButton: UIButton!
  @IBOutlet weak var billingKeyButton: UIButton!
  @IBOutlet weak var identityVerificationButton: UIButton!

  var paymentResult: PaymentResult?
  var issueBillingKeyResult: IssueBillingKeyResult?
  var identityVerificationResult: IdentityVerificationResult?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupButtons()
  }

  func setupButtons() {
    paymentButton.setTitle("결제 테스트", for: .normal)
    billingKeyButton.setTitle("빌링키 발급 테스트", for: .normal)
    identityVerificationButton.setTitle("본인인증 테스트", for: .normal)

    // paymentButton.backgroundColor = .systemFill
    // billingKeyButton.backgroundColor = .systemFill
    // identityVerificationButton.backgroundColor = .systemFill

    paymentButton.layer.cornerRadius = 8
    billingKeyButton.layer.cornerRadius = 8
    identityVerificationButton.layer.cornerRadius = 8

    paymentButton.setTitleColor(.white, for: .normal)
    billingKeyButton.setTitleColor(.white, for: .normal)
    identityVerificationButton.setTitleColor(.white, for: .normal)
  }

  @IBAction func paymentButtonTapped(_ sender: UIButton) {
    let paymentId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    let request = PaymentRequest(
      storeId: storeId,
      paymentId: paymentId,
      orderName: "결제 테스트",
      totalAmount: 1000,
      currency: Currency.KRW,
      payMethod: PaymentPayMethod.CARD,
      channelKey: channelKey,
      appScheme: "portoneexample://"
    )

    let paymentViewController = PaymentViewController(
      request: request,
      onCompletion: { [weak self] result in
        DispatchQueue.main.async {
          self?.paymentResult = result
          self?.dismiss(animated: true) {
            self?.handlePaymentResult()
          }
        }
      }
    )

    present(paymentViewController, animated: true)
  }

  @IBAction func billingKeyButtonTapped(_ sender: UIButton) {
    let request = IssueBillingKeyRequest(
      storeId: storeId,
      channelKey: channelKey,
      billingKeyMethod: BillingKeyMethod.CARD,
      issueName: "빌링키 발급 테스트",
      appScheme: "portoneexample://"
    )

    let billingKeyViewController = IssueBillingKeyViewController(
      request: request,
      onCompletion: { [weak self] result in
        DispatchQueue.main.async {
          self?.issueBillingKeyResult = result
          self?.dismiss(animated: true) {
            self?.handleBillingKeyResult()
          }
        }
      }
    )

    present(billingKeyViewController, animated: true)
  }

  @IBAction func identityVerificationButtonTapped(_ sender: UIButton) {
    let identityVerificationId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    let request = IdentityVerificationRequest(
      storeId: storeId,
      identityVerificationId: identityVerificationId,
      channelKey: channelKey
    )

    let identityVerificationViewController = IdentityVerificationViewController(
      request: request,
      onCompletion: { [weak self] result in
        DispatchQueue.main.async {
          self?.identityVerificationResult = result
          self?.dismiss(animated: true) {
            self?.handleIdentityVerificationResult()
          }
        }
      }
    )

    present(identityVerificationViewController, animated: true)
  }

  func handlePaymentResult() {
    guard let result = paymentResult else { return }

    let title: String
    let message: String

    switch result {
    case .success(let payment):
      title = "결제 성공"
      message = "\(payment)"
    case .failure(
      .failed(txId: _, paymentId: _, code: let code, message: let msg, pgCode: _, pgMessage: _)):
      title = "결제 실패"
      message = msg ?? "PG사 코드: \(code)"
    case .failure(.invalidArgument(message: let msg)):
      title = "잘못된 결제 요청"
      message = msg
    case .failure(.unknown(message: let msg)):
      title = "알 수 없는 오류"
      message = msg
    }

    showAlert(title: title, message: message)
  }

  func handleBillingKeyResult() {
    guard let result = issueBillingKeyResult else { return }

    let title: String
    let message: String

    switch result {
    case .success(let billingKey):
      title = "빌링키 발급 성공"
      message = "\(billingKey)"
    case .failure(.failed(code: let code, message: let msg, pgCode: _, pgMessage: _)):
      title = "빌링키 발급 실패"
      message = msg ?? "PG사 코드: \(code)"
    case .failure(.invalidArgument(message: let msg)):
      title = "잘못된 빌링키 발급 요청"
      message = msg
    case .failure(.unknown(message: let msg)):
      title = "알 수 없는 오류"
      message = msg
    }

    showAlert(title: title, message: message)
  }

  func handleIdentityVerificationResult() {
    guard let result = identityVerificationResult else { return }

    let title: String
    let message: String

    switch result {
    case .success(let identityVerification):
      title = "본인인증 성공"
      message = "\(identityVerification)"
    case .failure(
      .failed(
        identityVerificationTxId: _, identityVerificationId: _, code: let code, message: let msg,
        pgCode: _, pgMessage: _)):
      title = "본인인증 실패"
      message = msg ?? "PG사 코드: \(code)"
    case .failure(.invalidArgument(message: let msg)):
      title = "잘못된 본인인증 요청"
      message = msg
    case .failure(.unknown(message: let msg)):
      title = "알 수 없는 오류"
      message = msg
    }

    showAlert(title: title, message: message)
  }

  func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default))
    present(alert, animated: true)
  }
}
