# Adding Wallet SDK to Your Android Project

## Installation Steps

### Step 1: Configure Flutter and SDK

1. Add the Flutter engine dependency in `settings.gradle.kts`:

   ```kotlin
   maven(url = "https://storage.googleapis.com/download.flutter.io")
   ```

2. Add the Flutter module dependency (assuming it's at the project root):

   ```kotlin
   maven(url = "path/to/repo")
   ```

3. Add the following configurations in `app/build.gradle.kts`:

   ```kotlin
   android {
     // Set minimum SDK version to 21
     defaultConfig {
       minSdk = 21
     }

     // Configure NDK
     ndk {
       abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86_64")
     }

     // Set Java 11 compatibility
     compileOptions {
       sourceCompatibility = JavaVersion.VERSION_11
       targetCompatibility = JavaVersion.VERSION_11
     }
   }

   kotlinOptions {
     jvmTarget = "11"
   }

   dependencies {
     debugImplementation("com.kryptogo.kg_sdk:flutter_debug:1.0")
     releaseImplementation("com.kryptogo.kg_sdk:flutter_release:1.0")
   }
   ```

### Step 2: Add FlutterActivity

Add the FlutterActivity in your `AndroidManifest.xml`:

```xml
<activity
android:name="io.flutter.embedding.android.FlutterActivity"
android:theme="@style/YourAppTheme"
android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
android:hardwareAccelerated="true"
android:windowSoftInputMode="adjustResize"
/>
```

Note: Replace `@style/YourAppTheme` with your application's theme.

After completing these steps, KG_SDK will be successfully added to your Android project.