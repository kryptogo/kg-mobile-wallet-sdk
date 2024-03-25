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
        }
    }

    init {
//        initializeFlutterActivity(flutterEngine!!)
    }




    fun initializeFlutterActivity(flutterEngine: FlutterEngine) {
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
        flutterActivity  = CustomFlutterActivity()
        this.methodChannel = channel
        setUpMethodChannel()
    }

    private fun setUpMethodChannel() {
        methodChannel?.invokeMethod("getInitialParam", mapOf("flavor" to "prod"))

        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "closeFlutterView" -> flutterActivity?.finish()
                "openVerifyPage" -> openVerifyPageCallback?.invoke(result)
                else -> result.notImplemented()
            }
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
        methodChannel?.invokeMethod("testFuture", null, object : MethodChannel.Result {
            override fun success(@Nullable result: Any?) {
                print(result)
            }

            override fun error(
                errorCode: String,
                @Nullable errorMessage: String?,
                @Nullable errorDetails: Any?
            ) {
                // 方法调用错误处理
                print("error")

            }

            override fun notImplemented() {
                // 方法未实现处理
                print("not implemented")
            }
        })
    }
}
