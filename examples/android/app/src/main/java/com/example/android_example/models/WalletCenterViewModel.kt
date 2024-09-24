package com.example.android_example.models

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.android_example.KgSDKService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class WalletCenterViewModel : ViewModel() {
    private val kgSDKService = KgSDKService.getInstance()

    private val _balance = MutableStateFlow("No Balance")
    val balance: StateFlow<String> = _balance

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading

    private val _hasLocalShareKey = MutableStateFlow(false)
    val hasLocalShareKey: StateFlow<Boolean> = _hasLocalShareKey

    private val _isWalletCreated = MutableStateFlow(false)
    val isWalletCreated: StateFlow<Boolean> = _isWalletCreated

    fun refreshAll() {
        viewModelScope.launch {
            refreshBalance()
            checkHasLocalShareKey()
            checkIsWalletCreated()
        }
    }

    private fun refreshBalance() {
        viewModelScope.launch {
            _isLoading.value = true
            try {
                val newBalance = kgSDKService.getBalance()
                
                _balance.value = newBalance?.toString() ?: "No balance"
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

    fun checkHasLocalShareKey() {
        viewModelScope.launch {
            try {
                val hasKey = kgSDKService.hasLocalShareKey()
                _hasLocalShareKey.value = hasKey
                println("hasLocalShareKey: $hasKey")
            } catch (e: Exception) {
                println("hasLocalShareKey error: ${e.message}")
            }
        }
    }

    fun checkIsWalletCreated() {
        viewModelScope.launch {
            try {
                val isCreated = kgSDKService.isWalletCreated()
                _isWalletCreated.value = isCreated
                println("isWalletCreated: $isCreated")
            } catch (e: Exception) {
                println("isWalletCreated error: ${e.message}")
            }
        }
    }
}