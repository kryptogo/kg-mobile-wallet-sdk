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
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

class KgSDKService private constructor(private val context: Context) {
    private var flutterActivity: FlutterActivity? = null
    private var openVerifyPageCallback: ((result: MethodChannel.Result) -> Unit)? = null
    private val YOUR_CLIENT_ID = "def3b0768f8f95ffa0be37d0f54e2064"

    companion object {
        private var instance: KgSDKService? = null
        private var appContext: Context? = null
        private var flutterEngine: FlutterEngine? = null
        private var methodChannel: MethodChannel? = null
        private const val channelName = "com.kryptogo.sdk/channel"
        private const val engineName = "flutter_engine"

        fun initialize(@NonNull context: Context) {
            if (appContext == null) {
                appContext = context.applicationContext
                initializeFlutterEngine(appContext!!)
            }
        }

        fun getInstance(): KgSDKService {
            if (instance == null) {
                if (appContext == null) {
                    throw IllegalStateException("KgSDKService is not initialized. Call initialize() with a Context first.")
                }
                instance = KgSDKService(appContext!!)
            }
            return instance!!
        }

        private fun initializeFlutterEngine(context: Context) {
            if (flutterEngine == null) {
                flutterEngine = FlutterEngine(context)
                flutterEngine!!.dartExecutor.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault()
                )
                FlutterEngineCache
                    .getInstance()
                    .put(engineName, flutterEngine!!)
                methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, channelName)
            }
        }
    }

    // Check if the SDK is ready
    suspend fun isReady(): Any? = suspendCancellableCoroutine { continuation ->
        methodChannel?.invokeMethod("isReady", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                continuation.resume(result)
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                continuation.resume(null) // You might want to throw an exception instead
            }
            override fun notImplemented() {
                continuation.resume(null) // You might want to throw an exception instead
            }
        })
    }

    // Navigate to a specific route
    suspend fun goRoute(route: String) {
        methodChannel?.invokeMethod("goRoute", route)
    }

    // Check if debug mode is enabled
    suspend fun kDebugMode(): Boolean = suspendCancellableCoroutine { continuation ->
        methodChannel?.invokeMethod("kDebugMode", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                when (result) {
                    is Boolean -> continuation.resume(result)
                    else -> continuation.resume(false)
                }
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                continuation.resume(false) // You might want to throw an exception instead
            }
            override fun notImplemented() {
                continuation.resume(false) // You might want to throw an exception instead
            }
        })
    }

    // Check if there's a local share key
    suspend fun hasLocalShareKey(): Boolean = suspendCancellableCoroutine { continuation ->
        methodChannel?.invokeMethod("hasLocalShareKey", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                when (result) {
                    is Boolean -> continuation.resume(result)
                    else -> continuation.resume(false)
                }
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                continuation.resume(false) // You might want to throw an exception instead
            }
            override fun notImplemented() {
                continuation.resume(false) // You might want to throw an exception instead
            }
        })
    }

    // Check if a wallet has been created
    suspend fun isWalletCreated(): Boolean = suspendCancellableCoroutine { continuation ->
        methodChannel?.invokeMethod("isWalletCreated", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                when (result) {
                    is Boolean -> continuation.resume(result)
                    else -> continuation.resume(false)
                }
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                continuation.resume(false) // You might want to throw an exception instead
            }
            override fun notImplemented() {
                continuation.resume(false) // You might want to throw an exception instead
            }
        })
    }

    // Get the access token
    suspend fun getAccessToken(): Any? = suspendCancellableCoroutine { continuation ->
        methodChannel?.invokeMethod("getAccessToken", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                continuation.resume(result)
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                continuation.resume(null) // You might want to throw an exception instead
            }
            override fun notImplemented() {
                continuation.resume(null) // You might want to throw an exception instead
            }
        })
    }

    // Get the balance
    suspend fun getBalance(): Any? = suspendCancellableCoroutine { continuation ->
        methodChannel?.invokeMethod("getBalance", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                continuation.resume(result)
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                continuation.resume(null) // You might want to throw an exception instead
            }
            override fun notImplemented() {
                continuation.resume(null) // You might want to throw an exception instead
            }
        })
    }

    // Check the device
    suspend fun checkDevice(): Any? = suspendCancellableCoroutine { continuation ->
        methodChannel?.invokeMethod("checkDevice", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                continuation.resume(result)
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                continuation.resume(null) // You might want to throw an exception instead
            }
            override fun notImplemented() {
                continuation.resume(null) // You might want to throw an exception instead
            }
        })
    }

    fun sendInitParams(clientToken: String) {
        val initParam: MutableMap<String, Any> = mutableMapOf(
            "clientId" to YOUR_CLIENT_ID,
            "clientToken" to clientToken
        )
        methodChannel?.invokeMethod("initParams", initParam)
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
            throw Exception("Flutter engine is not initialized")
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
    }

    private fun closeSdkView() {
        finish()
    }
}
