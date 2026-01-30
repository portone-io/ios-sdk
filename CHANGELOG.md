# PortOneSdk

## 0.2.0

### Minor Changes

- a88175c: 코드젠 구현

  - 타입 안전한 요청, 응답 파라미터 타입 추가
  - JSONValue 타입 추가로 동적 JSON 데이터 처리 지원
  - 결제 수단별 상세 타입 추가 (Card, EasyPay, VirtualAccount, Transfer, Mobile 등)
  - PG사별 Bypass 옵션 타입 추가 (KCP, 토스페이먼츠, 나이스, 스마트로 등)
  - 본인인증, 빌링키 발급, 결제 요청/응답 타입 추가
  - PaymentWebView, IssueBillingKeyWebView, IdentityVerificationWebView 업데이트

## 0.1.3

### Patch Changes

- 625f694: Swift 6.0 문법에 맞지 않던 부분 수정

## 0.1.2

### Patch Changes

- 7d789a9: 결제 및 빌링키 등록 시 네이버페이 등 웹뷰 내 확인 창 대응

## 0.1.1

### Patch Changes

- 27c10c9: UIKit을 위한 ViewController 추가 및 예제 추가

## 0.1.0

### Minor Changes

- 800c0c7: 포트원 iOS SDK 첫 릴리스

  ### 주요 기능

  - **결제**: 포트원 V2 결제 시스템과 연동하여 iOS 앱에서 결제 기능 구현
  - **빌링키 발급**: 정기 결제를 위한 빌링키 발급 기능
  - **본인인증**: 사용자 본인인증 기능

  ### 기술 사양

  - iOS 13.0 이상 지원
  - Swift 6.0 이상 필요
  - SwiftUI 기반 WebView 구현
  - Swift Package Manager 지원

  ### 특징

  - 딥링크를 통한 외부 앱 연동
  - 타입 안전한 Result 타입 기반 에러 처리
