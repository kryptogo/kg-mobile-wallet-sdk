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
                imageVector = Icons.Default.Face,
                contentDescription = "Favorite",
                modifier = Modifier.size(24.dp)
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
           KgSDKService.getInstance(context).callKgSDK("testFuture")
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

