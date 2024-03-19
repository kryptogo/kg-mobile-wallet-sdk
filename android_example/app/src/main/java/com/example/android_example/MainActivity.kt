package com.example.android_example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.annotation.NonNull
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Face
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.android_example.ui.theme.Android_exampleTheme

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            Android_exampleTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    BottomTabExample()
                }
            }
        }
    }
}

@Composable
fun BottomTabExample() {
    val items = listOf("Greeting", "Flutter")
    var selectedItem by remember { mutableStateOf(0) }

    Scaffold(
        bottomBar = {
            NavigationBar {
                items.forEachIndexed { index, item ->
                    NavigationBarItem(
                        icon =  {
                            Icon(
                                imageVector = when (index) {
                                    0 -> Icons.Filled.Home // 首页图标
                                    1 -> Icons.Filled.Info
                                    else -> Icons.Filled.Info
                                },
                                contentDescription = null
                            )
                        },
                        label = { Text(item) },
                        selected = selectedItem == index,
                        onClick = { selectedItem = index }
                    )
                }
            }
        }
    ) { innerPadding ->
        Box(modifier = Modifier.padding(innerPadding)) {
            when (selectedItem) {
                0 -> Greeting("Android")
                1 -> FlutterViewButton()
            }
        }
    }
}

@Composable
fun Greeting(name: String) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        contentAlignment = Alignment.Center
    ) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Icon(
                imageVector = Icons.Default.Face, // 使用Material Design 3自带的图标
                contentDescription = "Favorite", // 为辅助功能提供描述
                modifier = Modifier.size(24.dp) // 根据需要调整图标大小
            )
            Text(text = "Hello $name!")
        }

    }
}


@Composable
fun FlutterViewButton() {
    val context = LocalContext.current
    Box(
        contentAlignment = Alignment.Center, // 设置内容居中
        modifier = Modifier.fillMaxSize() // 确保 Box 填充父容器
    ) {
        Button(onClick = {
            println("Button Clicked")
            context.startActivity(
                CustomFlutterActivity.withCachedEngine("flutter_engine").build(context)
            )
        }, modifier = Modifier.padding(16.dp)) {
            Text("Show Flutter")
        }
    }
}

@Preview(showBackground = true)
@Composable
fun DefaultPreview() {
    Android_exampleTheme {
        BottomTabExample()
    }
}

class CustomFlutterActivity : FlutterActivity() {
    private val channelName = "com.kryptogo.sdk/channel"

    companion object {
        fun withCachedEngine(engineId: String) = CustomCachedEngineIntentBuilder(engineId)
    }

    class CustomCachedEngineIntentBuilder(engineId: String) :
        CachedEngineIntentBuilder(CustomFlutterActivity::class.java, engineId)

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
        channel.setMethodCallHandler { call, result ->
            if (call.method == "closeFlutterView") {
                closeFlutterView()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }


        // Android 端主动調用 KG_SDK 並傳送 initialParams
        val initialParams = mapOf("flavor" to "prod")
        channel.invokeMethod("getInitialParam", initialParams)
    }

    private fun closeFlutterView() {
        finish()
    }
}
