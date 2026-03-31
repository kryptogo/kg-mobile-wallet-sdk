# KryptoGO Mobile Wallet SDK

[![GitHub](https://img.shields.io/badge/GitHub-KryptoGO%20Mobile%20Wallet%20SDK-blue?style=flat-square&logo=github)](https://github.com/kryptogo/kg-mobile-wallet-sdk)

## Overview

KryptoGO Mobile Wallet SDK allows native apps to integrate KryptoGO wallet functionality.

- [Documentation (Deprecated)](https://dora-xies-organization.gitbook.io/kg_sdk-doc)

## Table of Contents

- [KryptoGO Mobile Wallet SDK](#kryptogo-mobile-wallet-sdk)
  - [Overview](#overview)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Supported Platforms](#supported-platforms)
  - [Prerequisites](#prerequisites)
  - [Installing KryptoGO Mobile Wallet SDK](#installing-kryptogo-mobile-wallet-sdk)
  - [Configure initialization parameters:](#configure-initialization-parameters)
  - [SDK Methods](#sdk-methods)
    - [Methods to Handle SDK Requests](#methods-to-handle-sdk-requests)
    - [SDK Methods Available to Users](#sdk-methods-available-to-users)
  - [SDK Flow Overview](#sdk-flow-overview)
    - [1. SDK Initialization](#1-sdk-initialization)
    - [2. SSS Wallet Creation](#2-sss-wallet-creation)
    - [3. SSS Key Fragment Retrieval](#3-sss-key-fragment-retrieval)
    - [4. SSS Backup Failure Handling](#4-sss-backup-failure-handling)
    - [5. Transaction Verification](#5-transaction-verification)
  - [Security Features](#security-features)
  - [Multi-Chain Support](#multi-chain-support)
  - [Sample Projects and SDK Files](#sample-projects-and-sdk-files)
    - [Android Sample](#android-sample)
    - [iOS Sample](#ios-sample)
    - [SDK Files](#sdk-files)
## Features
- Quick Integration and Easy Configuration
- Security and Compliance
- Technical Support and Community
- On-chain Asset Data
- On-chain Transaction Records
- Asset Transfer
- Token Swap
- Password Backup
- SSS Fragmentation Protection Mechanism
- Multi-Chain Support

## Supported Platforms
- iOS
- Android

## Prerequisites
- iOS 14.0+
- Android 5.0+


## Installing KryptoGO Mobile Wallet SDK

### 1. Clone the repository

```shell
git clone https://github.com/kryptogo/kg-mobile-wallet-sdk.git
```

### 2. iOS Setup

**Prerequisites:** Xcode 15+, CocoaPods, iOS 14.0+ target

#### a. Add Flutter pod

In your app's `Podfile`, add the Flutter pod pointing to the SDK:

```ruby
pod 'Flutter', :podspec => '<path-to-sdk>/sdk/ios/Release/Flutter.podspec'
```

Then run:
```bash
pod install
```

#### b. Add SDK frameworks to Xcode project

1. In Xcode, select your app target → **General** → **Frameworks, Libraries, and Embedded Content**
2. Click **+** → **Add Other...** → **Add Files...**
3. Navigate to `sdk/ios/Release/` (or `Debug/` for debug builds) and add ALL `.xcframework` files:
   - `App.xcframework`
   - `FlutterPluginRegistrant.xcframework`
   - `flutter_secure_storage.xcframework`
   - `sentry_flutter.xcframework`
   - `package_info.xcframework`
   - `package_info_plus.xcframework`
   - ... (all other xcframeworks in the directory)
4. Set each framework to **Embed & Sign**

#### c. Configure Framework Search Paths

In your target's **Build Settings** → **Framework Search Paths**, add:

```
$(PROJECT_DIR)/<relative-path-to-sdk>/sdk/ios/$(CONFIGURATION)/
```

`$(CONFIGURATION)` is an Xcode variable that automatically resolves to `Debug`, `Release`, or `Profile` based on your build scheme.

#### d. Required Xcode build settings

| Setting | Value | Reason |
|---------|-------|--------|
| ENABLE_USER_SCRIPT_SANDBOXING | NO | Required for Flutter framework build scripts |
| Minimum Deployments | iOS 14.0+ | SDK minimum requirement |

#### e. Open workspace (not project)

After `pod install`, always open the `.xcworkspace` file, not `.xcodeproj`:

```bash
open YourApp.xcworkspace
```

### 3. Android Setup

**Prerequisites:** Android Studio, Android SDK API 21+, Java 11, NDK

#### a. Add Maven repositories

In your root `settings.gradle.kts` (or `build.gradle`), add:

```kotlin
dependencyResolutionManagement {
    repositories {
        // ... existing repos
        maven(url = "https://storage.googleapis.com/download.flutter.io")
        maven(url = "<path-to-sdk>/sdk/android/repo")
    }
}
```

#### b. Add SDK dependencies

In your app's `build.gradle.kts`:

```kotlin
dependencies {
    debugImplementation("com.kryptogo.kg_sdk:flutter_debug:1.0")
    releaseImplementation("com.kryptogo.kg_sdk:flutter_release:1.0")
    add("profileImplementation", "com.kryptogo.kg_sdk:flutter_profile:1.0")
}
```

#### c. Configure build settings

```kotlin
android {
    defaultConfig {
        minSdk = 21  // or higher
        ndk {
            abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a", "x86_64"))
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
}
```

### 4. Running the Example Apps

#### iOS Example
```bash
cd examples/ios
pod install
open ios_example.xcworkspace
# In Xcode: select simulator or device → Build & Run (Cmd+R)
```

#### Android Example
```bash
cd examples/android
./gradlew installDebug
# Or open in Android Studio and run
```

Both example apps include test credentials for the dev environment — no additional configuration needed.


## Configure initialization parameters:

   | Parameter   | Type   | Description                                        |
   | ----------- | ------ | -------------------------------------------------- |
   | clientId    | String | Your application's client ID provided by KryptoGO  |
   | clientToken | String | Your application's user token for authentication |

## The Format of the shared secret

```
timestamp:secret
```

The shared secret is a string which is combined by 2 parts:
- The first part is the version, timestamp.
- The second part is the secret.


## SDK Methods

### Methods to Handle SDK Requests

| Method Name | Description | Parameters | Return Value |
|-------------|-------------|------------|--------------|
| updateSharedSecret | Updates the shared secret used in Shamir's Secret Sharing (SSS) scheme. You need ensure that the sharedSecret is saved in your own database. This is crucial for updating the user's private key fragment stored on the device. | sharedSecret: String | Bool |
| requestSharedSecret | SDK requests a shared secret (private key fragment) with reason from the app. This is a critical part of the SSS scheme, allowing the SDK to reconstruct the full private key when needed. | reason:<br>• INVALID_DEVICE: user device is not consistent<br>• NO_LOCAL_SECRET: no local share key<br>• INVALID_LOCAL_SECRET: local share key is invalid | String |
| clearSharedSecret | Clears the stored shared secret (private key fragment) from your own database. This might be used during account deletion or account reset procedures. | version: String | Bool |
| openVerifyPage | Opens a verification page, typically used when the SDK needs to verify the user's identity before performing sensitive operations related to SSS. | None | Bool |
| closeSdkView | Closes the current SDK view. | None | None |

### SDK Methods Available to Users

| Method Name | Description | Parameters | Return Value | Error Code |
|-------------|-------------|------------|--------------|------------|
| init | An asynchronous method that initializes SDK data and authenticates the KryptoGO wallet account.<br><font color=#FF0000>\*This method should be called first before other methods. | {<br>clientId: String,<br>clientToken: String<br>} | Success: {success: true}<br>Fail: {<br>success: false,<br>reason: INVALID_DEVICE / NO_LOCAL_SECRET / INVALID_LOCAL_SECRET<br>} | • ARGUMENT_ERROR<br>• CONFIG_ERROR<br>• NETWORK_ERROR<br>• API_ERROR<br>• WALLET_RESTORATION_ERROR<br>• UNKNOWN_ERROR |
| isReady | Verifies whether the SDK is fully initialized and ready for use, including the setup of SSS components.<br><font color=#FF0000>\*This method should be called to check before open the SDK view. | None | Bool | None |
| checkDevice | Performs user device verification to check if the current device is consistent. | None | Bool | • NOT_READY<br>• NETWORK_ERROR<br>• API_ERROR<br>• UNKNOWN_ERROR |
| isWalletCreated | Verifies if a wallet has been created for the current user | None | Bool | • NOT_READY<br>• UNKNOWN_ERROR |
| getBalance | Retrieves the current balance of the user's wallet. | None | String | • NOT_READY<br>• NETWORK_ERROR<br>• API_ERROR<br>• UNKNOWN_ERROR |
| refreshSharedSecret | Refreshes the shared secret (private key fragment) stored on the device. This might be done periodically for security reasons or when the user wants to update their key shares. | secret: String | Bool | • ARGUMENT_ERROR<br>• NETWORK_ERROR<br>• API_ERROR<br>• SECRET_VERSION_ERROR<br>• SECRET_BACKUP_ERROR<br>• WALLET_RESTORATION_ERROR<br>• UNKNOWN_ERROR |
| openView | Navigates to a specific view within the SDK's interface. Available locations:<br>• "/receive_address"<br>• "/send_token/select_token"<br>• "/swap" | location: String | None | • ARGUMENT_ERROR<br>• NOT_READY<br>• UNKNOWN_ERROR |

### Error Code
#### Common
 - INVALID_ARGUMENT: Invalid argument provided to the method.
 - NOT_READY: SDK is not initialized or not ready for operations.
 - NETWORK_ERROR: Network-related error, such as inability to connect to the server or unstable connection.
 - API_ERROR: API request failed, possibly due to server returning an error status code or data format issues.
 - UNKNOWN_ERROR: Unknown error occurred.
#### Initialization
 - CONFIG_ERROR: SDK initialization configuration error.

#### Share Secret / Wallet Restoration
 - SECRET_VERSION_ERROR: Shared secret version mismatch or error, leading to refresh or update failure.
 - SECRET_BACKUP_ERROR: Error occurred during the backup process of the shared secret, possibly due to cloud or local backup failure.
 - WALLET_RESTORATION_ERROR: Error occurred during the wallet restoration process.



## SDK Flow Overview

The KryptoGO Mobile Wallet SDK interacts with your app through several key flows:

### 1. SDK Initialization
The app calls `init` with the `clientId` and `clientToken`. The SDK will initiate the configuration and wallet login process.
It will return `{success: true}` when success, or `{success: false, reason: reason}` with reason or Error when failed.
It then checks if the SDK is ready using `isReady()`.

![SDK Initialization](/asseets/flow_init.png)


### 2. Check device consistency
The app calls `checkDevice()` to verify if the current device is consistent.
It will return `true` when success, or Error when failed.

![Check Device](/asseets/flow_check_device.png)


### 3. Check if wallet is created
The app calls `isWalletCreated()` to check if the wallet is created.
It will return `true` when success, or Error when failed.

![Check if wallet is created](/asseets/flow_is_wallet_created.png)

### 4. Get balance
The app calls `getBalance()` to get the balance of the wallet.
It will return the balance of the wallet, or Error when failed.

![Get Balance](/asseets/flow_get_balance.png)

### 5. SSS Backup refreshing
The app can call refreshSharedSecret and pass the original backed up secret to request the SDK to refresh SSS key fragments and re-backup.
It will return new version of secret when success, or Error when failed.

![SSS Backup Refreshing](/asseets/flow_refresh_shared_secret.png)

### 6. Transaction Verification

Before signing transactions, the SDK calls `openVerifyPage` with transaction type. If the user successfully verifies in the app, it returns `true` to the SDK.

![Transaction Verification](/asseets/flow_open_verify_page.png)



## Security Features

KryptoGO Mobile Wallet SDK employs advanced protection mechanisms:

- Password Backup
- SSS Fragmentation Protection Mechanism

## Multi-Chain Support

KryptoGO Mobile Wallet SDK supports several blockchain networks:

- Bitcoin
- Ethereum
- Polygon
- Arbitrum
- Solana
- TRON
- Ronin
- Oasys

## Sample Projects and SDK Files

### Android Sample
The Android sample project is located in the `examples/android` directory. It's a standard Android project built with Gradle. The main application code can be found in `app/src/main`.

### iOS Sample
The iOS sample project is located in the `examples/ios` directory. It's a standard iOS project managed with Xcode and CocoaPods. Key files include `ContentView.swift` (main SwiftUI view), `KgSDKService.swift` (KryptoGO SDK service wrapper), and `VerifyPageView.swift` and `VerifyPageViewController.swift` (verification page code).

### SDK Files
SDK files are located in the `sdk` directory, divided into Android and iOS subdirectories. The Android SDK files are in `sdk/android/repo`, while the iOS SDK files are in `sdk/ios/Flutter`, containing framework files for Debug, Profile, and Release configurations.

