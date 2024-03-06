pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        maven(url = "https://storage.googleapis.com/download.flutter.io")
        maven(url="../kg_sdk/android_sdk/repo")
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven(url = "https://storage.googleapis.com/download.flutter.io")
        maven(url="../kg_sdk/android_sdk/repo")
    }
}

rootProject.name = "android_example"
include(":app")
 