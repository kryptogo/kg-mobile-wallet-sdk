package com.example.android_example

import android.content.Context
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Face
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Info
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
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
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
    val items = listOf("Greeting", "Flutter", "Good")
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
                                    2 -> Icons.Filled.Add
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
                2 -> FlutterViewButton2()
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
        contentAlignment = Alignment.Center,
        modifier = Modifier.fillMaxSize()
    ) {
        Button(onClick = {
            println("Button Clicked")
            KgSDKService.getInstance(context).showKgSDK()
        }, modifier = Modifier.padding(16.dp)) {
            Text("Show KG_SDK")
        }

    }
}

@Composable
fun FlutterViewButton2() {
    val context = LocalContext.current
    Box(
        contentAlignment = Alignment.Center, // 设置内容居中
        modifier = Modifier.fillMaxSize() // 确保 Box 填充父容器
    ) {
        Button(onClick = {
           KgSDKService.getInstance(context).callKgSDK()
        }, modifier = Modifier.padding(16.dp)) {
            Text("Call KG_SDK")
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
