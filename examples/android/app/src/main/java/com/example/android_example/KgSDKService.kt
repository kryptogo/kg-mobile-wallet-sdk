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
    private val engineName = "flutter_engine"


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
                .put(engineName, flutterEngine!!)
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
        val intent = CustomFlutterActivity.withCachedEngine(engineName).build(context)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

    fun callKgSDK(funcName: String){
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
}

class CustomFlutterActivity : FlutterActivity() {
    private val channelName = "com.kryptogo.sdk/channel"
    // Assume sharedSecret is a nullable String that might have been obtained elsewhere
    var sharedSecret: String? = null
    var YOUR_CLIENT_ID = "def3b0768f8f95ffa0be37d0f54e2064"
    var YOUR_CLIENT_TOKEN = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImRlbW8ta2V5IiwidHlwIjoiSldUIn0.eyJhdWQiOiJodHRwczovL2tyeXB0b2dvLmNvbSIsImV4cCI6MjAyNzQwOTg2MiwiaXNzIjoiaHR0cHM6Ly9hdXRoLmtyeXB0b2dvLmNvbSIsInN1YiI6InRlc3QtdXNlciJ9.Kmbblm_cUJNpoRImSRQmb83ljY35Kn-ZcA5SBy5WOPqqL6T42YVDJFMyOAp05j3aFfUIZxCOqQAFuT23bC53jZM9SOZjz9cmwqHOE6D9wzk6Y2gwdOABSIeEet2nGzXfoHcPR1GLXJYdnOWYdh9ZivE4dtH4wGRO-eiOUoJX_kxSunBk1XanG6T3BcCDduEd-jxHTBSoi2fcMU_KfDVA9ZTc3kwzzYq3qQUMu8lBIBUQYqeV3S4M29AMn1gUAlP5Z1oKuQZzYEM3jLxAkN9hls1fMavsfi2VGYK87UE7THyWmTgMU9BDNzk3DrT7Wcxc1DOhwotyrTtep8BQkjsCJw"

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
                "closeSdkView" -> {
                    closeSdkView()
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

        channel.invokeMethod("init", initParam)
    }

    private fun closeSdkView() {
        finish()
    }
}
