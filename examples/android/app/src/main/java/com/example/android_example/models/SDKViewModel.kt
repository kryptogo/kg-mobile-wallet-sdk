import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.delay
import android.content.SharedPreferences
import com.example.android_example.KgSDKService

class SDKViewModel(private val sharedPreferences: SharedPreferences) : ViewModel() {
    private val clientTokenKey = "KgSDKClientToken"

    private val _sdkStatus = MutableStateFlow(false)
    val sdkStatus: StateFlow<Boolean> = _sdkStatus

    private val _isCheckingReady = MutableStateFlow(false)
    val isCheckingReady: StateFlow<Boolean> = _isCheckingReady

    private val _clientToken = MutableStateFlow("")
    val clientToken: StateFlow<String> = _clientToken

    private val _balance = MutableStateFlow("")
    val balance: StateFlow<String> = _balance

    init {
        // Load saved clientToken from SharedPreferences
        _clientToken.value = sharedPreferences.getString(clientTokenKey, "") ?: ""
    }

    fun checkIsReady() {
        viewModelScope.launch {
            _isCheckingReady.value = true
            checkReadyStatus()
        }
    }

    fun setClientToken(token: String) {
        viewModelScope.launch {
            _clientToken.value = token
            // Save the clientToken to SharedPreferences
            sharedPreferences.edit().putString(clientTokenKey, token).apply()
            setInitParamsInternal(token)
            checkIsReady() // 在 setInitParamsInternal 之後檢查 SDK 是否準備好
        }
    }

    private fun setInitParamsInternal(clientToken: String) {
        // Get the instance of KgSDKService
       val sdkService = KgSDKService.getInstance()
       sdkService.sendInitParams(clientToken)
    }

    private suspend fun checkReadyStatus() {
        _isCheckingReady.value = true
        val sdkService = KgSDKService.getInstance()
        val isReady = sdkService.isReady() as? Boolean ?: false // 呼叫 SDK 的 isReady 方法
        if (isReady) {
            _sdkStatus.value = true
            _isCheckingReady.value = false
            getBalance()
        } else {
            delay(10000) // Wait for 1 second before checking again
            checkReadyStatus()
        }
    }

    private suspend fun getBalance() {
        delay(1000) // Simulating network delay
        // TODO: Replace this with actual balance fetching logic
        _balance.value = "100.00" // Placeholder value
    }

    fun refreshSDKStatus() {
        viewModelScope.launch {
            checkIsReady()
        }
    }
}