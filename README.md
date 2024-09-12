# KryptoGO Mobile Wallet SDK

[![GitHub](https://img.shields.io/badge/GitHub-KryptoGO%20Mobile%20Wallet%20SDK-blue?style=flat-square&logo=github)](https://github.com/kryptogo/kg-mobile-wallet-sdk)

## KryptoGO Mobile Wallet SDK allows dapps to integrate KryptoGO wallet functionality

1. [KryptoGO Mobile Wallet SDK](https://github.com/kryptogo/kg-mobile-wallet-sdk)
   - [Documentation](https://dora-xies-organization.gitbook.io/KryptoGO Mobile Wallet SDK-doc)
2. Supported platforms:
   - iOS
   - Android

### Features

- Quick Integration and Easy Configuration
- Security and Compliance
- Technical Support and Community
- On-chain Asset Data
- On-chain Transaction Records
- Asset Transfer
- Token Swap
- Password Backup
- SSS Fragmentation Protection Mechanism
- Multi-Chain Support (Bitcoin, Ethereum, Polygon, Arbitrum, Solana, TRON, KuCoin Community Chain, Ronin, Oasys)

### Installing KryptoGO Mobile Wallet SDK

1. Clone the SDK repository:

   ```shell
   git clone https://github.com/kryptogo/kg-mobile-wallet-sdk.git
   ```

2. Place the KG_SDK directory into the root directory of your application.

3. Follow the specific configuration documents for iOS and Android to complete the setup.

### Basic Usage

1. Initialize SDK

   ```swift
   let sdk = KGSDK(
       appName: "Your App Name",
       clientId: "Your Client ID",
       clientToken: "Your Client Token",
       sharedSecret: "Optional Shared Secret"
   )
   ```

2. Configure initialization parameters:

   | Parameter | Type | Description |
   |-----------|------|-------------|
   | appName | String | The name of your application |
   | clientId | String | Your application's client ID provided by KryptoGO |
   | clientToken | String | Your application's client token for authentication |
   | sharedSecret | String? | (Optional) A secret key for enhanced recovery options |

3. Implement SDK features (example):

   ```swift
   // View on-chain asset data
   sdk.getAssetData { result in
       // Handle result
   }

   // Perform asset transfer
   sdk.transferAsset(to: "recipient_address", amount: "1.0", token: "ETH") { result in
       // Handle result
   }

   // Implement token swap
   sdk.swapTokens(from: "ETH", to: "USDT", amount: "1.0") { result in
       // Handle result
   }
   ```

### Security Features

KryptoGO Mobile Wallet SDK employs advanced protection mechanisms:

- Password Backup
- SSS Fragmentation Protection Mechanism

### Multi-Chain Support

KryptoGO Mobile Wallet SDK supports several blockchain networks:

- Bitcoin
- Ethereum
- Polygon
- Arbitrum
- Solana
- TRON
- KuCoin Community Chain
- Ronin
- Oasys

### Sample Projects and SDK Files

#### Android Sample
The Android sample project is located in the `examples/android` directory. It's a standard Android project built with Gradle. The main application code can be found in `app/src/main`.

#### iOS Sample
The iOS sample project is located in the `examples/ios` directory. It's a standard iOS project managed with Xcode and CocoaPods. Key files include `ContentView.swift` (main SwiftUI view), `KgSDKService.swift` (KryptoGO SDK service wrapper), and `VerifyPageView.swift` and `VerifyPageViewController.swift` (verification page code).

#### SDK Files
SDK files are located in the `sdk` directory, divided into Android and iOS subdirectories. The Android SDK files are in `sdk/android/repo`, while the iOS SDK files are in `sdk/ios/Flutter`, containing framework files for Debug, Profile, and Release configurations.

### Usage

Refer to the code in each platform's sample project to understand how to integrate and use the KryptoGO SDK. Ensure that you have set up the development environment correctly before running the sample projects. For the iOS project, run `pod install` to install the necessary dependencies.

For more detailed information and advanced usage, please refer to our [official documentation](https://dora-xies-organization.gitbook.io/KryptoGO Mobile Wallet SDK-doc) or contact technical support.
