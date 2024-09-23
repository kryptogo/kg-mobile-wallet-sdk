package com.example.android_example

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
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
                colors = TopAppBarDefaults.smallTopAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primary,
                    titleContentColor = MaterialTheme.colorScheme.onPrimary
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
            Text("4G LTE", fontSize = 14.sp, color = MaterialTheme.colorScheme.primary)
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
                .height(8.dp)
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
            QuickActionButton("Bill Pay", Icons.Default.Add)
            QuickActionButton("Add Data", Icons.Default.Add)
            QuickActionButton("Support", Icons.Default.Add)
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
            modifier = Modifier.size(56.dp)
        ) {
            Icon(icon, contentDescription = text)
        }
        Text(text, fontSize = 12.sp)
    }
}

@Composable
fun SpecialOfferSection() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.secondaryContainer),
        shape = RoundedCornerShape(8.dp)
    ) {
        Row(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text("Summer Data Boost", fontWeight = FontWeight.Bold)
                Text("Get 5GB extra data for free!", fontSize = 14.sp)
            }
            Icon(Icons.Default.Add, contentDescription = "More info", tint = MaterialTheme.colorScheme.primary)
        }
    }
}