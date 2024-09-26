plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.kryptogo.android_example"
    compileSdk = 34

    fun flutterArchitectures(): List<String> {
        val value = project.properties["reactNativeArchitectures"]
        return value?.toString()?.split(",") ?: listOf("armeabi-v7a", "x86_64", "arm64-v8a")
    }

    defaultConfig {
        applicationId = "com.kryptogo.android_example"
        minSdk = 33
        targetSdk = 34
        versionCode = 3
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
        ndk {
            abiFilters.addAll(flutterArchitectures())
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = "key0"
            keyPassword = "Kg1234567890"
            storeFile = file("../../../../../keystore/sdk-sample-Kg1234567890")
            storePassword = "Kg1234567890"
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            // 如果需要，可以在这里添加debug特定的配置
        }
        create("profile") {
            initWith(getByName("debug"))
            // 如果需要，可以在这里添加profile特定的配置
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = "11"
    }
    buildFeatures {
        compose = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.1"
    }
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

val compose_version = "1.4.3"


dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    implementation("androidx.activity:activity-compose:1.8.2")
    implementation(platform("androidx.compose:compose-bom:2024.09.02"))
    implementation ("androidx.compose.ui:ui:$compose_version")
    implementation("androidx.compose.ui:ui-graphics:$compose_version")
    implementation ("androidx.compose.material3:material3:1.1.0")
    implementation ("androidx.compose.foundation:foundation:$compose_version")
    implementation("androidx.lifecycle:lifecycle-viewmodel-android:2.8.6")
    implementation("androidx.hilt:hilt-navigation-compose:1.0.0")
    implementation("androidx.navigation:navigation-compose:2.5.3")
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
    androidTestImplementation(platform("androidx.compose:compose-bom:2023.08.00"))
    androidTestImplementation("androidx.compose.ui:ui-test-junit4")
    debugImplementation("androidx.compose.ui:ui-tooling")
    debugImplementation("androidx.compose.ui:ui-test-manifest")
    debugImplementation ("com.kryptogo.kg_sdk:flutter_debug:1.0")
    releaseImplementation ("com.kryptogo.kg_sdk:flutter_release:1.0")
    add("profileImplementation", "com.kryptogo.kg_sdk:flutter_profile:1.0")
}