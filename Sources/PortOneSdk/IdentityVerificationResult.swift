public struct IdentityVerificationSuccess: Equatable {
  public let identityVerificationTxId: String
  public let identityVerificationId: String
}

public enum IdentityVerificationError: Error, Equatable {
  /// 본인인증이 실패한 경우
  case failed(
    identityVerificationTxId: String, identityVerificationId: String, code: String,
    message: String?, pgCode: String?, pgMessage: String?)

  /// 본인인증 요청 파라미터가 잘못된 경우
  case invalidArgument(message: String)

  /// 알 수 없는 오류로 인한 실패
  case unknown(message: String)
}

public typealias IdentityVerificationResult = Result<
  IdentityVerificationSuccess, IdentityVerificationError
>
