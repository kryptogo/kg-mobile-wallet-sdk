package com.kryptogo.android_example

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MainApplication : android.app.Application() {
    lateinit var flutterEngine : FlutterEngine


    override fun onCreate() {
        super.onCreate()
        // warm up the KgSDKService
        KgSDKService.initialize(applicationContext)
    }

}