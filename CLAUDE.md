# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Building the SDK
```bash
# Build the Swift package
swift build

# Build in release mode
swift build -c release
```

### Running Tests
```bash
# Run all tests
swift test

# Run tests with verbose output
swift test --verbose
```

### Testing with Example App
```bash
# Open the example project in Xcode
open SwiftExample/SwiftExample.xcodeproj

# Or build from command line (requires xcodebuild)
cd SwiftExample
xcodebuild -project SwiftExample.xcodeproj -scheme SwiftExample -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Version Management
```bash
# Create a changeset for version updates
pnpm changeset

# Version packages based on changesets
pnpm changeset version

# Publish changes
pnpm changeset publish
```

## Architecture Overview

This iOS SDK provides SwiftUI components for integrating PortOne payment services. The SDK follows a WebView-based architecture where native iOS components wrap the PortOne JavaScript SDK.

### Core Components

1. **WebView Wrappers** - Each feature is implemented as a UIViewRepresentable that wraps WKWebView:
   - `PaymentWebView` - Handles payment transactions
   - `IssueBillingKeyWebView` - Manages recurring payment setup
   - `IdentityVerificationWebView` - Handles identity verification flows

2. **Result Types** - Each WebView has a corresponding Result type using Swift's Result enum:
   - `PaymentResult` - Contains transaction ID or specific error types
   - `IssueBillingKeyResult` - Contains billing key or error
   - `IdentityVerificationResult` - Contains verification data or error

3. **Coordinator Pattern** - Each WebView uses a Coordinator to:
   - Handle WKNavigationDelegate callbacks
   - Process JavaScript messages via WKScriptMessageHandler
   - Manage deep links to external payment apps
   - Execute completion handlers with results

### Key Design Patterns

- **Data Flow**: Configuration data → JSON serialization → JavaScript injection → WebView execution → Result callback
- **Error Handling**: Comprehensive error types for network issues, user cancellation, PG errors, and validation failures
- **Deep Linking**: Supports Korean payment apps (KakaoPay, NaverPay, bank apps) through URL scheme handling
- **Security**: Controlled navigation with specific redirect URL validation

### Integration Requirements

- **URL Schemes**: Apps must configure custom URL schemes in Info.plist for payment callbacks
- **Payment App Schemes**: Include LSApplicationQueriesSchemes for Korean payment apps
- **Credentials**: Valid PortOne storeId and channelKey required for API calls

### Development Considerations

- The SDK loads PortOne's browser SDK from CDN (https://cdn.portone.io/v2/browser-sdk.js)
- Debug builds enable WebView inspection (iOS 16.4+)
- All UI components require iOS 13+ for SwiftUI support
- Korean language comments indicate primary development team locale