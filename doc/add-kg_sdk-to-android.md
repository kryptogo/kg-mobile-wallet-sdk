# Add KG\_SDK to Android

## Step 1: Add Flutter & SDK to Your Project

In `settings.kts`, add the Flutter Engine dependency:

```kotlin
maven(url = "https://storage.googleapis.com/download.flutter.io")
```

Include the Flutter module dependency (using a relative path at the project root):

```kotlin
maven(url = "path/to/repo")
```

In `build.gradle.kts`, insert the following configuration:

```kotlin
ndk {
    abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86_64")
}
```

The minimum SDK version is `21`.

Enable Java 11 compatibility:

```kotlin
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
}
kotlinOptions {
    jvmTarget = "11"
}
```

Add the module dependencies:

```kotlin
debugImplementation 'com.kryptogo.kg_sdk:flutter_debug:1.0'
releaseImplementation 'com.kryptogo.kg_sdk:flutter_release:1.0'
```

## Step 2: Add FlutterActivity

In `AndroidManifest.xml`, register the FlutterActivity:

```xml
<activity
    android:name="io.flutter.embedding.android.FlutterActivity"
    android:theme="@style/your_theme"
    android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
    android:hardwareAccelerated="true"
    android:windowSoftInputMode="adjustResize"
/>
```

## Next Steps

- [Open SDK Screen](open-sdk-screen.md)
