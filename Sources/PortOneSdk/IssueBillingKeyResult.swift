public struct IssueBillingKeySuccess: Equatable {
  public let billingKey: String
}

public enum IssueBillingKeyError: Error, Equatable {
  /// 빌링키 발급이 실패한 경우
  case failed(
    billingKey: String, code: String, message: String?, pgCode: String?, pgMessage: String?)

  /// 빌링키 발급 요청 파라미터가 잘못된 경우
  case invalidArgument(message: String)

  /// 알 수 없는 오류로 인한 실패
  case unknown(message: String)
}

public typealias IssueBillingKeyResult = Result<IssueBillingKeySuccess, IssueBillingKeyError>
