# Add KG\_SDK to iOS

## Step 1: Add Flutter & SDK to Your Project

Initialize CocoaPods if not already in use:

```bash
pod init
```

Update your `Podfile` to include the KG\_SDK dependency, substituting your build configuration:

```ruby
build_mode = ENV['BUILD_MODE'] || 'Debug'

pod 'KG_SDK', :podspec => "some/path/kg_sdk/ios_sdk/Flutter/#{build_mode}/KG_SDK.podspec"
```

## Step 2: Link the Frameworks

### Disable User Script Sandbox

Navigate to **Build Setting > Build Options** and add these configurations:

```
//:configuration = Debug
ENABLE_USER_SCRIPT_SANDBOXING = NO

//:configuration = Release
ENABLE_USER_SCRIPT_SANDBOXING = NO
```

### Link Binary With Libraries

In Xcode, go to **Build Settings > Build Phases > Link Binary With Libraries** and drag frameworks from `some/path/kg_sdk/ios_sdk/Flutter/#{build_mode}` to the Link Binary section.

Add `${PODS_ROOT}/Flutter` to the target's **Framework Search Paths**.

### Embed Frameworks

Select **Embed & Sign** for dynamic frameworks, which will then appear under Embed Frameworks within Build Phases.

## Next Steps

- [Open SDK Screen](open-sdk-screen.md)
