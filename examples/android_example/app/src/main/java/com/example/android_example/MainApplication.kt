package com.example.android_example

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MainApplication : android.app.Application() {
    lateinit var flutterEngine : FlutterEngine


    override fun onCreate() {
        super.onCreate()
        var service = KgSDKService.getInstance(this)
    }

}