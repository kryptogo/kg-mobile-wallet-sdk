package com.kryptogo.android_example

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Call
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.ThumbUp
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DataUsageApp() {
    MaterialTheme {
        DataUsageScreen()
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DataUsageScreen() {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("iPhone 16") },
                colors = TopAppBarDefaults.mediumTopAppBarColors(
                    containerColor = MaterialTheme.colorScheme.background,
                    titleContentColor = MaterialTheme.colorScheme.onBackground
                )
            )
        },
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .padding(16.dp)
        ) {
            WelcomeSection()
            Spacer(modifier = Modifier.height(16.dp))
            DataUsageSection()
            Spacer(modifier = Modifier.height(24.dp))
            QuickActionsSection()
            Spacer(modifier=Modifier.weight(1f))
            SpecialOfferSection()
        }
    }
}

@Composable
fun WelcomeSection() {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Column {
            Text("Welcome", fontSize = 14.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Text("John Doe", fontSize = 24.sp, fontWeight = FontWeight.Bold)
        }
        Column(horizontalAlignment = Alignment.End) {
            Text("Network Status", fontSize = 14.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Text("4G LTE", fontSize = 14.sp, color = Color(0xFF4CAF50))  // Green color for network status
        }
    }
}

@Composable
fun DataUsageSection() {
    Column {
        Text("Data Usage", fontSize = 18.sp, fontWeight = FontWeight.Bold)
        Spacer(modifier = Modifier.height(8.dp))
        Text("15.2 GB / 20 GB", fontSize = 16.sp)
        LinearProgressIndicator(
            progress = 0.76f,
            modifier = Modifier
                .fillMaxWidth()
                .height(8.dp),
            color = Color(0xFF2196F3)  // Blue color for progress bar
        )
        Text("6 days remaining", fontSize = 14.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
    }
}

@Composable
fun QuickActionsSection() {
    Column {
        Text("Quick Actions", fontSize = 18.sp, fontWeight = FontWeight.Bold)
        Spacer(modifier = Modifier.height(8.dp))
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            QuickActionButton("Bill Pay", Icons.Default.ThumbUp)
            QuickActionButton("Add Data", Icons.Default.Add)
            QuickActionButton("Support", Icons.Default.Call)
            QuickActionButton("Settings", Icons.Default.Settings)
        }
    }
}

@Composable
fun QuickActionButton(text: String, icon: ImageVector) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        FilledTonalButton(
            onClick = { /* TODO */ },
            shape = RoundedCornerShape(8.dp),
            modifier = Modifier.size(56.dp),
            contentPadding = PaddingValues(0.dp),  // 移除按鈕內部的 padding
            colors = ButtonDefaults.filledTonalButtonColors(containerColor = Color(0xFF2196F3))  // Blue color for buttons
        ) {
            Icon(
                icon,
                contentDescription = text,
                tint = Color.White,
                modifier = Modifier.size(24.dp)
            )
        }
        Text(text, fontSize = 12.sp)
    }
}

@Composable
fun SpecialOfferSection() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = Color(0xFFFFCCCB)),  // Light red color for special offer
        shape = RoundedCornerShape(8.dp)
    ) {
        Row(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(
                    imageVector = Icons.Default.Favorite, // 或使用其他更適合的禮物圖標
                    contentDescription = "Gift",
                    tint = Color(0xFFFF6B6B), // 使用紅色
                    modifier = Modifier.size(24.dp)
                )
                Spacer(modifier = Modifier.width(8.dp))
                Column {
                    Text("Summer Data Boost", fontWeight = FontWeight.Bold, color = Color.Black)
                    Text("Get 5GB extra data for free!", fontSize = 14.sp, color = Color.Black)
                }
            }
            Icon(
                imageVector = Icons.Default.Add,
                contentDescription = "More info",
                tint = Color(0xFFFF6B6B) // 使用紅色
            )
        }
    }
}