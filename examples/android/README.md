# Kotlin Example

# Open SDK Screen
Before using KG_SDK, you need to import the ~[KgSDKService.kt](https://dora-xies-organization.gitbook.io/kg_sdk-doc/kg_sdk/open-sdk-screen-1/kgsdkservice.kt)~ file into your Android application. This file will help you quickly start and effectively integrate KG_SDK.
# [](https://dora-xies-organization.gitbook.io/kg_sdk-doc/kg_sdk/open-sdk-screen-1#setting-up-the-kg_sdk-service)Setting Up the KG_SDK Service
To integrate the KG_SDK into your Android application, begin by setting up the service in your main application class. Below is an example configuration using Kotlin in an Android environment:
```kotlin
package com.example.android_example

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MainApplication : android.app.Application() {
    lateinit var flutterEngine : FlutterEngine

    override fun onCreate() {
        super.onCreate()
        KgSDKService.getInstance(this)
    }
}
```
This code snippet demonstrates how to create a FlutterEngine and initialize the KgSDKService within an Android application. This setup is essential for enabling Flutter capabilities within your native Android app.
# [](https://dora-xies-organization.gitbook.io/kg_sdk-doc/kg_sdk/open-sdk-screen-1#open-kg_sdk-screen)Open KG_SDK Screen
To display the KG_SDK interface, call the showKgSDK method from the context where you need the SDK functionality. Here is a simple method call:
Copy
KgSDKService.getInstance(context).showKgSDK()
This function triggers the KG_SDK's user interface, allowing the user to interact with the features provided by the SDK, such as wallet services and transaction interfaces.
# [](https://dora-xies-organization.gitbook.io/kg_sdk-doc/kg_sdk/open-sdk-screen-1#supported-functions-in-kg_sdk)Supported Functions in KG_SDK
**[](https://dora-xies-organization.gitbook.io/kg_sdk-doc/kg_sdk/open-sdk-screen-1#interacting-with-kg_sdk)Interacting with KG_SDK**
The KG_SDK provides a flexible API that allows you to call specific functions using the service's method channel. You can handle the results directly within the callback functions. Below is an example of how to invoke a function and handle its result:
KG_SDK offers a variety of functions that can be called using the funcName parameter within your app. These functions enable you to perform different operations related to blockchain and wallet management. Here is a list of some commonly used functions and their purposes:
* **getBalance**: Retrieves the current balance of the user's wallet. This function is ideal for quickly checking how much funds are available in the wallet.

```kotlin
fun callKgSDK(funcName: String): String{
    methodChannel?.invokeMethod(funcName, null, object : MethodChannel.Result {
        override fun success(@Nullable result: Any?) {
            print(result)
        }

        override fun error(
            errorCode: String,
            @Nullable errorMessage: String?,
            @Nullable errorDetails: Any?
        ) {
            print("error")
        }

        override fun notImplemented() {
            print("not implemented")
        }
    })
}
```

# KgSDKService.kt
### Function should be Implement


| name | desc | return type |
|---|---|---|
| updateSharedSecret | updateSharedSecret to your storage | Copy<br>(sharedSecret: String?) -> Bool |
| fetchSharedSecret | get sharedSecret to from your storage | Copy<br>() -> String? |
### Parameter should be update


| name | desc |
|---|---|
| clientId | clientId from KryptoGO Studio |
| clientToken | clientToken from your own service |


```kotlin
package com.example.android_example

import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class KgSDKService private constructor(private val context: Context) {
    private var flutterActivity: FlutterActivity? = null
    private var methodChannel: MethodChannel? = null
    private var openVerifyPageCallback: ((result: MethodChannel.Result) -> Unit)? = null
    private var flutterEngine: FlutterEngine? = null
    private val channelName = "com.kryptogo.sdk/channel"


    companion object {
        private var instance: KgSDKService? = null
        fun getInstance(@NonNull context: Context): KgSDKService {
            if (instance == null) {
                instance = KgSDKService(context)
            }
            return instance!!
        }
    }


    init {
        if (flutterEngine == null) {
            flutterEngine = FlutterEngine(context)
            // Initialize your Flutter engine here
            flutterEngine!!.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
            // Cache the FlutterEngine to be used by FlutterActivity or FlutterFragment
            FlutterEngineCache
                .getInstance()
                .put("flutter_engine", flutterEngine!!)
            val channel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, channelName)
            this.methodChannel = channel
        }
    }




    private fun initializeFlutterActivity(flutterEngine: FlutterEngine) {
        flutterActivity  = CustomFlutterActivity()
    }

    fun fetchSharedSecret(): String? {
        // Get a reference to the shared preferences
        val sharedPreferences = context.getSharedPreferences("MyAppPreferences", Context.MODE_PRIVATE)
        // Return the shared secret from the shared preferences
        return sharedPreferences.getString("sharedSecret", null)
    }

    fun updateSharedSecret(sharedSecret: String?): Boolean {
        // Get a reference to the shared preferences
        val sharedPreferences = context.getSharedPreferences("MyAppPreferences", Context.MODE_PRIVATE)

        // Check if the sharedSecret is not null
        if (sharedSecret != null) {
            // Start a SharedPreferences editor
            val editor = sharedPreferences.edit()

            // Put the shared secret into the shared preferences
            editor.putString("sharedSecret", sharedSecret)

            // Apply changes asynchronously
            editor.apply()

            // Return true indicating the sharedSecret was updated successfully
            return true
        } else {
            // Optionally handle the case where sharedSecret is null, e.g., by removing the entry
            val editor = sharedPreferences.edit()
            editor.remove("sharedSecret")
            editor.apply()

            // Return false to indicate no update was made due to null input
            return false
        }
    }

    fun setOpenVerifyPageCallback(callback: ((result: MethodChannel.Result) -> Unit)?) {
        openVerifyPageCallback = callback
    }

    fun showKgSDK() {
        if(flutterEngine == null) {
            throw  Exception()
        }

        initializeFlutterActivity(flutterEngine!!)
        val intent = CustomFlutterActivity.withCachedEngine("flutter_engine").build(context)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

    fun callKgSDK() {
        methodChannel?.invokeMethod("testString", null, object : MethodChannel.Result {
            override fun success(@Nullable result: Any?) {
                print(result)
            }

            override fun error(
                errorCode: String,
                @Nullable errorMessage: String?,
                @Nullable errorDetails: Any?
            ) {
                print("error")
            }

            override fun notImplemented() {
                print("not implemented")
            }
        })
    }
}

class CustomFlutterActivity : FlutterActivity() {
    private val channelName = "com.kryptogo.sdk/channel"
    // Assume sharedSecret is a nullable String that might have been obtained elsewhere
    var sharedSecret: String? = null
    var YOUR_CLIENT_ID = "$YOUR_CLIENT_ID"
    var YOUR_CLIENT_TOKEN = "$YOUR_CLIENT_TOKEN"

    companion object {
        fun withCachedEngine(engineId: String) = CustomCachedEngineIntentBuilder(engineId)
    }

    class CustomCachedEngineIntentBuilder(engineId: String) :
        CachedEngineIntentBuilder(CustomFlutterActivity::class.java, engineId)

    fun fetchSharedSecret(): String? {
        // Get a reference to the shared preferences
        val sharedPreferences = context.getSharedPreferences("MyAppPreferences", Context.MODE_PRIVATE)
        // Return the shared secret from the shared preferences
        return sharedPreferences.getString("sharedSecret", null)
    }

    fun updateSharedSecret(sharedSecret: String?): Boolean {
        // Get a reference to the shared preferences
        val sharedPreferences = context.getSharedPreferences("MyAppPreferences", Context.MODE_PRIVATE)

        // Check if the sharedSecret is not null
        if (sharedSecret != null) {
            // Start a SharedPreferences editor
            val editor = sharedPreferences.edit()

            // Put the shared secret into the shared preferences
            editor.putString("sharedSecret", sharedSecret)

            // Apply changes asynchronously
            editor.apply()

            // Return true indicating the sharedSecret was updated successfully
            return true
        } else {
            // Optionally handle the case where sharedSecret is null, e.g., by removing the entry
            val editor = sharedPreferences.edit()
            editor.remove("sharedSecret")
            editor.apply()

            // Return false to indicate no update was made due to null input
            return false
        }
    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        sharedSecret = fetchSharedSecret()
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
        var initParam: MutableMap<String, Any> = mutableMapOf(
            "appName" to "TWMTEST",
            "walletConfig" to mapOf(
                "maxWallet" to 100,
                "enableAutoSssSignUp" to true,
                "enableSSS" to true,
                "allRpcs" to listOf("ethereum")
            ),
            "themeData" to mapOf(
                "primaryValue" to "FFFFC211"
            ),
            "flavorEnum" to "dev", // Initial flavor setting
            "clientId" to "$YOUR_CLIENT_ID",
            "clientToken" to "$YOUR_CLIENT_TOKEN"
        )

        // Conditionally add the sharedSecret if it is not null
        sharedSecret?.let {
            initParam["sharedSecret"] = it
        }

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "closeFlutterView" -> {
                    closeFlutterView()
                    result.success(null)
                }
                "openVerifyPage" -> {
                    // Implement another method call
                    result.success(true)
                }
                "updateSharedSecret" -> {
                    val sharedSecret = (call.arguments as? Map<String, String>)?.get("sharedSecret")
                    val isSuccess = updateSharedSecret(sharedSecret)
                    result.success(isSuccess)
                }
                // Add more cases as necessary
                else -> {
                    result.notImplemented()
                }
            }
        }

        channel.invokeMethod("getInitialParam", initParam)
    }

    private fun closeFlutterView() {
        finish()
    }
}
```