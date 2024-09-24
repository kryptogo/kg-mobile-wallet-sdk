package com.example.android_example.models

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.android_example.KgSDKService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class WalletCenterViewModel : ViewModel() {
    private val kgSDKService = KgSDKService.getInstance()

    private val _balance = MutableStateFlow("0.0")
    val balance: StateFlow<String> = _balance

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading

    fun refreshBalance() {
        viewModelScope.launch {
            _isLoading.value = true
            try {
                val newBalance = kgSDKService.getBalance()
                
                _balance.value = newBalance?.toString() ?: "Error"
            } catch (e: Exception) {
                _balance.value = "Error: ${e.message}"
            } finally {
                _isLoading.value = false
            }
        }
    }

    fun openKGSDK(path: String) {
        viewModelScope.launch {
            kgSDKService.showKgSDK()
            kgSDKService.goRoute(path)
        }
    }
}