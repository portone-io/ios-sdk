public struct PaymentSuccess: Equatable {
  public let txId: String
  public let paymentId: String
}

public enum PaymentError: Error, Equatable {
  /// 결제가 실패한 경우
  case failed(
    txId: String, paymentId: String, code: String, message: String?, pgCode: String?,
    pgMessage: String?)

  /// 결제 요청 파라미터가 잘못된 경우
  case invalidArgument(message: String)

  /// 알 수 없는 오류로 인한 실패
  case unknown(message: String)
}

public typealias PaymentResult = Result<PaymentSuccess, PaymentError>
