# PortOne iOS SDK 예제

이 예제 프로젝트는 PortOne iOS SDK의 주요 기능을 시연합니다.

## 시작하기

### 1. 프로젝트 열기
```bash
open SwiftExample.xcodeproj
```

### 2. 설정 변경
`ContentView.swift` 파일에서 테스트용 인증 정보를 실제 값으로 변경합니다:

```swift
// 테스트에 사용할 실제 storeId와 channelKey를 입력합니다.
let storeId = "your-actual-store-id"
let channelKey = "your-actual-channel-key"
```

### 3. 실행
Xcode에서 빌드하고 실행합니다 (⌘+R).

## 기능

이 예제 앱은 세 가지 주요 기능을 포함합니다:

1. **결제 테스트**: 일반 결제 플로우를 테스트합니다.
2. **빌링키 발급 테스트**: 정기 결제를 위한 빌링키 발급을 테스트합니다.
3. **본인인증 테스트**: 본인인증 플로우를 테스트합니다.

## URL Scheme 설정

이 예제는 `portoneexample://` URL scheme을 사용합니다. 실제 앱에서는 고유한 URL scheme을 사용해야 합니다.

`Info.plist`에서 URL scheme 설정을 확인할 수 있습니다.

## 문제 해결

### 결제 앱이 열리지 않는 경우
1. 시뮬레이터가 아닌 실제 디바이스에서 테스트하세요.
2. 해당 결제 앱이 설치되어 있는지 확인하세요.
3. `Info.plist`에 해당 앱의 URL scheme이 등록되어 있는지 확인하세요.

### 결제 후 앱으로 돌아오지 않는 경우
1. URL scheme이 올바르게 설정되었는지 확인하세요.
2. `appScheme` 파라미터가 `Info.plist`의 설정과 일치하는지 확인하세요.

## 추가 정보

더 자세한 정보는 [메인 README](../README.md)를 참조하세요.