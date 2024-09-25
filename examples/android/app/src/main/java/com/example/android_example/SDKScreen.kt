package com.kryptogo.android_example

import SDKViewModel
import android.content.Context
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Clear
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Face
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.rounded.Face
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.rotate
import androidx.navigation.NavController

@Composable
fun SDKScreen(navController: NavController) {
    val context = LocalContext.current
    val viewModel: SDKViewModel = viewModel { 
        SDKViewModel(context.getSharedPreferences("sdk_prefs", Context.MODE_PRIVATE))
    }

    val sdkStatus by viewModel.sdkStatus.collectAsState()
    val isCheckingReady by viewModel.isCheckingReady.collectAsState()
    val savedClientToken by viewModel.clientToken.collectAsState()
    var clientTokenInput by remember { mutableStateOf(savedClientToken) }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.Start
        ) {
            Text(
                text = "SDK",
                style = MaterialTheme.typography.headlineLarge,
                modifier = Modifier.padding(bottom = 12.dp)
            )
            Text(
                text = "SDK Status",
                style = MaterialTheme.typography.bodyLarge,
                modifier = Modifier.padding(bottom = 8.dp)
            )
            
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 16.dp),
                colors = CardDefaults.cardColors(containerColor = when {
                    isCheckingReady -> Color(0xFFF5F5F5) // Light gray for checking
                    sdkStatus -> Color(0xFFE8F5E9) // Light green for ready
                    else -> Color(0xFFFFEBEE) // Light red for not ready
                })
            ) {
                Row(
                    modifier = Modifier.padding(8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    if (isCheckingReady) {
                        SimpleLoadingIndicator(
                            modifier = Modifier.size(24.dp),
                            color = Color(0xFFFFA000) // Amber for checking
                        )
                    } else {
                        Icon(
                            imageVector = if (sdkStatus) Icons.Default.Check else Icons.Default.Close,
                            contentDescription = null,
                            tint = if (sdkStatus) Color(0xFF4CAF50) else Color(0xFFE57373)
                        )
                    }
                    Text(
                        text = when {
                            isCheckingReady -> "SDK is checking"
                            sdkStatus -> "SDK is ready"
                            else -> "SDK is not ready"
                        },
                        color = when {
                            isCheckingReady -> Color(0xFFFFA000) // Amber for checking
                            sdkStatus -> Color(0xFF4CAF50) // Green for ready
                            else -> Color(0xFFE57373) // Red for not ready
                        },
                        modifier = Modifier.padding(start = 8.dp)
                    )
                }
            }
            
            Button(
                onClick = { viewModel.refreshSDKStatus() },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 16.dp),
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF4CAF50))
            ) {
                Icon(
                    imageVector = Icons.Default.Refresh,
                    contentDescription = null,
                    modifier = Modifier.padding(end = 8.dp)
                )
                Text("重新檢查 SDK 狀態")
            }
            
            OutlinedTextField(
                value = clientTokenInput,
                onValueChange = { clientTokenInput = it },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 16.dp),
                label = { Text("Client Token") }
            )
            
            Button(
                onClick = { viewModel.setClientToken(clientTokenInput) },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 16.dp),
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFFFA000))
            ) {
                Text("Set Client Token")
            }
            
            Button(
                onClick = { navController.navigate("walletScreen") },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF2196F3)),
                enabled = sdkStatus // 按鈕是否可點擊取決於 sdkStatus
            ) {
                Icon(
                    imageVector = Icons.Default.Face,
                    contentDescription = null,
                    modifier = Modifier.padding(end = 8.dp)
                )
                Text("Wallet Center")
            }
        }
    }
}

@Composable
fun SimpleLoadingIndicator(modifier: Modifier = Modifier, color: Color = Color.Blue) {
    val infiniteTransition = rememberInfiniteTransition()
    val angle by infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 360f,
        animationSpec = infiniteRepeatable(
            animation = tween(1000, easing = LinearEasing)
        )
    )

    Canvas(modifier = modifier) {
        rotate(angle) {
            drawArc(
                color = color,
                startAngle = 0f,
                sweepAngle = 300f,
                useCenter = false,
                style = Stroke(width = size.width / 10)
            )
        }
    }
}