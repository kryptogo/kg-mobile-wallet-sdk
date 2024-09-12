# Adding Wallet SDK to Your iOS Project

This guide explains how to integrate the KryptGO Mobile Wallet SDK into your iOS project.

## Installation

### Step 1: Add Flutter & SDK to your project

If you're not using CocoaPods, initialize it first:

```
bash
pod init
```


Then, add KG_SDK to your Podfile:

```
ruby
build_mode = ENV['BUILD_MODE'] || 'Debug'
pod 'KG_SDK', :podspec => "some/path/kg_sdk/ios_sdk/Flutter/#{build_mode}/KG_SDK.podspec"
```

Replace `some/path` with the actual path to the SDK files.

### Step 2: Link the frameworks

1. Disable User Script Sandbox:
   Go to Build Settings → Build Options and set:

   ```
   //:configuration = Debug
   ENABLE_USER_SCRIPT_SANDBOXING = NO

   //:configuration = Release
   ENABLE_USER_SCRIPT_SANDBOXING = NO
   ```

2. Link Binary With Libraries:
   - Go to Build Phases → Link Binary With Libraries
   - Drag the frameworks from `some/path/kg_sdk/ios_sdk/Flutter/#{build_mode}` to the Link Binary section

3. Add Framework Search Paths:
   In the target's build settings, add `${PODS_ROOT}/Flutter` to the Framework Search Paths

4. Embed Frameworks:
   - Select the added frameworks
   - Set them to "Embed & Sign" in the Embed column

## Usage

To open the SDK screen, use the appropriate method provided by the SDK. (Specific implementation details to be added)

## Support

For any issues or questions, please contact our support team.