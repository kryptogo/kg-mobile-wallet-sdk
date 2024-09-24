package com.example.android_example

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.outlined.AddCircle
import androidx.compose.material.icons.outlined.ArrowForward
import androidx.compose.material.icons.outlined.Send
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.android_example.models.WalletCenterViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WalletCenterScreen(navController: NavController) {
    val viewModel: WalletCenterViewModel = viewModel()
    val balance by viewModel.balance.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val hasLocalShareKey by viewModel.hasLocalShareKey.collectAsState()
    val isWalletCreated by viewModel.isWalletCreated.collectAsState()

    LaunchedEffect(Unit) {
        viewModel.refreshAll()
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Wallet Center") },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(
                            imageVector = Icons.Filled.ArrowBack,
                            contentDescription = "Back"
                        )
                    }
                }
            )
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Text("Hi, Wallet", fontSize = 24.sp, fontWeight = FontWeight.Bold)
            
            Text("Total Balance", fontSize = 16.sp)
            Text(balance, fontSize = 32.sp, fontWeight = FontWeight.Bold)
            
            Button(
                onClick = { viewModel.refreshAll() },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF2196F3)),
                enabled = !isLoading
            ) {
                if (isLoading) {
                    SimpleLoadingIndicator(color = Color.White, modifier = Modifier.size(24.dp))
                } else {
                    Text("Refresh Balance")
                }
            }
            
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(8.dp)
            ) {
                if (hasLocalShareKey && isWalletCreated) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        ActionItem(icon = Icons.Outlined.Send, text = "Send") {
                            viewModel.openKGSDK("/send_token/select_token")
                        }
                        Divider()
                        ActionItem(icon = Icons.Outlined.ArrowForward, text = "Swap") {
                            viewModel.openKGSDK("/swap")
                        }
                        Divider()
                        ActionItem(icon = Icons.Outlined.AddCircle, text = "Receive") {
                            viewModel.openKGSDK("/receive_address")
                        }
                    }
                } else {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp)
                            .clickable { viewModel.openKGSDK("/wallet/create") },
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = "Tap to create wallet",
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.primary
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun ActionItem(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    text: String,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = Color(0xFF2196F3),
            modifier = Modifier.size(24.dp)
        )
        Spacer(modifier = Modifier.width(16.dp))
        Text(text, fontSize = 16.sp)
    }
}