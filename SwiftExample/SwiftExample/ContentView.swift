import PortOneSdk
import SwiftUI

struct AlertInfo: Identifiable {
  let id = UUID()
  let title: String
  let message: String
}

// 테스트에 사용할 실제 storeId와 channelKey를 입력합니다.
let storeId = "store-00000000-0000-0000-0000-000000000000"
let channelKey = "channel-key-00000000-0000-0000-0000-000000000000"

struct ContentView: View {
  @State private var showPaymentSheet = false
  @State private var paymentResult: PaymentResult? = nil

  @State private var showIssueBillingKeySheet = false
  @State private var issueBillingKeyResult: IssueBillingKeyResult? = nil

  @State private var showIdentityVerificationSheet = false
  @State private var identityVerificationResult: IdentityVerificationResult? = nil

  @State private var alertInfo: AlertInfo? = nil

  var body: some View {
    VStack {
      Button(
        action: {
          showPaymentSheet = true
        },
        label: {
          Text("결제 테스트")
            .frame(maxWidth: .infinity)
        }
      )
      .buttonStyle(.bordered)
      Button(
        action: {
          showIssueBillingKeySheet = true
        },
        label: {
          Text("빌링키 발급 테스트")
            .frame(maxWidth: .infinity)
        }
      )
      .buttonStyle(.bordered)
      Button(
        action: {
          showIdentityVerificationSheet = true
        },
        label: {
          Text("본인인증 테스트")
            .frame(maxWidth: .infinity)
        }
      )
      .buttonStyle(.bordered)
    }
    .padding()
    .alert(item: $alertInfo) { alertInfo in
      Alert(title: Text(alertInfo.title), message: Text(alertInfo.message))
    }
    .sheet(
      isPresented: $showPaymentSheet,
      onDismiss: {
        if let result = paymentResult {
          switch result {
          case .success(let payment):
            alertInfo = AlertInfo(title: "결제 성공", message: "\(payment)")
            break
          case .failure(
            .failed(
              txId: _, paymentId: _, code: let code, message: let message, pgCode: _, pgMessage: _)):
            alertInfo = AlertInfo(title: "결제 실패", message: message ?? "PG사 코드: \(code)")
            break
          case .failure(.invalidArgument(message: let message)):
            alertInfo = AlertInfo(title: "잘못된 결제 요청", message: message)
            break
          case .failure(.unknown(message: let message)):
            alertInfo = AlertInfo(title: "알 수 없는 오류", message: message)
            break
          }
        }
      },
      content: {
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

        PaymentWebView(
          request: request,
          onCompletion: { result in
            DispatchQueue.main.async {
              paymentResult = result
              showPaymentSheet = false
            }
          })
      }
    ).sheet(
      isPresented: $showIssueBillingKeySheet,
      onDismiss: {
        if let result = issueBillingKeyResult {
          switch result {
          case .success(let billingKey):
            alertInfo = AlertInfo(title: "빌링키 발급 성공", message: "\(billingKey)")
            break
          case .failure(
            .failed(code: let code, message: let message, pgCode: _, pgMessage: _)):
            alertInfo = AlertInfo(title: "빌링키 발급 실패", message: message ?? "PG사 코드: \(code)")
            break
          case .failure(.invalidArgument(message: let message)):
            alertInfo = AlertInfo(title: "잘못된 빌링키 발급 요청", message: message)
            break
          case .failure(.unknown(message: let message)):
            alertInfo = AlertInfo(title: "알 수 없는 오류", message: message)
            break
          }
        }
      },
      content: {
        let request = IssueBillingKeyRequest(
          storeId: storeId,
          channelKey: channelKey,
          billingKeyMethod: BillingKeyMethod.CARD,
          issueName: "빌링키 발급 테스트",
          appScheme: "portoneexample://"
        )

        IssueBillingKeyWebView(
          request: request,
          onCompletion: { result in
            DispatchQueue.main.async {
              issueBillingKeyResult = result
              showIssueBillingKeySheet = false
            }
          })
      }
    ).sheet(
      isPresented: $showIdentityVerificationSheet,
      onDismiss: {
        if let result = identityVerificationResult {
          switch result {
          case .success(let identityVerification):
            alertInfo = AlertInfo(title: "본인인증 성공", message: "\(identityVerification)")
            break
          case .failure(
            .failed(
              identityVerificationTxId: _, identityVerificationId: _, code: let code,
              message: let message,
              pgCode: _, pgMessage: _)):
            alertInfo = AlertInfo(title: "본인인증 실패", message: message ?? "PG사 코드: \(code)")
            break
          case .failure(.invalidArgument(message: let message)):
            alertInfo = AlertInfo(title: "잘못된 본인인증 요청", message: message)
            break
          case .failure(.unknown(message: let message)):
            alertInfo = AlertInfo(title: "알 수 없는 오류", message: message)
            break
          }
        }
      },
      content: {
        let identityVerificationId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let request = IdentityVerificationRequest(
          storeId: storeId,
          identityVerificationId: identityVerificationId,
          channelKey: channelKey
        )

        IdentityVerificationWebView(
          request: request,
          onCompletion: { result in
            DispatchQueue.main.async {
              identityVerificationResult = result
              showIdentityVerificationSheet = false
            }
          })
      })
  }
}

#Preview {
  ContentView()
}
